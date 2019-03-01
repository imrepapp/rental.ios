//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import RxCocoa

struct EMRLineParameters : Parameters {
    let emrLine: EMRItemViewModel
}

class EMRLineViewModel: BaseViewModel {
    private var _parameters = EMRLineParameters(emrLine: EMRItemViewModel())

    let isNotReplaceableAttachment = BehaviorRelay<Bool>(value: true)
    let replaceAttachmentCommand = PublishRelay<Void>()

    let enterBarcodeCommand = PublishRelay<Void>()
    let scanBarcodeCommand = PublishRelay<Void>()
    let photoCommand = PublishRelay<Void>()

    let emrListTitle = BehaviorRelay<String?>(value: nil)
    let emrListCommand = PublishRelay<Void>()

    var emrLine: EMRItemViewModel {
        return _parameters.emrLine
    }

    override func instantiate(with params: Parameters) {
        _parameters = params as! EMRLineParameters

        title.val = "\(emrLine.type.val!): \(emrLine.emrId.val!)"

        //TODO: create the valid button title
        emrListTitle.val = "EMR List (3/1)"

        //TODO: set true if attachment is not replaceable
        isNotReplaceableAttachment.val = false
        replaceAttachmentCommand += { _ in
            self.next(step:RentalStep.replaceAttachment(self._parameters))
        } => disposeBag

        enterBarcodeCommand += { _ in

        } => disposeBag

        scanBarcodeCommand += { _ in
            self.send(message: .alert(title: self.title.val!, message: "SCAN!!"))
        } => disposeBag

        photoCommand += { _ in
            self.next(step:RentalStep.addPhoto(self._parameters))
        } => disposeBag

        emrListCommand += { _ in
            self.next(step:RentalStep.EMRList(EMRListParameters(type: EMRType(rawValue: self._parameters.emrLine.emrType.val)!, emrId: self._parameters.emrLine.emrId.val!)))
        } => disposeBag
    }
}