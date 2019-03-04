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

    private let _token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCIsImtpZCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCJ9.eyJhdWQiOiJodHRwczovL3VzbmNvbmVib3hheDFhb3MuY2xvdWQub25lYm94LmR5bmFtaWNzLmNvbSIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQyYTc5MjU4LWY2YTYtNDM3ZC1hYThkLWIxNjc5ODI1YmU4Ni8iLCJpYXQiOjE1NTE3MTA1NDYsIm5iZiI6MTU1MTcxMDU0NiwiZXhwIjoxNTUxNzE0NDQ2LCJhY3IiOiIxIiwiYWlvIjoiNDJKZ1lFanJ2RFZsVVhuZXJnTEw3Um5Nd1QvTVBqalBUSlI5ckY2NWRHT1NrR0pyaURrQSIsImFtciI6WyJwd2QiXSwiYXBwaWQiOiJkODQ5ZmIzMC1kMmY0LTQ4NmMtYjEyNy0wN2NjMDJiNjhjNGYiLCJhcHBpZGFjciI6IjAiLCJpcGFkZHIiOiIxOTMuMjI2LjIxNy42IiwibmFtZSI6IkFYIDcgR2VuZXJpYyBVc2VyIiwib2lkIjoiNTUzNGQ4MWUtMjdlOC00MjJjLWI1MDgtMjhkNmZlYmQ0NDRkIiwib25wcmVtX3NpZCI6IlMtMS01LTIxLTk0MTgxMzM2NS0zNjE2NjE4ODctMTk5MzQ5OTI2Ni0xNDYzNCIsInB1aWQiOiIxMDAzMDAwMDk4OUIwNzZCIiwic2NwIjoiQVguRnVsbEFjY2VzcyBDdXN0b21TZXJ2aWNlLkZ1bGxBY2Nlc3MgT2RhdGEuRnVsbEFjY2VzcyIsInN1YiI6IjZsczlXSWlvSGlVdldXSlFHXzJlc1lsTHUyNnM4bFViUjFrMk5velQzN2siLCJ0aWQiOiI0MmE3OTI1OC1mNmE2LTQzN2QtYWE4ZC1iMTY3OTgyNWJlODYiLCJ1bmlxdWVfbmFtZSI6ImF4N2dlbmVyaWN1c2VyQHhhcHQuY29tIiwidXBuIjoiYXg3Z2VuZXJpY3VzZXJAeGFwdC5jb20iLCJ1dGkiOiJnYjNCNjU2R1lrV3dOSjVlWTFwWkFBIiwidmVyIjoiMS4wIn0.P-9sXW9f40VM9gb18GngA2MRO4SbaUkzg0lhERNL8rqOg6qUTGA3144tA8x7nh3tRngGNo3SBJh0v65aDMv0vm2ZrU5FjUXERn8QXqBmGmcw8jXWrhmGxHy33-E7iaMTwEjX9bmVtWO56103WQokIqxj6W0c6ey01cEwHoX4nBhwNFIajZBMJ6rGaeA3jAgJxyQsxf0wCozdSNUeYSFuP755o4roTVmtLL_5fN4H1mpESHUJpp6zYcHBUSUft3X5ECO7ygJkuzD0oylEYUQNJQNoAPVnadYHlS1q_7DqHwoFz2CFOeh_IhZXSda0S48bKU_CoYcwz2Lse8GN2ISLzA"
    private let _apiUrl = "https://mobile-demo.xapt.com/env/dev/0338/nmdef/rental"

    required init() {
        super.init()
        title.val = "Login"
        loginCommand += { [self] in
            //TODO: load configs
            BaseDataProvider.instance.initialization(DataProviderContext(apiUrl: self._apiUrl, token: self._token))
                    .subscribe(onError: { print("Data provider init failed. \($0)") }, onCompleted: {
                        self.next(step:RentalStep.menu)
                    }) => self.disposeBag
        } => disposeBag

        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        #endif
    }
}
