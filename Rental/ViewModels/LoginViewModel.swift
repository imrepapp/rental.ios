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

    private let _token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCIsImtpZCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCJ9.eyJhdWQiOiJodHRwczovL3VzbmNvbmVib3hheDFhb3MuY2xvdWQub25lYm94LmR5bmFtaWNzLmNvbSIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQyYTc5MjU4LWY2YTYtNDM3ZC1hYThkLWIxNjc5ODI1YmU4Ni8iLCJpYXQiOjE1NTEyNzg2MDksIm5iZiI6MTU1MTI3ODYwOSwiZXhwIjoxNTUxMjgyNTA5LCJhY3IiOiIxIiwiYWlvIjoiNDJKZ1lGQzNPdmQ3bWZicW45WVY1NjVaUzdzcE10eTg3Qm5qOHZYT1FsYUpwRVFSM2hjQSIsImFtciI6WyJwd2QiXSwiYXBwaWQiOiJkODQ5ZmIzMC1kMmY0LTQ4NmMtYjEyNy0wN2NjMDJiNjhjNGYiLCJhcHBpZGFjciI6IjAiLCJpcGFkZHIiOiIxOTMuMjI2LjIxNy42IiwibmFtZSI6IkFYIDcgR2VuZXJpYyBVc2VyIiwib2lkIjoiNTUzNGQ4MWUtMjdlOC00MjJjLWI1MDgtMjhkNmZlYmQ0NDRkIiwib25wcmVtX3NpZCI6IlMtMS01LTIxLTk0MTgxMzM2NS0zNjE2NjE4ODctMTk5MzQ5OTI2Ni0xNDYzNCIsInB1aWQiOiIxMDAzMDAwMDk4OUIwNzZCIiwic2NwIjoiQVguRnVsbEFjY2VzcyBDdXN0b21TZXJ2aWNlLkZ1bGxBY2Nlc3MgT2RhdGEuRnVsbEFjY2VzcyIsInN1YiI6IjZsczlXSWlvSGlVdldXSlFHXzJlc1lsTHUyNnM4bFViUjFrMk5velQzN2siLCJ0aWQiOiI0MmE3OTI1OC1mNmE2LTQzN2QtYWE4ZC1iMTY3OTgyNWJlODYiLCJ1bmlxdWVfbmFtZSI6ImF4N2dlbmVyaWN1c2VyQHhhcHQuY29tIiwidXBuIjoiYXg3Z2VuZXJpY3VzZXJAeGFwdC5jb20iLCJ1dGkiOiJEdDExNmhOTlRVeVpiMlMyWmU4c0FBIiwidmVyIjoiMS4wIn0.TbLUu7DIiVp9F3JKT8SqZ6KVnKINHsooX9OhWl5vZi_lDMIuK3GCSPoRM_ilJKztmZg2DB7_1m_vL1F5R1iYEOr_A5w2Mi-vZYBvWhxkug8uo1QZ4UZxwFkvyUmrRLO7qXayBGudHg8tAt8jn3ETeGZnmhv_fy3AfQG9_EiSwWVxH0UhuyCJl0d49pc6L4o1L3hw3M6ccE8IttQ5d6DKxDb2y8K5maM2LIgXUJUv9Dvdh7wM2X8AnNUlo5G5RL_SWzZ38AnCXK0v3p5wQ_3G_UPD8icRHxzgl6p9gH76Zq0GdE9gVf7ZT6ZWtFDGxq6oBdDri-1qFyjrB5MWKMOC7w"
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
