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
    let isLoading = BehaviorRelay<Bool>(value: false)
    let loginCommand = PublishRelay<Void>()

    required init() {
        super.init()
        title.val = "Login"

        #if DEBUG
        emailAddress.val = "demo@xapt.com"
        password.val = "xapt2017"
        #endif

        loginCommand += { [self] in
            self.isLoading.val = true

            let userAuthService = AppDelegate.instance.container.resolve(UserAuthServiceProtocol.self)!
            let request = LoginRequest(email: self.emailAddress.val!, password: self.password.val!)

            userAuthService.login(request: request)
                    .flatMap { response -> Observable<LoginResponse> in
                        if (response.configs.count > 1) {
                            return userAuthService.selectConfig(id: response.configs[0].id, sessionId: response.token)
                        }

                        return Observable.of(response)
                    }
                    .flatMap { response -> Observable<WorkerData> in
                        AppDelegate.token = response.token

                        //TODO Return response instead of string
                        return userAuthService.getWorkerData(token: response.token)
                    }
                    .map { response -> Void in
                        //TODO: set values of get worker data
                        print("BaseDataProvider started")

                        BaseDataProvider.instance.initialization(DataProviderContext(apiUrl: AppDelegate.settings.apiUrl, token: AppDelegate.token))
                                .subscribe(onError: { print("Data provider init failed. \($0)") }, onCompleted: {
                                    self.isLoading.val = false
                                    self.next(step:RentalStep.menu)
                                }) => self.disposeBag
                    }
                    .subscribe(onError: { error in
                        self.isLoading.val = false

                        if let e = error as? LoginParsingError {
                            switch e {
                            case let .loginError(msg), let .jsonParsingError(msg):
                                self.send(message: .msgBox(title: "Error", message: msg))
//                            default:
//                                self.send(message: .msgBox(title: "Error", message: "An error has been occurred"))
                            }
                        } else {
                            self.send(message: .msgBox(title: "Error", message: "An error has been occurred"))
                        }
                    }) => self.disposeBag

            //TODO: load configs

        } => disposeBag

        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        #endif
    }
}
