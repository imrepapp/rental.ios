//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Base
import RxSwift
import RxCocoa

class AttachmentListViewModel: BaseViewModel {
    let cancelCommand = PublishRelay<Void>()

    let attachmentItems = BehaviorRelay<[AttachmentItemViewModel]>(value: [AttachmentItemViewModel]())
    let selectAttachmentCommand = PublishRelay<AttachmentItemViewModel>()

    let attachmentDidSelected = PublishRelay<AttachmentModel>()

    required init() {
        super.init()
        title.val = "Select Attachment"

        cancelCommand += { _ in
            self.next(step:RentalStep.dismiss)
        } => disposeBag

        //TODO: get the valid Attachment
        attachmentItems.val = [
            AttachmentItemViewModel(AttachmentModel(eqId: "EQ008912", inventSerialId: "SN003243", machineTypeId: "X758", fleetType: "Component", warehouse: "00", location: "L10")),
            AttachmentItemViewModel(AttachmentModel(eqId: "EQ008911", inventSerialId: "SN003248", machineTypeId: "X758", fleetType: "Component", warehouse: "00", location: "L10")),
            AttachmentItemViewModel(AttachmentModel(eqId: "EQ008910", inventSerialId: "SN004232", machineTypeId: "X758", fleetType: "Component", warehouse: "00", location: "L10"))
        ]

        selectAttachmentCommand += { attachment in
            self.next(step:RentalStep.dismiss)
            self.attachmentDidSelected.accept(attachment.asModel())
        } => disposeBag
    }
}
