//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NAXTMobileDataEntityFramework
import RxSwift
import RxCocoa

struct EMRLineParameters : Parameters {
    let id: String
    let type: EMRType
}

class EMRLineViewModel: BaseViewModel {
    private var parameters = EMRLineParameters(id: "N/A", type: EMRType.Receiving)

    let eqId = BehaviorRelay<String?>(value: nil)
    let type = BehaviorRelay<String?>(value: nil)
    let direction = BehaviorRelay<String?>(value: nil)
    let status = BehaviorRelay<String?>(value: nil)
    let model = BehaviorRelay<String?>(value: nil)
    let serial = BehaviorRelay<String?>(value: nil)

    let fuel = BehaviorRelay<String?>(value: nil)
    let smu = BehaviorRelay<String?>(value: nil)
    let secSMU = BehaviorRelay<String?>(value: nil)
    let quantity = BehaviorRelay<String?>(value: nil)

    //TODO: add missing fields

    let isNotReplaceableAttachment = BehaviorRelay<Bool>(value: true)
    let replaceAttachmentCommand = PublishRelay<Void>()

    let enterBarcodeCommand = PublishRelay<Void>()
    let scanBarcodeCommand = PublishRelay<Void>()
    let photoCommand = PublishRelay<Void>()

    let emrListTitle = BehaviorRelay<String?>(value: nil)
    let emrListCommand = PublishRelay<Void>()

    override func instantiate(with params: Parameters) {
        parameters = params as! EMRLineParameters
        title.val = "\(parameters.type): \(parameters.id)"

        //TODO: get EMRLine by parameters.id
        let emrLine = EMRLineModel(eqId: "EQ008913", emrId: "EMR003244", type: "Rental", direction: "Inbound", model: "X758", schedule: "21/11/2018", from: "Raleigh Blueridge Road - Industrial")

        eqId.val = emrLine.eqId
        type.val = emrLine.type
        direction.val = emrLine.direction
        status.val = "NO STATUS" //TODO: fix status
        model.val = emrLine.model
        serial.val = "NO SERIAL" //TODO: fix serial

        //TODO: load values into missing fields

        //TODO: create the valid button title
        emrListTitle.val = "EMR List (3/1)"

        //TODO: set true if attachment is not replaceable
        isNotReplaceableAttachment.val = false
        replaceAttachmentCommand += { _ in
            self.next(step:RentalStep.replaceAttachment(self.parameters))
        } => disposeBag

        enterBarcodeCommand += { _ in
            self.next(step:RentalStep.manualScan(ManualScanParameters(type: self.parameters.type)))
        } => disposeBag

        scanBarcodeCommand += { _ in
            self.send(message: .alert(title: self.title.val!, message: "SCAN!!"))
        } => disposeBag

        photoCommand += { _ in
            self.next(step:RentalStep.addPhoto(self.parameters))
        } => disposeBag

        emrListCommand += { _ in
            //TODO: add real filter parameters, extend EMRListParameters class with required fields
            self.next(step:RentalStep.EMRList(EMRListParameters(type: self.parameters.type, filter: true)))
        } => disposeBag
    }
}