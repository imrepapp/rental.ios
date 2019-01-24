//
// Created by Papp Imre on 2019-01-21.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NAXTMobileDataEntityFramework
import RxSwift
import RxCocoa

class ReplaceAttachmentViewModel: BaseViewModel {
    private var parameters = EMRLineParameters(id: "N/A", type: EMRType.Receiving)

    let eqId = BehaviorRelay<String?>(value: nil)
    let emrId = BehaviorRelay<String?>(value: nil)
    let newEqId = BehaviorRelay<String?>(value: "Select Attachment")

    let cancelCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()
    let selectAttachmentCommand = PublishRelay<Void>()
    let selectReasonCommand = PublishRelay<Void>()

    let reason = BehaviorRelay<String?>(value: "Select Reason")
    let reasons = BehaviorRelay<[String]>(value: [String]())

    override func instantiate(with params: Parameters) {
        parameters = params as! EMRLineParameters
        title.val = "Replace Attachment: \(parameters.id)"

        //TODO: valid reasons
        reasons.val = ["One", "Two", "A lot"]

        //TODO: get EMRLine by parameters.id
        let emrLine = EMRLineModel(eqId: "EQ008913", emrId: "EMR003244", type: "Rental", direction: "Inbound", model: "X758", schedule: "21/11/2018", from: "Raleigh Blueridge Road - Industrial")

        eqId.val = emrLine.eqId
        emrId.val = emrLine.emrId

        cancelCommand += { _ in
            self.next(step:RentalStep.dismiss)
        } => disposeBag

        saveCommand += { _ in
            //TODO: add save logic here
            self.send(message: .alert(title: self.title.val!, message: "SAVE SELECTED ATTACHMENT TO: \(self.newEqId.val!)"))
        } => disposeBag

        selectAttachmentCommand += { _ in
            self.next(step:RentalStep.attachmentList(onSelect: { attachment in
                self.newEqId.val = attachment.eqId
            }))
        } => disposeBag
    }
}
