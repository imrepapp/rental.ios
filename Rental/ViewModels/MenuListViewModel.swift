//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa

enum Menu {
    case EMRShipping
    case EMRReceiving
}

class MenuListViewModel: BaseViewModel {
    let menuItems = BehaviorRelay<[MenuItemViewModel]>(value: [MenuItemViewModel]())
    let selectMenuCommand = PublishRelay<MenuItemViewModel>()

    let showSettingsCommand = PublishRelay<Void>()

    required init() {
        super.init()
        title.val = "Menu"

        menuItems.val = [
            MenuItemViewModel(MenuModel(id: Menu.EMRShipping, name: "Shipping", iconName: "menu_icon_24_dp_shipping")),
            MenuItemViewModel(MenuModel(id: Menu.EMRReceiving, name: "Receiving", iconName: "menu_icon_24_dp_receiving")),
        ]

        selectMenuCommand += { menu in
            switch menu.id {
            case .EMRShipping: self.next(step: RentalStep.EMR(type: EMRType.Shipping))
            case .EMRReceiving: self.next(step: RentalStep.EMR(type: EMRType.Receiving))
            }
        } => disposeBag

        showSettingsCommand += { _ in
            self.next(step: RentalStep.settings)
        } => disposeBag
    }
}
