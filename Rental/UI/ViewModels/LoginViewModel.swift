//
// Created by Papp Imre on 2019-01-17.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa

#if DEBUG
import RealmSwift
#endif

final class LoginViewModel: BaseViewModel {
    let emailAddress = BehaviorRelay<String?>(value: nil)
    let password = BehaviorRelay<String?>(value: nil)
    let apiUrl = BehaviorRelay<String?>(value: nil)
    let loginCommand = PublishRelay<Void>()
    let version = BehaviorRelay<String?>(value: nil)

    required init() {
        super.init()
        title.val = "Login"
        version.val = AppDelegate.settings.appVersion

        #if DEBUG
        emailAddress.val = "demo@xapt.com"
        password.val = "xapt2017"
        #endif

        apiUrl.val = AppDelegate.settings.apiUrl

        loginCommand += { [self] in
            self.isLoading.val = true

            AppDelegate.settings.apiUrl = self.apiUrl.val!

            if self.emailAddress.value != nil && self.password.value != nil {
                let request = LoginRequest(email: self.emailAddress.value!, password: self.password.value!)

                AppDelegate.userAuthService.login(request: request)
                        .map { response -> Void in
                            if response.configs.count > 1 {
                                let configurations = self.fillConfigItemViewModelList(configs: response.configs)

                                AppDelegate.settings.userAuthContext = UserAuthContext(userIdentifier: self.emailAddress.val!, password: self.password.val!, config: nil)

                                self.next(step: RentalStep.configSelector(ConfigListParams(configs: configurations, sessionId: response.token)))

                                self.isLoading.val = false

                            } else {
                                AppDelegate.token = response.token
                                let configuration = Configuration(name: response.configs[0].name, id: response.configs[0].id)
                                AppDelegate.settings.userAuthContext = UserAuthContext(userIdentifier: self.emailAddress.val!, password: self.password.val!, config: configuration)

                                self.next(step: RentalStep.menu)
                                self.isLoading.val = false
                            }
                        }
                        .subscribe(onSuccess: {
                            //self.next(step: RentalStep.menu)
                            //self.isLoading.val = false
                        }, onError: { error in
                            self.isLoading.val = false

                            if let e = error as? LoginParsingError {
                                switch e {
                                case let .loginError(msg), let .jsonParsingError(msg):
                                    self.send(message: .msgBox(title: "Error", message: msg))
                                }
                            } else {
                                self.send(message: .msgBox(title: "Error", message: "An error has been occurred"))
                            }
                        }) => self.disposeBag
            }

            #if DEBUG
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            #endif
        } => disposeBag
    }

    private func fillConfigItemViewModelList(configs: [Configuration]) -> [ConfigItemViewModel] {
        var configItemViewModels = [ConfigItemViewModel]()

        for config in configs {
            configItemViewModels.append(ConfigItemViewModel(ConfigModel(id: config.id, name: config.name, url: "")))
        }

        return configItemViewModels
    }
}


