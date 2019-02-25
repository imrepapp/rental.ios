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

    private let _token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCIsImtpZCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCJ9.eyJhdWQiOiJodHRwczovL3VzbmNvbmVib3hheDFhb3MuY2xvdWQub25lYm94LmR5bmFtaWNzLmNvbSIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQyYTc5MjU4LWY2YTYtNDM3ZC1hYThkLWIxNjc5ODI1YmU4Ni8iLCJpYXQiOjE1NTA4NDU0ODksIm5iZiI6MTU1MDg0NTQ4OSwiZXhwIjoxNTUwODQ5Mzg5LCJhY3IiOiIxIiwiYWlvIjoiNDJKZ1lOai83cFRKQVY4VEQ1RzA3Ly9mZDJkSU5SbjlmQ1NtcDJuVCtsdmw0aHp4dHc4QiIsImFtciI6WyJwd2QiXSwiYXBwaWQiOiJkODQ5ZmIzMC1kMmY0LTQ4NmMtYjEyNy0wN2NjMDJiNjhjNGYiLCJhcHBpZGFjciI6IjAiLCJpcGFkZHIiOiIxOTMuMjI2LjIxNy42IiwibmFtZSI6IkFYIDcgR2VuZXJpYyBVc2VyIiwib2lkIjoiNTUzNGQ4MWUtMjdlOC00MjJjLWI1MDgtMjhkNmZlYmQ0NDRkIiwib25wcmVtX3NpZCI6IlMtMS01LTIxLTk0MTgxMzM2NS0zNjE2NjE4ODctMTk5MzQ5OTI2Ni0xNDYzNCIsInB1aWQiOiIxMDAzMDAwMDk4OUIwNzZCIiwic2NwIjoiQVguRnVsbEFjY2VzcyBDdXN0b21TZXJ2aWNlLkZ1bGxBY2Nlc3MgT2RhdGEuRnVsbEFjY2VzcyIsInN1YiI6IjZsczlXSWlvSGlVdldXSlFHXzJlc1lsTHUyNnM4bFViUjFrMk5velQzN2siLCJ0aWQiOiI0MmE3OTI1OC1mNmE2LTQzN2QtYWE4ZC1iMTY3OTgyNWJlODYiLCJ1bmlxdWVfbmFtZSI6ImF4N2dlbmVyaWN1c2VyQHhhcHQuY29tIiwidXBuIjoiYXg3Z2VuZXJpY3VzZXJAeGFwdC5jb20iLCJ1dGkiOiJTYTFWLW1vN1lrbXJGUEU2Q2ZrckFBIiwidmVyIjoiMS4wIn0.YQuflyZCDtvIOFRsID-iTkFCMFPXt77gxAwOMJcjXVBNbVk2GfFxDdAdaxFLOevSpyRj23YiPKZ8Qi6TqVZ760srjQz5-SDRHZrDP29N8XboO4RAP0_s17CNe8Oh5CEY4eW5WBKP3FkRnKJ0zwsdQTKZSQLDciR6wsQO52fzFbPf5lBS-LQvHbi3vUyXGPloXQ7nVMcOmwi8HigMQeMfJtLXc5mGehLCADVKeWg-0BErKNyvLrB3g6KxqCFtfGXxP0abXD8PctVZZCfvdYHM-7Jj67cMvGwZCc7orCDZ6XJWm1TeoiiIRKx1ecLWqDWEzq05jeUX8uix5EOHlgBboQ"
    private let _apiUrl = "https://mobile-demo.xapt.com/reverse170/mobapi/sales"

    required init() {
        super.init()
        title.val = "Login"
        loginCommand += { [self] in
            //TODO: load configs
            BaseDataProvider.instance.initialization(DataProviderContext(apiUrl: self._apiUrl, token: self._token))
                    .subscribe(onError: { print("Data provider init failed. \($0)") }, onCompleted: {
                        self.next(step:RentalStep.configSelector)
                    }) => self.disposeBag

            //self.next(step:RentalStep.menu)
        } => disposeBag

        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        #endif
    }
}
