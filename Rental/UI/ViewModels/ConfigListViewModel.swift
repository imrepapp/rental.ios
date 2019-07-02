//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import RxCocoa
import RxFlow

struct ConfigListParams: Parameters {
    var configs: [ConfigItemViewModel]
    var sessionId: String
}

class ConfigListViewModel: BaseViewModel {
    let configItems = BehaviorRelay<[ConfigItemViewModel]>(value: [ConfigItemViewModel]())
    let selectConfigCommand = PublishRelay<ConfigItemViewModel>()
    let configDidSelected = PublishRelay<ConfigModel>()
    private var sessionId: String?

    required init() {
        super.init()
        title.val = "Config Selector View"

        selectConfigCommand += { config in
            self.isLoading.val = true

            //TODO save config into shared preferences
            AppDelegate.userAuthService.selectConfig(id: config.id, sessionId: self.sessionId!)
                    .map { response in
                        AppDelegate.token = response.token
                        let configuration = Configuration(name: config.name.val!, id: config.id)
                        AppDelegate.settings.userAuthContext?.selectedConfig = configuration

                        self.next(step: RentalStep.menu)
                        self.isLoading.val = false
                    }.subscribe(onError: { error in
                        var errorStr = ""
                        self.isLoading.val = false

                        if let e = error as? LoginParsingError {
                            switch e {
                            case let .loginError(msg), let .jsonParsingError(msg):
                                errorStr = msg
                            }
                        } else {
                            errorStr = "An error has been occurred"
                        }

                        self.send(message: .alert(config: AlertConfig(title: "Error", message: errorStr, actions: [
                            UIAlertAction(title: "Ok", style: .default, handler: { alert in
                                self.next(step: RentalStep.dismiss)
                            })
                        ])))
                    }) => self.disposeBag

        } => disposeBag
    }

    override func instantiate(with params: Parameters) {
        super.instantiate(with: params)

        let configViewParams = params as! ConfigListParams
        configItems.val = configViewParams.configs
        sessionId = configViewParams.sessionId
    }
}
