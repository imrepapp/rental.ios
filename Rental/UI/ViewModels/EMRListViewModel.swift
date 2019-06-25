//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa
import RxFlow
import RealmSwift
import Swinject
import EVReflection

struct EMRListParameters: Parameters {
    let type: EMRType
    let emrId: String
}

class EMRListViewModel: BaseIntervalSyncViewModel<[RenEMRLine]>, BarcodeScannerViewModel {
    var barcode: String? = nil
    var shouldProcessBarcode: Bool = false

    private var _parameters = EMRListParameters(type: EMRType.Receiving, emrId: "")

    let emrLines = BehaviorRelay<[EMRItemViewModel]>(value: [EMRItemViewModel]())
    let selectEMRLineCommand = PublishRelay<EMRItemViewModel>()
    let actionCommand = PublishRelay<Void>()
    let enterBarcodeCommand = PublishRelay<Void>()
    let menuCommand = PublishRelay<Void>()
    let processBarcode = PublishRelay<String>()

    let searchText = BehaviorRelay<String?>(value: "")
    let searchCommand = PublishRelay<Void>()

    lazy var isShippingButtonHidden = ComputedBehaviorRelay<Bool>(value: { [unowned self] () -> Bool in
        if self._parameters.emrId.isEmpty {
            return true
        }

        if BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@ and isScanned = Yes", argumentArray: [self._parameters.emrId])).count > 0 {
            return false
        }

        return true
    })

    lazy var actionButtonTitle = ComputedBehaviorRelay<String?>(value: { [unowned self] () -> String? in
        guard !self._parameters.emrId.isEmpty else {
            return nil
        }

        var linesCount = BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@", argumentArray: [self._parameters.emrId])).count
        var scannedLinesCount = BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@ and isScanned = Yes", argumentArray: [self._parameters.emrId])).count
        var title = self._parameters.type == .Shipping ? "Shipping" : "Receiving"

        if linesCount != scannedLinesCount {
            title = String(format: "Partial %@ (%d/%d)", title, linesCount, scannedLinesCount)
        }

        return title
    })

    override var dependencies: [BaseSyncDataAccessObject.Type] {
        return [
            RenWorkerWarehouseDAO.self,
            RenEMRTableDAO.self,
            RenEMRLineDAO.self,
            RenReplacementReasonDAO.self,
            WorkerInvLocationsDAO.self,
            RenParametersDAO.self,
            DamageCodesDAO.self,
            DamageHistoryDAO.self
        ]
    }
    override var datasource: Observable<[RenEMRLine]> {
        if !_parameters.emrId.isEmpty {
            return BaseDataProvider.DAO(RenEMRLineDAO.self).filterAsync(predicate: NSPredicate(format: "emrId = %@", argumentArray: [_parameters.emrId]))
        }

        let workerWarehouses = BaseDataProvider.DAO(RenWorkerWarehouseDAO.self)
                .filter(predicate: NSPredicate(format: "activeWarehouse = %@", argumentArray: ["Yes"]))
                .map {
                    $0.inventLocationId
                }

        if workerWarehouses.isEmpty {
            return Observable<[RenEMRLine]>.empty()
        }

        var predicateStr = "emrType == %i AND emrStatus != 'Cancelled'"
        var params: [Any] = []
        params.append(_parameters.type.rawValue)
        var fromDirection: [String] = []
        var toDirection: [String] = []

        switch _parameters.type {
        case .Shipping:
            predicateStr += " && isShipped = 0"
            fromDirection.append(contentsOf: ["Outbound", "Internal"])
            toDirection.append(contentsOf: ["Inbound"])
        case .Receiving:
            predicateStr += " && isReceived = 0"
            fromDirection.append(contentsOf: ["Outbound"])
            toDirection.append(contentsOf: ["Internal", "Inbound"])
        case .Other:
            return Observable<[RenEMRLine]>.empty()
        }

        predicateStr += "  AND ((direction IN %@ AND fromInventLocation IN %@) OR (direction IN %@ AND toInventLocation IN %@) OR direction == 'BetweenJobsites')"

        var args: [Any] = [
            _parameters.type.rawValue,
            fromDirection,
            workerWarehouses,
            toDirection,
            workerWarehouses]

        if (!searchText.val!.isEmpty) {
            predicateStr += "  AND (equipmentId contains %@ OR inventSerialId contains %@ OR fromAddressDisplay contains %@ OR toAddressDisplay contains %@  )"
            args.append(searchText.val!)
            args.append(searchText.val!)
            args.append(searchText.val!)
            args.append(searchText.val!)
        }


        return BaseDataProvider.DAO(RenEMRLineDAO.self).filterAsync(predicate: NSPredicate(format: predicateStr, argumentArray: args))
    }

    override func instantiate(with params: Parameters) {
        _parameters = params as! EMRListParameters

        title.val = "\(_parameters.type)"

        isShippingButtonHidden.raise()
        actionButtonTitle.raise()

        AppDelegate.settings.syncConfig.lastTime = Date()

        menuCommand += { _ in
            let lines = BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@ and isScanned = No", argumentArray: [self._parameters.emrId]))

            if lines.count > 0 {
                self.send(message: .alert(config: AlertConfig(title: "", message: "Not all EMR lines have been scanned. Are you sure you want to leave the EMR?", actions: [
                    UIAlertAction(title: "Yes", style: .default, handler: { alert in
                        self.next(step: RentalStep.menu)
                    }),
                    UIAlertAction(title: "No", style: .cancel, handler: nil)
                ])))
            } else {
                self.next(step: RentalStep.menu)
            }
        } => disposeBag

        selectEMRLineCommand += { emrItem in
            self.next(step: RentalStep.EMRLine(EMRLineParameters(emrLine: emrItem)))
        } => disposeBag

        actionCommand += { _ in
            guard let emr = BaseDataProvider.DAO(RenEMRTableDAO.self).lookUp(id: self._parameters.emrId) else {
                self.send(message: .msgBox(title: "Error", message: "Unrecognized EMR!"))
                self.isLoading.val = false
                return
            }

            let lines = BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@", argumentArray: [self._parameters.emrId]))

            if lines.filter({ $0.isScanned }).count == 0 {
                self.send(message: .msgBox(title: "Error", message: "There aren't any scanned lines."))
                return
            }

            let mandatoryPhoto = self._parameters.type == .Shipping
                    ? (BaseDataProvider.DAO(RenParametersDAO.self).items.first?.numOfReqiredPhotosForShipping ?? 0)
                    : (BaseDataProvider.DAO(RenParametersDAO.self).items.first?.numOfReqiredPhotosForReceiving ?? 0)

            if mandatoryPhoto > 0 {
                //var realm = try! Realm()
                let missingPhotos: [String] = lines.filter {
                    $0.uploadedPhotos.count != mandatoryPhoto && $0.isScanned
                }.map {
                    $0.listItemId
                }

                if missingPhotos.count > 0 {
                    self.send(message: .msgBox(title: "Error", message: String(format: "Upload %d photo(s) to the following lines is mandatory:\n%@.", arguments: [
                        mandatoryPhoto,
                        missingPhotos.joined(separator: "\n")
                    ])))
                    return
                }
            }

            //TODO Checklist check

            var msg = String(format: "Would you like to %@ this EMR?", arguments: [self._parameters.type == .Shipping ? "ship" : "receive"])
            let linesCount = lines.count
            let scannedLinesCount = BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@ and isScanned = Yes", argumentArray: [self._parameters.emrId])).count

            if linesCount != scannedLinesCount {
                msg = String(format: "Not all lines on %@ have been scanned.\n\nWould you like to proceed with partial %@ on this EMR?", arguments: [
                    self._parameters.emrId,
                    self._parameters.type == .Shipping ? "shipping" : "receiving"
                ])
            }

            self.send(message: .alert(config: AlertConfig(
                    title: "",
                    message: msg,
                    actions: [
                        UIAlertAction(title: "Yes", style: .default, handler: { alert in
                            if linesCount == scannedLinesCount {
                                self._post(emr)
                            } else {
                                self._partialPost(emr)
                            }
                        }),
                        UIAlertAction(title: "No", style: .cancel, handler: nil)
                    ])))
        } => disposeBag

        enterBarcodeCommand += { _ in
            self.next(step: RentalStep.manualScan(onSelect: { bc in
                self.barcodeDidScanned(bc)
            }))
        } => disposeBag

        processBarcode += { bc in
            self.isLoading.val = true

            AppDelegate.instance.container.resolve(BarcodeScan.self)!.checkAndScan(barcode: bc, emrId: self._parameters.emrId, type: self._parameters.type.rawValue)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { line in
                        self.isShippingButtonHidden.raise()
                        self.actionButtonTitle.raise()
                        self.send(message: .alert(config: AlertConfig(title: "Ok", message: String(format: "%@\n%@\nTotal EMR lines: %d\nScanned lines: %d", arguments: [
                            line.listItemId,
                            line.emrId,
                            BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@", argumentArray: [line.emrId])).count,
                            BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@ and isScanned = Yes", argumentArray: [line.emrId])).count
                        ]), actions: [
                            UIAlertAction(title: "Ok", style: .default, handler: { alert in
                                self.isLoading.val = true
                                self.next(step: RentalStep.EMRLine(EMRLineParameters(emrLine: EMRItemViewModel(line))))
                            })
                        ])))
                    }, onError: { error in
                        if let e = error as? BarcodeScanError {
                            switch e {
                            case .Error(let msg):
                                self.send(message: .msgBox(title: "Error", message: msg))
                            case .EqBarcode(let eqBarcode):
                                self.createEMROrReceive(eqBarcode)
                            case .NotOnThisEMR(let foundLine):
                                self.send(message: .alert(config: AlertConfig(title: "", message: "The scanned equipment is on a different EMR than the one you begin to scan. Are you sure you want to scan the equipment?", actions: [
                                    UIAlertAction(title: "Yes", style: .default, handler: { alert in
                                        self._parameters = EMRListParameters(type: self._parameters.type, emrId: foundLine.emr!.id)
                                        self.loadData()
                                        self.processBarcode.accept(bc)
                                    }),
                                    UIAlertAction(title: "No", style: .cancel, handler: { alert in

                                    })
                                ])))
                            case .Unknown, .NotFound:
                                self.send(message: .msgBox(title: "Error", message: "An error has occurred"))
                            }
                        }
                        self.isLoading.val = false
                    }, onCompleted: {
                        self.isLoading.val = false
                    }) => self.disposeBag
        } => disposeBag

        self.rx.viewAppeared += { _ in
            if self.barcode != nil && self.shouldProcessBarcode {
                self.processBarcode.accept(self.barcode!)
            }

            self.barcode = nil
            self.shouldProcessBarcode = false
        } => disposeBag

        searchText.throttle(0.5, scheduler: MainScheduler.instance).subscribe(onNext: { st in

            self.loadData()

        }) => self.disposeBag
    }

    override func loadData(data: [RenEMRLine]) {
        emrLines.val = data.map({ EMRItemViewModel($0) })
        isShippingButtonHidden.raise()
        actionButtonTitle.raise()
    }

    private func _post(_ emr: RenEMRTable) {
        self.isLoading.val = true

        switch self._parameters.type {
        case .Shipping:
            emr.isShipped = "Yes"
            break

        case .Receiving:
            emr.isReceived = "Yes"
            break

        case .Other:
            self.send(message: .msgBox(title: "Error", message: "Cannot ship or receive this EMR!"))
            return
        }

        emr.operation = "UpdateShippingEMR"

        BaseDataProvider.DAO(RenEMRTableDAO.self).updateAndPushIfOnline(model: emr)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { _ in
                    let realm = try! Realm()

                    for l in BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@", argumentArray: [emr.id])) {
                        if self._parameters.type == .Shipping {
                            l.isScanned = false
                        }

                        l.isShipped = self._parameters.type == .Shipping ? true : l.isShipped
                        l.isReceived = self._parameters.type == .Receiving ? true : l.isReceived

                        try! realm.write {
                            let entity = MOB_RenEMRTable(dictionary: l.toDictionary())
                            realm.add(entity, update: true)
                        }
                    }

                    self.isLoading.val = false
                    self.send(message: .msgBox(title: "Success", message: String(format: "Success %@!", arguments: [
                        self._parameters.type == .Shipping ? "shipping" : "receiving"
                    ])))
                }, onError: { error in
                    self.isLoading.val = false
                    self.send(message: .msgBox(title: "Error", message: error.message))

                    // restore modifications
                    emr.isShipped = self._parameters.type == .Shipping ? "No" : emr.isShipped
                    emr.isReceived = self._parameters.type == .Receiving ? "No" : emr.isReceived

                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(emr, update: true)
                    }
                }) => disposeBag
    }

    private func _partialPost(_ emr: RenEMRTable) {
        self.isLoading.val = true

        let scannedLines = BaseDataProvider.DAO(RenEMRLineDAO.self)
                .filter(predicate: NSPredicate(format: "emrId = %@ and isScanned = Yes", argumentArray: [self._parameters.emrId]))
                .map {
                    $0.id
                }
                .joined(separator: ",")

        if scannedLines.isEmpty {
            self.send(message: .msgBox(title: "Error", message: "There aren't any scanned lines."))
            self.isLoading.val = false
            return
        }

        AppDelegate.api.partialPostEMR(scannedLines)
                .observeOn(MainScheduler.instance)
                .subscribe(onCompleted: {
                    let realm = try! Realm()
                    try! realm.write {
                        for l in BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@ and isScanned = Yes", argumentArray: [emr.id])) {
                            let model = MOB_RenEMRLine.init(dictionary: (l as EVReflectable).toDictionary())

                            if self._parameters.type == .Shipping {
                                model.isScanned = false
                            }

                            model.isShipped = self._parameters.type == .Shipping ? true : l.isShipped
                            model.isReceived = self._parameters.type == .Receiving ? true : l.isReceived
                            realm.add(model, update: true)
                        }

                        let model = MOB_RenEMRTable.init(dictionary: emr.toDictionary())
                        model.isShipped = "Yes"
                        realm.add(model, update: true)
                    }

                    self.isLoading.val = false
                    self.send(message: .alert(config: AlertConfig(title: "Success", message: "Save was successful.", actions: [
                        UIAlertAction(title: "Ok", style: .default, handler: { alert in
                            self.next(step: RentalStep.EMRList(EMRListParameters(type: self._parameters.type, emrId: "")))
                        })
                    ])))
                }, onError: { error in
                    self.isLoading.val = false
                    self.send(message: .msgBox(title: "Error", message: error.message))
                }) => disposeBag
    }
}

enum EMRType: Int {
    case Other
    case Shipping
    case Receiving
}
