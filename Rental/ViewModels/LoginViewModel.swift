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
    let loginCommand = PublishRelay<Void>()

    required init() {
        super.init()
        title.val = "Login"
        loginCommand += { [self] in
            let userAuthService = AppDelegate.instance.container.resolve(UserAuthServiceProtocol.self)
            let request = LoginRequest(email: "robert.papp@xapt.com", password: "Roncika23ab05")

            userAuthService!.login(request: request)
                    .flatMap { response -> Observable<LoginResponse> in
                        if (response.configs.count > 1) {
                            return userAuthService!.selectConfig(id: response.configs[0].id, sessionId: response.token)
                        }

                        return Observable.of(response)
                    }
                    .flatMap { response -> Observable<WorkerData> in
                        AppDelegate.token = response.token

                        //TODO Return response instead of string
                        return userAuthService!.getWorkerData(token: response.token)
                    }
                    .map { response -> Void in
                        //TODO: set values of get worker data
                        print("BaseDataProvider started")

                        BaseDataProvider.instance.initialization(DataProviderContext(apiUrl: AppDelegate.settings.apiUrl, token: AppDelegate.token))
                                .subscribe(onError: { print("Data provider init failed. \($0)") }, onCompleted: {
                                    self.next(step:RentalStep.menu)
                                }) => self.disposeBag
                    }
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribeOn(MainScheduler.instance)
                    .subscribe({ configResponse in
                        switch configResponse {
                        case .next(let response):
                            print(response)
                        case .completed:
                            print("login completed")
                        case .error:
                            print("error")
                        }
                    }) => self.disposeBag

            //TODO: load configs

        } => disposeBag

        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        #endif
    }
}
