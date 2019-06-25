//
// Created by Papp Imre on 2019-01-21.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa

class ReplaceAttachmentViewModel: BaseViewModel {
    private var parameters = EMRLineParameters(emrLine: EMRItemViewModel())

    let cancelCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()
    let selectAttachmentCommand = PublishRelay<Void>()
    let selectReasonCommand = PublishRelay<Void>()

    let reason = BehaviorRelay<String?>(value: "Select Reason")
    let reasons = BehaviorRelay<[RenReplacementReason]>(value: [RenReplacementReason]())
    let replaceAttachmentId = BehaviorRelay<String?>(value: "")

    var emrLine: EMRItemViewModel {
        return parameters.emrLine
    }

    override func instantiate(with params: Parameters) {
        parameters = params as! EMRLineParameters
        title.val = "Replace Attachment: \(parameters.emrLine.id)"

        replaceAttachmentId.val = emrLine.eqId.val!

        BaseDataProvider.DAO(RenReplacementReasonDAO.self).items.map {
            reasons.val.append($0)
        }

        cancelCommand += { _ in
            self.next(step: RentalStep.dismiss)
        } => disposeBag

        saveCommand += { _ in
            self.isLoading.val = true

            let line = self.parameters.emrLine.asModel()
            line.replacementReason = self.reason.val!
            line.replacementEqId = self.replaceAttachmentId.val!

            BaseDataProvider.DAO(RenEMRLineDAO.self).updateAndPushIfOnline(model: line)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { result in
                        self.isLoading.val = false

                        if result {
                            self.send(message: .alert(config: AlertConfig(
                                    title: "Success save",
                                    message: "Save was successful.",
                                    actions: [UIAlertAction(title: "Ok", style: .default, handler: { alert in
                                        self.next(step: RentalStep.dismiss)
                                    })])))
                            return
                        }

                        self.send(message: .msgBox(title: "Error", message: "An error has been occurred."))
                    }, onError: { error in
                        self.send(message: .msgBox(title: "Error", message: error.message))
                        self.isLoading.val = false
                    }) => self.disposeBag
        } => disposeBag

        selectAttachmentCommand += { _ in
            self.next(step: RentalStep.attachmentList(onSelect: { attachment in
                self.replaceAttachmentId.val = attachment.eqId
            }, params: AttachmentListParameters(eqId: self.emrLine.eqId.val!, emrId: self.emrLine.emrId.val!)))
        } => disposeBag
    }
}
