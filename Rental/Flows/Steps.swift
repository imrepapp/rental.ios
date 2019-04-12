//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import RxFlow
import RxCocoa
import NMDEF_Base

enum RentalStep: Step {
    //Global
    case login
    case configSelector(_: ConfigListParams)
    case menu
    case settings
    case dismiss

    //EMR
    case EMR(type: EMRType)
    case EMRList(_: EMRListParameters)
    case EMRLine(_: EMRLineParameters)
    case manualScan(onSelect: (String) -> Void)
    case addPhoto(_: AddPhotoParams)
    case replaceAttachment(_: EMRLineParameters)
    case attachmentList(onSelect: (AttachmentModel) -> Void, params: AttachmentListParameters)
    case EMRCreateForm(_: EMRFormParameters)
}
