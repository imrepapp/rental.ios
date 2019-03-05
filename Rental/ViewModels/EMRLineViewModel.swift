//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa

struct EMRLineParameters : Parameters {
    let emrLine: EMRItemViewModel
}

class EMRLineViewModel: BaseViewModel {
    private var _parameters = EMRLineParameters(emrLine: EMRItemViewModel())
    private var _emrButtonTitle: String {
        get {

            let emrCount = BaseDataProvider.DAO(RenEMRLineDAO.self)
                    .filter(predicate: NSPredicate(format: "emrId = %@", argumentArray: [emrLine.emrId.val])).count

            let emrScannedCount = BaseDataProvider.DAO(RenEMRLineDAO.self)
                    .filter(predicate: NSPredicate(format: "emrId = %@ AND isScanned = Yes", argumentArray: [emrLine.emrId.val])).count

            return "EMR List (\(emrCount)/\(emrScannedCount))"
        }
    }
    private var _shouldProcessBarcode = false
    private var _barcode: String?

    let isNotReplaceableAttachment = BehaviorRelay<Bool>(value: true)
    let replaceAttachmentCommand = PublishRelay<Void>()

    let enterBarcodeCommand = PublishRelay<Void>()
    let scanBarcodeCommand = PublishRelay<Void>()
    let photoCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()
    let barcodeDidScanned = PublishRelay<String>()
    let processBarcode = PublishRelay<String>()
    lazy var isScanViewHidden = ComputedBehaviorRelay<Bool>(value: { [unowned self] () -> Bool in
        return self._parameters.emrLine.isScanned.val
    })

    let emrListTitle = BehaviorRelay<String?>(value: nil)
    let emrListCommand = PublishRelay<Void>()

    lazy var emrButtonTitle = ComputedBehaviorRelay<String>(value: { [unowned self] () -> String in
        return self._emrButtonTitle
    })

    var emrLine: EMRItemViewModel {
        return _parameters.emrLine
    }

    override func instantiate(with params: Parameters) {
        _parameters = params as! EMRLineParameters

        title.val = "\(emrLine.type.val!): \(emrLine.emrId.val!)"

        emrListTitle.val = emrButtonTitle.value

        //if attachment -> replaceable
        if (emrLine.itemType.val == "Attachment") {
            emrLine.isNotReplaceableAttachment.val = false
        } else {
            emrLine.isNotReplaceableAttachment.val = true
        }

        replaceAttachmentCommand += { _ in
            self.next(step:RentalStep.replaceAttachment(self._parameters))
        } => disposeBag

        enterBarcodeCommand += { _ in
            self.next(step:RentalStep.manualScan(onSelect: { bc in
                self._barcode = bc
                self._shouldProcessBarcode = true
            }))
        } => disposeBag

        scanBarcodeCommand += { _ in
            self.send(message: .msgBox(title: self.title.val!, message: "SCAN!!"))
        } => disposeBag

        photoCommand += { _ in
            self.next(step:RentalStep.addPhoto(self._parameters))
        } => disposeBag

        emrListCommand += { _ in
            self.next(step:RentalStep.EMRList(EMRListParameters(type: EMRType(rawValue: self._parameters.emrLine.emrType.val)!, emrId: self._parameters.emrLine.emrId.val!)))
        } => disposeBag

        saveCommand += { _ in
            if (self.emrLine.quantity.val != nil || self.emrLine.smu.val != nil || self.emrLine.secSMU.val != nil || self.emrLine.fuel.val != nil) {
                //Save
                let result = BaseDataProvider.DAO(RenEMRLineDAO.self).updateAndPushIfOnline(model: self.emrLine.asBaseEntity())
                        .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                        .subscribeOn(MainScheduler.instance)
                        .subscribe({
                    completable in
                    switch completable {
                        case .next(let result):
                            if (result) {
                                //Success alert
                                self.send(message: .msgBox(title: self.title.val!, message: "Save was successful."))
                            } else {
                                //Unsuccess alert
                                self.send(message: .msgBox(title: self.title.val!, message: "Save was unsuccessful."))
                            }
                        case .error(let error):
                            self.send(message: .msgBox(title: self.title.val!, message: error.localizedDescription))
                        case .completed:
                            print("completed")
                    }
                }) => self.disposeBag
            }
            else
            {
                self.send(message: .msgBox(title: self.title.val!, message: "Quantity, SMU, Secondary SMU and Fuel fields are required!"))
            }
        } => disposeBag

        processBarcode += { bc in
            var errorStr = ""

            do {
                var service = BarcodeScanService()
                var line = try service.check(barcode: bc, emrId: self._parameters.emrLine.emrId.val!)

                if line.barCode != self._parameters.emrLine.barcode.val {
                    self.send(message: .msgBox(title: "Error", message: String(format: "The scanned barcode doesn't match with barcode of the selected equipment."
                            + "\nScanned barcode: %@"
                            + "\nItem barcode: %@", arguments: [line.barCode, self._parameters.emrLine.barcode.val!])))
                    return
                }

                if service.setAsScanned(line) {
                    self._parameters.emrLine.isScanned.val = line.isScanned
                    self.send(message: .alert(config: AlertConfig(title: "Ok", message: String(format: "%@\n%@\nTotal EMR lines: %d\nScanned lines: %d", arguments: [
                        line.listItemId,
                        line.emrId,
                        BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@", argumentArray: [line.emrId])).count,
                        BaseDataProvider.DAO(RenEMRLineDAO.self).filter(predicate: NSPredicate(format: "emrId = %@ and isScanned = Yes", argumentArray: [line.emrId])).count
                    ]))))
                } else {
                    self.send(message: .msgBox(title: "Error", message: "Error has been occurred"))
                }

                return
            } catch (BarcodeScanError.Unassigned) {
                errorStr = "This barcode is currently not assigned to an equipment/item!"
            } catch BarcodeScanError.NotOnEMR {
                errorStr = "The searched item is currently not on an EMR!"
            } catch {
                errorStr = "An error has been occurred!"
            }

            self.send(message: .msgBox(title: "Error", message: errorStr))
        }

        self.rx.viewAppeared += { _ in
            if self._barcode != nil && self._shouldProcessBarcode {
                self.processBarcode.accept(self._barcode!)
            }

            self._shouldProcessBarcode = false
            self._barcode = nil
        }

        emrButtonTitle.raise()
        isScanViewHidden.raise()
    }
}