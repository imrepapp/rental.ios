//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Sync
import NMDEF_Base
import RxSwift
import RxCocoa
import Swinject

struct AttachmentListParameters: Parameters {
    let eqId: String
    let emrId: String
}

class AttachmentListViewModel: BaseDataLoaderViewModel<[AttachmentModel]> {
    private var _eqId = ""
    private var _emrId = ""

    let cancelCommand = PublishRelay<Void>()

    let attachmentItems = BehaviorRelay<[AttachmentItemViewModel]>(value: [AttachmentItemViewModel]())
    let selectAttachmentCommand = PublishRelay<AttachmentItemViewModel>()

    let attachmentDidSelected = PublishRelay<AttachmentModel>()

    override var datasource: Observable<[AttachmentModel]> {
        return AppDelegate.api.getReplaceAttachmentList(eqId: _eqId, emrId: _emrId).asObservable()
    }

    required init() {
        super.init()
        title.val = "Select Attachment"

        cancelCommand += { _ in
            self.next(step:RentalStep.dismiss)
        } => disposeBag

        selectAttachmentCommand += { attachment in
            self.next(step:RentalStep.dismiss)
            self.attachmentDidSelected.accept(attachment.asModel())
        } => disposeBag
    }

    override func loadData(data: [AttachmentModel]) {
        _ = data.map { self.attachmentItems.val.append(AttachmentItemViewModel($0)) }
    }

    override func instantiate(with params: Parameters) {
        let p = params as! AttachmentListParameters
        _eqId = p.eqId
        _emrId = p.emrId
    }
}
