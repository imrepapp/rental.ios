//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import NMDEF_Base
import Reusable

class EMRFlow: BaseFlow, FlowWithNavigationRoot, StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    static var sceneIdentifier: String {
        return "EMRNavigation"
    }

    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? RentalStep else {
            return .none
        }
        switch step {
        case .EMRList(let emrListParams): return pushNavigation(to: EMRListViewController.self, params: emrListParams)
        case .EMRLine(let emrLineParams): return pushNavigation(to: EMRLineViewController.self, params: emrLineParams)
        case .manualScan(let barcodeDidScannedBlock): return navigateToManualScan(barcodeDidScannedBlock)
        case .addPhoto(let emrLineParams): return modalNavigation(to: AddPhotoViewController.self, params: emrLineParams)
        case .replaceAttachment(let emrLineParams): return modalNavigation(to: ReplaceAttachmentViewController.self, params: emrLineParams)
        case .attachmentList(let didSelectBlock): return navigateToAttachmentList(didSelectBlock)
        case .menu: return .end(withStepForParentFlow: RentalStep.dismiss)
        case .dismiss: return dismiss()
        default: return .none
        }
    }

    private func navigateToManualScan(_ barcodeDidScannedBlock: @escaping (RenEMRLine) -> Void) -> NextFlowItems {
        let items = modalNavigation(to: ManualScanViewController.self)
        if let vc = self.getNextPresentable(items) as? ManualScanViewController {
            vc.viewModel.barcodeDidScanned += barcodeDidScannedBlock => self.disposeBag
        }
        return items
    }

    private func navigateToAttachmentList(_ didSelectBlock: @escaping (AttachmentModel) -> Void) -> NextFlowItems {
        let items = modalNavigation(to: AttachmentListViewController.self)
        if let vc = self.getNextPresentable(items) as? AttachmentListViewController {
            vc.viewModel.attachmentDidSelected += didSelectBlock => self.disposeBag
        }
        return items
    }
}