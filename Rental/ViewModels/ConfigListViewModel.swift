//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NAXT_Mobile_Data_Entity_Framework
import RxSwift
import RxCocoa
import RxFlow

class ConfigListViewModel: BaseViewModel {
    let configItems = BehaviorRelay<[ConfigItemViewModel]>(value: [ConfigItemViewModel]())
    let selectConfigCommand = PublishRelay<ConfigItemViewModel>()

    required init() {
        super.init()
        title.val = "Config Selector View"

        //TODO: get configs from parameter?
        configItems.val = [
            ConfigItemViewModel(ConfigModel(id: 1, name: "Configuration 1", url: "https://mobile-demo.xapt.com/BARAKA")),
            ConfigItemViewModel(ConfigModel(id: 2, name: "Configuration 2", url: "https://mobile-demo.xapt.com/BARAKA")),
            ConfigItemViewModel(ConfigModel(id: 3, name: "Configuration 3", url: "https://mobile-demo.xapt.com/BARAKA")),
            ConfigItemViewModel(ConfigModel(id: 4, name: "Configuration 4", url: "https://mobile-demo.xapt.com/BARAKA")),
        ]

        selectConfigCommand += { config in
            //TODO save config into shared preferences
            self.next(step:RentalStep.menu)
        } => disposeBag
    }
}
