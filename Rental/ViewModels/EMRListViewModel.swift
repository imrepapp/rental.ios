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

struct EMRListParameters: Parameters {
    let type: EMRType
    let emrId: String
}

class EMRListViewModel: BaseIntervalSyncViewModel<[RenEMRLine]>, BarcodeScannerViewModel {
    var barcode: String? = nil
    var shouldProcessBarcode: Bool = false

    private var _parameters = EMRListParameters(type: EMRType.Receiving, emrId: "")
    private var _isShippingButtonEnabled: Bool {
        get {
            let defaultResult = !isShippingButtonHidden.val
                    && emrLines.val.filter {
                $0.emrId.val == _parameters.emrId && $0.isScanned.val
            }.count == emrLines.val.filter {
                $0.emrId.val == _parameters.emrId
            }.count
            var handleResult = false

            switch _parameters.type {
            case .Shipping:
                handleResult = emrLines.val.filter {
                    $0.emrId.val == _parameters.emrId && $0.isShipped.val
                }.count
                        == emrLines.val.filter {
                    $0.emrId.val == _parameters.emrId
                }.count
                break

            case .Receiving:
                handleResult = emrLines.val.filter {
                    $0.emrId.val == _parameters.emrId && $0.isReceived.val
                }.count
                        == emrLines.val.filter {
                    $0.emrId.val == _parameters.emrId
                }.count
                break

            case .Other:

                break;
            }

            return defaultResult && !handleResult
        }
    }

    let emrLines = BehaviorRelay<[EMRItemViewModel]>(value: [EMRItemViewModel]())
    let selectEMRLineCommand = PublishRelay<EMRItemViewModel>()
    let actionCommand = PublishRelay<Void>()
    let enterBarcodeCommand = PublishRelay<Void>()
    let menuCommand = PublishRelay<Void>()
    let isShippingButtonHidden = BehaviorRelay<Bool>(value: true)
    let processBarcode = PublishRelay<String>()

    let searchText = BehaviorRelay<String?>(value: "")
    let searchCommand = PublishRelay<Void>()

    lazy var isShippingButtonEnabled = ComputedBehaviorRelay<Bool>(value: { [unowned self] () -> Bool in
        return self._isShippingButtonEnabled
    })

    override var dependencies: [BaseDataAccessObjectProtocol.Type] {
        return [
            RenWorkerWarehouseDAO.self,
            RenEMRTableDAO.self,
            RenEMRLineDAO.self
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
            predicateStr += "  AND (equipmentId contains %@ OR inventSerialId contains %@ )"
            args.append(searchText.val!)
            args.append(searchText.val!)
        }


        return BaseDataProvider.DAO(RenEMRLineDAO.self).filterAsync(predicate: NSPredicate(format: predicateStr, argumentArray: args))
    }

    override func instantiate(with params: Parameters) {
        _parameters = params as! EMRListParameters

        title.val = "\(_parameters.type)"

        isShippingButtonHidden.val = _parameters.emrId.isEmpty

        menuCommand += { _ in
            self.next(step: RentalStep.menu)
        } => disposeBag

        selectEMRLineCommand += { emrItem in
            self.next(step: RentalStep.EMRLine(EMRLineParameters(emrLine: emrItem)))
        } => disposeBag

        actionCommand += { _ in
            self.send(message: .msgBox(title: "\(self._parameters.type)".uppercased(), message: "ACTION!"))
        } => disposeBag

        enterBarcodeCommand += { _ in
            self.next(step: RentalStep.manualScan(onSelect: { bc in
                self.barcodeDidScanned(bc)
            }))
        } => disposeBag

        processBarcode += { bc in
            self.isLoading.val = true

            BarcodeScanService().checkAndScan(barcode: self.barcode!, emrId: "")
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { line in
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
                        self.isLoading.val = false
                        if let e = error as? BarcodeScanError {
                            switch e {
                            case .Error(let msg):
                                self.send(message: .msgBox(title: "Error", message: msg))
                            case .Unknown:
                                self.send(message: .msgBox(title: "Error", message: "An error has occurred"))
                            }
                        }
                    }, onCompleted: {
                        self.isLoading.val = false
                    }) => self.disposeBag
        }

        self.rx.viewAppeared += { _ in
            if self.barcode != nil && self.shouldProcessBarcode {
                self.processBarcode.accept(self.barcode!)
            }

            self.barcode = nil
            self.shouldProcessBarcode = false
        }

        searchText.subscribe(onNext: { st in

            //TODO Attila Késleltetve indítsa el
            self.loadData()

        }) => self.disposeBag
    }

    override func loadData(data: [RenEMRLine]) {
        emrLines.val = data.map({ EMRItemViewModel($0) })
        isShippingButtonEnabled.raise()
    }
}

public class ComputedBehaviorRelay<Element>: ObservableType {
    public typealias E = Element

    private let _subject: BehaviorSubject<Element>
    private let _value: () -> Element

    /// Emits it to subscribers
    public func raise() {
        self._subject.onNext(_value())
    }

    /// Current value of behavior subject
    public var value: Element {
        return _value()
    }

    /// Initializes behavior relay with initial value.
    public init(value: @escaping () -> Element) {
        self._value = value
        self._subject = BehaviorSubject(value: _value())
    }

    /// Subscribes observer
    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E {
        return self._subject.subscribe(observer)
    }

    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
}

enum EMRType: Int {
    case Other
    case Shipping
    case Receiving
}
