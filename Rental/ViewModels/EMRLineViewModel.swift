//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import EVReflection
import NMDEF_Base
import NMDEF_Sync
import MicrosoftAzureMobile_Xapt
import RxSwift
import RxCocoa
import Swinject

struct EMRLineParameters: Parameters {
    let emrLine: EMRItemViewModel
}

class EMRLineViewModel: BaseViewModel, BarcodeScannerViewModel {
    var barcode: String? = nil
    var shouldProcessBarcode: Bool = false

    private var _parameters = EMRLineParameters(emrLine: EMRItemViewModel())

    //let isNotReplaceableAttachment = BehaviorRelay<Bool>(value: true)
    let isHiddenFromAddress = BehaviorRelay<Bool>(value: true)
    let isHiddenToAddress = BehaviorRelay<Bool>(value: true)

    let replaceAttachmentCommand = PublishRelay<Void>()

    let enterBarcodeCommand = PublishRelay<Void>()
    let photoCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()
    let processBarcode = PublishRelay<String>()

    let fromMapCommand = PublishRelay<Void>()
    let toMapCommand = PublishRelay<Void>()

    let emrListCommand = PublishRelay<Void>()

    lazy var emrButtonTitle = ComputedBehaviorRelay<String>(value: { [unowned self] () -> String in
        let emrCount = BaseDataProvider.DAO(RenEMRLineDAO.self)
                .filter(predicate: NSPredicate(format: "emrId = %@", argumentArray: [self.emrLine.emrId.val])).count

        let emrScannedCount = BaseDataProvider.DAO(RenEMRLineDAO.self)
                .filter(predicate: NSPredicate(format: "emrId = %@ AND isScanned = Yes", argumentArray: [self.emrLine.emrId.val])).count

        return "EMR List (\(emrCount)/\(emrScannedCount))"
    })
    lazy var isScanViewHidden = ComputedBehaviorRelay<Bool>(value: { [unowned self] () -> Bool in
        return self._parameters.emrLine.isScanned.val
    })

    var emrLine: EMRItemViewModel {
        return _parameters.emrLine
    }

    override func instantiate(with params: Parameters) {
        _parameters = params as! EMRLineParameters

        title.val = "\(emrLine.type.val!): \(emrLine.emrId.val!)"

        //if attachment -> replaceable
        if (emrLine.itemType.val == "Attachment") {
            emrLine.isNotReplaceableAttachment.val = false
        } else {
            emrLine.isNotReplaceableAttachment.val = true
        }

        if (emrLine.fromAddress.val!.count > 0) {
            self.isHiddenFromAddress.val = false
        }

        if (emrLine.toAddress.val!.count > 0) {
            self.isHiddenToAddress.val = false
        }

        replaceAttachmentCommand += { _ in
            self.next(step: RentalStep.replaceAttachment(self._parameters))
        } => disposeBag

        enterBarcodeCommand += { _ in
            self.next(step: RentalStep.manualScan(onSelect: { bc in
                self.barcodeDidScanned(bc)
            }))
        } => disposeBag

        photoCommand += { _ in
            self.next(step: RentalStep.addPhoto(self._parameters))
        } => disposeBag

        emrListCommand += { _ in
            self.next(step: RentalStep.EMRList(EMRListParameters(type: EMRType(rawValue: self._parameters.emrLine.emrType.val)!, emrId: self._parameters.emrLine.emrId.val!)))
        } => disposeBag

        saveCommand += { _ in
            if (self.emrLine.quantity.val != nil || self.emrLine.smu.val != nil || self.emrLine.secSMU.val != nil || self.emrLine.fuel.val != nil) {
                //Save
                self.isLoading.val = true
                BaseDataProvider.DAO(RenEMRLineDAO.self).updateAndPushIfOnline(model: self.emrLine.asBaseEntity())
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
                            /*if var e = error.localizedDescription {
                                self.send(message: .msgBox(title: "Error", message: e))
                            } else {
                                self.send(message: .msgBox(title: "Error", message: "An error has been occurred"))
                            }*/

                            return Observable.empty()
                        }).subscribe() => self.disposeBag
            } else {
                self.send(message: .msgBox(title: self.title.val!, message: "Quantity, SMU, Secondary SMU and Fuel fields are required!"))
            }
        } => disposeBag

        fromMapCommand += { _ in
            if let fromAddress = self.emrLine.fromAddress.val {
                var fromString = "http://maps.apple.com/?address=" + fromAddress.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                if let url = URL(string: fromString) {
                    UIApplication.shared.openURL(url)
                }
            }
        } => disposeBag

        toMapCommand += { _ in
            if let toAddress = self.emrLine.toAddress.val {
                var toString = "http://maps.apple.com/?address=" + toAddress.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                if let url = URL(string: toString) {
                    UIApplication.shared.openURL(url)
                }
            }
        } => disposeBag

        processBarcode += { bc in
            self.isLoading.val = true
            AppDelegate.instance.container.resolve(BarcodeScan.self)!.checkAndScan(barcode: self.barcode!, emrId: self._parameters.emrLine.emrId.val!)
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
                        var errorStr = ""
                        if let e = error as? BarcodeScanError {
                            switch e {
                            case .Error(let msg):
                                self.send(message: .msgBox(title: "Error", message: msg))
                            case .Unknown:
                                self.send(message: .msgBox(title: "Error", message: "An error has occurred"))
                            }
                        }

                        self.isLoading.val = false
                    }, onCompleted: {
                        self.isLoading.val = false
                        self.emrButtonTitle.raise()
                        self.isScanViewHidden.raise()
                    }) => self.disposeBag
        }

        self.rx.viewAppeared += { _ in
            if self.barcode != nil && self.shouldProcessBarcode {
                self.processBarcode.accept(self.barcode!)
            }

            self.barcode = nil
            self.shouldProcessBarcode = false
        }

        emrButtonTitle.raise()
        isScanViewHidden.raise()
    }
}