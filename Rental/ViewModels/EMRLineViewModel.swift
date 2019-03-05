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

    let isNotReplaceableAttachment = BehaviorRelay<Bool>(value: true)
    let replaceAttachmentCommand = PublishRelay<Void>()

    let enterBarcodeCommand = PublishRelay<Void>()
    let scanBarcodeCommand = PublishRelay<Void>()
    let photoCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()

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

        emrButtonTitle.raise()
    }
}