//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import EVReflection
import NMDEF_Base
import NMDEF_Sync
import MicrosoftAzureMobile_Xapt
import RealmSwift
import RxSwift
import RxCocoa
import Swinject

struct EMRLineParameters: Parameters {
    let emrLine: EMRItemViewModel
    var barcode: String?

    init (emrLine: EMRItemViewModel) {
        self.emrLine = emrLine
    }

    init (emrLine: EMRItemViewModel, barcode: String?) {
        self.emrLine = emrLine
        self.barcode = barcode
    }
}

class EMRLineViewModel: BaseViewModel, BarcodeScannerViewModel {

    private var _formType = EMRFormType.emr
    var formType = PublishRelay<EMRFormType>()

    var barcode: String? = nil
    var shouldProcessBarcode: Bool = false

    private var _parameters = EMRLineParameters(emrLine: EMRItemViewModel())
    private var _shouldReloadAfterBarcodeProcessing = false

    //let isNotReplaceableAttachment = BehaviorRelay<Bool>(value: true)
    lazy var isHiddenFromAddress = ComputedBehaviorRelay<Bool>(value: { [unowned self] () -> Bool in
        return self.emrLine.fromAddress.val!.isEmpty
    })
    lazy var isHiddenToAddress = ComputedBehaviorRelay<Bool>(value: { [unowned self] () -> Bool in
        return self.emrLine.toAddress.val!.isEmpty
    })

    let replaceAttachmentCommand = PublishRelay<Void>()

    let enterBarcodeCommand = PublishRelay<Void>()
    let photoCommand = PublishRelay<UIImage?>()
    let saveCommand = PublishRelay<Void>()
    let processBarcode = PublishRelay<String>()

    let fromMapCommand = PublishRelay<Void>()
    let toMapCommand = PublishRelay<Void>()

    let emrListCommand = PublishRelay<Void>()

    let startInspectionCommand = PublishRelay<Void>()
    let startCheckListCommand = PublishRelay<Void>()
    lazy var startCheckListBgr = ComputedBehaviorRelay<UIColor?>(value: { [unowned self] () -> UIColor? in
        if let line = BaseDataProvider.DAO(RenEMRLineDAO.self).lookUp(id: self._parameters.emrLine.id.val!), line.isChecked {
            return UIColor.green
        }

        return UIColor.init(red: 250 / 255, green: 200 / 255, blue: 23 / 255, alpha: 1.0)
    })

    var addPhotoParams: AddPhotoParams?

    lazy var emrButtonTitle = ComputedBehaviorRelay<String>(value: { [unowned self] () -> String in
        let emrCount = BaseDataProvider.DAO(RenEMRLineDAO.self)
                .filter(predicate: NSPredicate(format: "emrId = %@", argumentArray: [self.emrLine.emrId.val ?? "Nil value for emr count"])).count

        let emrScannedCount = BaseDataProvider.DAO(RenEMRLineDAO.self)
                .filter(predicate: NSPredicate(format: "emrId = %@ AND isScanned = Yes", argumentArray: [self.emrLine.emrId.val ?? "Nil value for emr scanned count"])).count

        return "EMR List (\(emrCount)/\(emrScannedCount))"
    })
    lazy var isScanViewHidden = ComputedBehaviorRelay<Bool>(value: { [unowned self] () -> Bool in
        //IsScanned or BulkItem
        return self._parameters.emrLine.isScanned.val || self._parameters.emrLine.itemTypeIsBulkItem.val
    })
    lazy var photoButtonTitle = ComputedBehaviorRelay<String>(value: { [unowned self] () -> String in
        var mandatoryPhoto = self._parameters.emrLine.asModel().emrType == 1
                ? BaseDataProvider.DAO(RenParametersDAO.self).items.first?.numOfReqiredPhotosForShipping ?? 0
                : BaseDataProvider.DAO(RenParametersDAO.self).items.first?.numOfReqiredPhotosForReceiving ?? 0
        var title = "Photo"

        if mandatoryPhoto > 0 {
            var realm = try! Realm()
            var photoCount = realm.objects(MOB_RenEMRLinePhoto.self).filter(NSPredicate(format: "lineId = %@", argumentArray: [self._parameters.emrLine.id.val!])).count

            title += " (\(mandatoryPhoto)/\(photoCount))"
        }

        return title
    })

    lazy var isCheckHidden = ComputedBehaviorRelay<Bool>(value: { [unowned self] () -> Bool in
        var result : Bool = false

        if (self._parameters.emrLine.asModel().emrType == 1) {
            //Ship
            if (BaseDataProvider.DAO(RenParametersDAO.self).items.first?.useChecklistForShipping == "No") {
                result = true
            }
        } else {
            //Receive
            if (BaseDataProvider.DAO(RenParametersDAO.self).items.first?.useChecklistForReceiving == "No") {
                result = true
            }
        }

        return result
    })

    lazy var isInspectHidden = ComputedBehaviorRelay<Bool>(value: { [unowned self] () -> Bool in
        var result : Bool = false

        if (self._parameters.emrLine.asModel().emrType == 1) {
            //Ship
            if (BaseDataProvider.DAO(RenParametersDAO.self).items.first?.activateInspectionForShipping == "No") {
                result = true
            }
        } else {
            //Receive
            if (BaseDataProvider.DAO(RenParametersDAO.self).items.first?.activateInspectionForReceiving == "No") {
                result = true
            }
        }

        //If not Rental
        if (self.emrLine.type.val! != "Rental") {
            result = true
        }

        return result
    })


    var emrLine: EMRItemViewModel {
        return _parameters.emrLine
    }

    override func instantiate(with params: Parameters) {
        _parameters = params as! EMRLineParameters

        title.val = "\(emrLine.type.val!): \(emrLine.emrId.val!)"

        replaceAttachmentCommand += { _ in
            self.next(step: RentalStep.replaceAttachment(self._parameters))
        } => disposeBag

        enterBarcodeCommand += { _ in
            self.next(step: RentalStep.manualScan(onSelect: { bc in
                self.barcodeDidScanned(bc)
            }))
        } => disposeBag

        photoCommand += { image in
            guard let img = image else {
                self.send(message: .msgBox(title: "Error", message: "Unable to upload the photo"))
                return
            }

            guard let base64 = img.jpegData(compressionQuality: 0.75)?.base64EncodedString() else {
                self.send(message: .msgBox(title: "Error", message: "Unable to upload the photo"))
                return
            }

            self.addPhotoParams = AddPhotoParams(emrLine: self.emrLine, base64Data: base64)
        } => disposeBag

        emrListCommand += { _ in
            self.next(step: RentalStep.EMRList(EMRListParameters(type: EMRType(rawValue: self._parameters.emrLine.emrType.val)!, emrId: self._parameters.emrLine.emrId.val!)))
        } => disposeBag

        startInspectionCommand += { _ in
            self.next(step: RentalStep.damageHandling(EMRLineParameters(emrLine: self._parameters.emrLine)))
        }

        startCheckListCommand += { _ in
            if let line = BaseDataProvider.DAO(RenEMRLineDAO.self).lookUp(id: self._parameters.emrLine.id.val!) {
                self.next(step: RentalStep.EMRCheckList(EMRCheckListParameters(line: line)))
                return
            }

            self.send(message: .msgBox(title: "Error", message: "Undetermined "))
        }

        saveCommand += { _ in
            if (self.emrLine.quantity.val != nil || self.emrLine.smu.val != nil || self.emrLine.secSMU.val != nil || self.emrLine.fuel.val != nil) {
                //TODO Bulk item eseten isScanned = true


                //Save
                self.isLoading.val = true

                var m = self.emrLine.asModel()
                m.operation = "UpdateShippingEMR"

                BaseDataProvider.DAO(RenEMRLineDAO.self).updateAndPushIfOnline(model: m)
                        .observeOn(MainScheduler.instance)
                        .map { result in
                            self.isLoading.val = false

                            if result {
                                //Success alert
                                self.send(message: .msgBox(title: self.title.val!, message: "Save was successful."))
                            } else {
                                //Unsuccess alert
                                self.send(message: .msgBox(title: self.title.val!, message: "Save was unsuccessful."))
                            }
                        }
                        .catchError({ error in
                            self.isLoading.val = false
                            if !error.message.isEmpty {
                                self.send(message: .msgBox(title: "Error", message: error.message))
                            } else {
                                self.send(message: .msgBox(title: "Error", message: "An error has been occurred"))
                            }

                            return Observable.empty()
                        }).subscribe() => self.disposeBag
            } else {
                self.send(message: .msgBox(title: self.title.val!, message: "Quantity, SMU, Secondary SMU and Fuel fields are required!"))
            }
        } => disposeBag

        fromMapCommand += { _ in
            if let fromAddress = self.emrLine.fromAddress.val {
                let fromString = "http://maps.apple.com/?address=" + fromAddress.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                if let url = URL(string: fromString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } => disposeBag

        toMapCommand += { _ in
            if let toAddress = self.emrLine.toAddress.val {
                let toString = "http://maps.apple.com/?address=" + toAddress.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                if let url = URL(string: toString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } => disposeBag

        processBarcode += { bc in
            self.isLoading.val = true
            AppDelegate.instance.container.resolve(BarcodeScan.self)!.checkAndScan(barcode: bc, emrId: self._parameters.emrLine.emrId.val!)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { line in
                        self._parameters.emrLine.isScanned.val = line.isScanned
                        self.send(message: .msgBox(title: "Ok", message: String(format: "%@\n%@\nTotal EMR lines: %d\nScanned lines: %d", arguments: [
                            line.listItemId,
                            line.emrId,
                            BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@", argumentArray: [line.emrId])).count,
                            BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@ and isScanned = Yes", argumentArray: [line.emrId])).count
                        ])))
                    }, onError: { error in
                        if let e = error as? BarcodeScanError {
                            switch e {
                            case .Error(let msg):
                                self.send(message: .msgBox(title: "Error", message: msg))
                            case .EqBarcode(let eqBarcode):
                                print(eqBarcode)
                            case .NotOnThisEMR(let foundLine):
                                self.send(message: .alert(config: AlertConfig(title: "", message: "The scanned equipment is on a different EMR than the one you begin to scan. Are you sure you want to scan the equipment?", actions: [
                                    UIAlertAction(title: "Yes", style: .default, handler: { alert in
                                        self.next(step: RentalStep.EMRLine(EMRLineParameters(emrLine: EMRItemViewModel(foundLine), barcode: bc)))
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
                        self.emrButtonTitle.raise()
                        self.isScanViewHidden.raise()
                    }) => self.disposeBag
        } => disposeBag

        if let bc = self._parameters.barcode {
            self.barcode = bc
            self.shouldProcessBarcode = true
            self._parameters.barcode = nil
        }

        self.rx.viewAppeared += { _ in
            if self.barcode != nil && self.shouldProcessBarcode {
                self.processBarcode.accept(self.barcode!)
            }

            self.barcode = nil
            self.shouldProcessBarcode = false

            if let app = self.addPhotoParams {
                self.next(step: RentalStep.addPhoto(app))
                self.addPhotoParams = nil
            }

            self.emrButtonTitle.raise()
            self.isScanViewHidden.raise()
            self.photoButtonTitle.raise()
            self.startCheckListBgr.raise()
            self.isHiddenFromAddress.raise()
            self.isHiddenToAddress.raise()
        } => disposeBag
    }
}