//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import RxFlow
import RxCocoa
import NAXTMobileDataEntityFramework

enum RentalStep: Step {
    //Global
    case login
    case configSelector
    case menu
    case settings
    case dismiss

    //EMR
    case EMR(type: EMRType)
    case EMRList(_: EMRListParameters)
    case EMRLine(_: EMRLineParameters)
    case manualScan(_: ManualScanParameters)
    case addPhoto(_: EMRLineParameters)
    case replaceAttachment(_: EMRLineParameters)
    case attachmentList(onSelect: (AttachmentModel) -> Void)
}
