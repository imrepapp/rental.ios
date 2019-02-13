//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import RxSwift
import RxCocoa
import NMDEF_Base

class MenuItemViewModel: SimpleViewModel {
    let id: Menu
    let name = BehaviorRelay<String?>(value: nil)
    let icon = BehaviorRelay<UIImage?>(value: nil)

    init(_ model: MenuModel) {
        self.id = model.id
        self.name.val = model.name
        self.icon.val = UIImage.init(named: model.iconName)
    }

    func asModel() -> MenuModel {
        fatalError("asModel() has not been implemented")
    }
}