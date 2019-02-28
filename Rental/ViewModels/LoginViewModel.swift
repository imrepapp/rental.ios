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

    private let _token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCIsImtpZCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCJ9.eyJhdWQiOiJodHRwczovL3VzbmNvbmVib3hheDFhb3MuY2xvdWQub25lYm94LmR5bmFtaWNzLmNvbSIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQyYTc5MjU4LWY2YTYtNDM3ZC1hYThkLWIxNjc5ODI1YmU4Ni8iLCJpYXQiOjE1NTEzNjAzNzUsIm5iZiI6MTU1MTM2MDM3NSwiZXhwIjoxNTUxMzY0Mjc1LCJhY3IiOiIxIiwiYWlvIjoiQVNRQTIvOEtBQUFBd1FwdlZnako5MCs4RnQ2Uit6UGF5VG1nWEs0c1dHaXNycHJiM3JtQ1lPOD0iLCJhbXIiOlsicHdkIl0sImFwcGlkIjoiZDg0OWZiMzAtZDJmNC00ODZjLWIxMjctMDdjYzAyYjY4YzRmIiwiYXBwaWRhY3IiOiIwIiwiZmFtaWx5X25hbWUiOiJLT1JQQSIsImdpdmVuX25hbWUiOiJLcmlzenRpw6FuIiwiaXBhZGRyIjoiMTkzLjIyNi4yMTcuNiIsIm5hbWUiOiJLcmlzenRpw6FuIEtPUlBBIiwib2lkIjoiNzQwZGJhMDAtYzZmZi00OTM4LThhYjUtMzIwNTlmNjNmZWM4Iiwib25wcmVtX3NpZCI6IlMtMS01LTIxLTk0MTgxMzM2NS0zNjE2NjE4ODctMTk5MzQ5OTI2Ni0xMzExNSIsInB1aWQiOiIxMDAzN0ZGRTk0MThBODZCIiwic2NwIjoiQVguRnVsbEFjY2VzcyBDdXN0b21TZXJ2aWNlLkZ1bGxBY2Nlc3MgT2RhdGEuRnVsbEFjY2VzcyIsInN1YiI6InZjZ0FHbW9nYkFyUktwQVd0QTIxT0lVYWtEZW1XTVRFMXA0TE96WDNVTDgiLCJ0aWQiOiI0MmE3OTI1OC1mNmE2LTQzN2QtYWE4ZC1iMTY3OTgyNWJlODYiLCJ1bmlxdWVfbmFtZSI6IktyaXN6dGlhbi5LT1JQQUB4YXB0LmNvbSIsInVwbiI6IktyaXN6dGlhbi5LT1JQQUB4YXB0LmNvbSIsInV0aSI6IkZUNlZSNTJORWtTRHBoQUNRVUlsQUEiLCJ2ZXIiOiIxLjAifQ.SjQLkCOIFjhoZm0lpv3wJmIk_c1ms4De_14kCtjt_3ytySQMvp8lAJDFvA9yInDWq79QR0Pee6rzYxHsdMbea0G6ZCa7lRtxwp12vvr1RHYFr5xe8bWemh0j2n6PxuQey_kV_K-BhNM7R8n2mF6WPvvjt8VumarYAkh-zSht56Rc_xhs2gJnywafG2oWQ3NE3qKskCcknLtXX7Ug0j4CaUZacnmZvmNKMuh1Wsn6b42YiexngQSJ4eEMLZzWiSeplvGS7L-UusWWIH8Z5EXFC2lRS0CJtJ_nvrGHI9xRlKxOLRWter3xfgWcBDW4zXsWZWq4_-on5Hd2jzJWBlu0WA"
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
