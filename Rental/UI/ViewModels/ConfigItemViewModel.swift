//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import RxSwift
import RxCocoa
import NMDEF_Base

class ConfigItemViewModel: SimpleViewModel {
    let id: Int
    let name = BehaviorRelay<String?>(value: nil)
    let url = BehaviorRelay<String?>(value: nil)

    init(_ model: ConfigModel) {
        self.id = model.id
        self.name.val = model.name
        self.url.val = model.url
    }

    func asModel() -> ConfigModel {
        return ConfigModel(
                id: self.id,
                name: self.name.value!,
                url: self.url.value!)
        }
}
