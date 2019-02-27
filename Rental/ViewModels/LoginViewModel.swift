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

    private let _token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCIsImtpZCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCJ9.eyJhdWQiOiJodHRwczovL3VzbmNvbmVib3hheDFhb3MuY2xvdWQub25lYm94LmR5bmFtaWNzLmNvbSIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQyYTc5MjU4LWY2YTYtNDM3ZC1hYThkLWIxNjc5ODI1YmU4Ni8iLCJpYXQiOjE1NTEyNzA2NjMsIm5iZiI6MTU1MTI3MDY2MywiZXhwIjoxNTUxMjc0NTYzLCJhY3IiOiIxIiwiYWlvIjoiNDJKZ1lKaFR1eVF3WnVOeHVSZnpoYy9MR1NZNUhLNVpITmowMi9CVHRwKzMvWXJIMDEwQSIsImFtciI6WyJwd2QiXSwiYXBwaWQiOiJkODQ5ZmIzMC1kMmY0LTQ4NmMtYjEyNy0wN2NjMDJiNjhjNGYiLCJhcHBpZGFjciI6IjAiLCJpcGFkZHIiOiIxOTMuMjI2LjIxNy42IiwibmFtZSI6IkFYIDcgR2VuZXJpYyBVc2VyIiwib2lkIjoiNTUzNGQ4MWUtMjdlOC00MjJjLWI1MDgtMjhkNmZlYmQ0NDRkIiwib25wcmVtX3NpZCI6IlMtMS01LTIxLTk0MTgxMzM2NS0zNjE2NjE4ODctMTk5MzQ5OTI2Ni0xNDYzNCIsInB1aWQiOiIxMDAzMDAwMDk4OUIwNzZCIiwic2NwIjoiQVguRnVsbEFjY2VzcyBDdXN0b21TZXJ2aWNlLkZ1bGxBY2Nlc3MgT2RhdGEuRnVsbEFjY2VzcyIsInN1YiI6IjZsczlXSWlvSGlVdldXSlFHXzJlc1lsTHUyNnM4bFViUjFrMk5velQzN2siLCJ0aWQiOiI0MmE3OTI1OC1mNmE2LTQzN2QtYWE4ZC1iMTY3OTgyNWJlODYiLCJ1bmlxdWVfbmFtZSI6ImF4N2dlbmVyaWN1c2VyQHhhcHQuY29tIiwidXBuIjoiYXg3Z2VuZXJpY3VzZXJAeGFwdC5jb20iLCJ1dGkiOiJ0VFBpX0I0QjQwdWw3cjZyRHd3bEFBIiwidmVyIjoiMS4wIn0.J1seJAdOYAjmQQy-wWBR7OclDgYcW9ngk1Igq3sNLbimYPhW7ttN4ZdaDwigmTVUdT73gT7_cr6V-_7xX7BPaVjRjZC7RA65D-nk1sbDru-cphkJVQCvAH3592eB2EqU6h-IrHMbM4r3YFCq5HzVlMEIRj3S88Dk24GKdwss9XL8fwPpYYXuisYAl3SzO4i52KdUBr275NDLzLkt23zsLV8uJn4w3bQ7YZGphv5YsVbxzOe3VGrFZrSbrLtFedRXIa3LEY1LrIloLVIYEJZUpBsGjUg-f7VS1EfJ0EcpH23om0CGq5c5uqJgG8Et82rzmBfs3piR7s5jq42_qIgg5w"
    private let _apiUrl = "https://mobile-demo.xapt.com/env/dev/0338/nmdef/rental"

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
