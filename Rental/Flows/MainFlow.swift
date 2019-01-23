//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import RxFlow
import NAXT_Mobile_Data_Entity_Framework
import Reusable

class MainFlow: BaseFlow, FlowWithNavigationRoot, StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    static var sceneIdentifier: String {
        return "MainNavigation"
    }

    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? RentalStep else {
            return .none
        }
        switch step {
        case .login: return pushNavigation(to: LoginViewController.self)
        case .configSelector: return pushNavigation(to: ConfigListViewController.self)
        case .menu: return pushNavigation(to: MenuListViewController.self)
        case .settings: return pushNavigation(to: SettingsViewController.self)
        case .EMR(let emrType): return start(flow: EMRFlow(), step: RentalStep.EMRList(EMRListParameters(type: emrType, filter: false)), transition: .flipHorizontal)
        case .dismiss: return dismiss()

        case .test: return start(flow: TestFlow(), step: TestStep.tab1Initial)
        default: return .none
        }
    }
}