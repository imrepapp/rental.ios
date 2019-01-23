//
// Created by Papp Imre on 2019-01-22.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import RxFlow
import NAXT_Mobile_Data_Entity_Framework

class TestFlow: BaseFlow, FlowWithTabBarRoot {
    func navigate(to step: Step) -> NextFlowItems {
        return lofasz()
    }
/*
        guard let step = step as? TestStep else {
            return .none
        }
        switch step {
        case .tab1Initial:
            print("ITT VAGYOK")
            return .none

        default: return .none
        }
    }
*/
}
