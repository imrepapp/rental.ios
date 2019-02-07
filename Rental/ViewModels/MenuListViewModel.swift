//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NAXTMobileDataEntityFramework
import NMDEF_Sync
import RxSwift
import RxCocoa

enum Menu {
    case EMRShipping
    case EMRReceiving
}

class MenuListViewModel: BaseViewModel {
    let menuItems = BehaviorRelay<[MenuItemViewModel]>(value: [MenuItemViewModel]())
    let selectMenuCommand = PublishRelay<MenuItemViewModel>()

    let showSettingsCommand = PublishRelay<Void>()

    private let _token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCIsImtpZCI6Ii1zeE1KTUxDSURXTVRQdlp5SjZ0eC1DRHh3MCJ9.eyJhdWQiOiJodHRwczovL3VzbmNvbmVib3hheDFhb3MuY2xvdWQub25lYm94LmR5bmFtaWNzLmNvbSIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQyYTc5MjU4LWY2YTYtNDM3ZC1hYThkLWIxNjc5ODI1YmU4Ni8iLCJpYXQiOjE1NDk1NTMwMDgsIm5iZiI6MTU0OTU1MzAwOCwiZXhwIjoxNTQ5NTU2OTA4LCJhY3IiOiIxIiwiYWlvIjoiQVNRQTIvOEtBQUFBYURBdXhRSDlvN3h6dmV4YVB3MWtwRXU3TERnQ2YwWTN4dEpubitmTjNNTT0iLCJhbXIiOlsicHdkIl0sImFwcGlkIjoiZDg0OWZiMzAtZDJmNC00ODZjLWIxMjctMDdjYzAyYjY4YzRmIiwiYXBwaWRhY3IiOiIwIiwiaXBhZGRyIjoiMTkzLjIyNi4yMTcuNiIsIm5hbWUiOiJBWCA3IEdlbmVyaWMgVXNlciIsIm9pZCI6IjU1MzRkODFlLTI3ZTgtNDIyYy1iNTA4LTI4ZDZmZWJkNDQ0ZCIsIm9ucHJlbV9zaWQiOiJTLTEtNS0yMS05NDE4MTMzNjUtMzYxNjYxODg3LTE5OTM0OTkyNjYtMTQ2MzQiLCJwdWlkIjoiMTAwMzAwMDA5ODlCMDc2QiIsInNjcCI6IkFYLkZ1bGxBY2Nlc3MgQ3VzdG9tU2VydmljZS5GdWxsQWNjZXNzIE9kYXRhLkZ1bGxBY2Nlc3MiLCJzdWIiOiI2bHM5V0lpb0hpVXZXV0pRR18yZXNZbEx1MjZzOGxVYlIxazJOb3pUMzdrIiwidGlkIjoiNDJhNzkyNTgtZjZhNi00MzdkLWFhOGQtYjE2Nzk4MjViZTg2IiwidW5pcXVlX25hbWUiOiJheDdnZW5lcmljdXNlckB4YXB0LmNvbSIsInVwbiI6ImF4N2dlbmVyaWN1c2VyQHhhcHQuY29tIiwidXRpIjoiQzdlM0hWT0JNa200NlE5UU5tOGJBQSIsInZlciI6IjEuMCJ9.JRulMTLQVEQyyjvINC4U80iffGweL8QQszghWfjokTeVKCE4fs1knIh_DUmUycmHaasfduvPTLwR3vTdC994dFNjl6A_KHDYYms49lGGdfTyg1e6PqfNbq3efc9-L8VvCwzd2TsA0PG9WaDBa1dT7PWnhmN8e49ETXqUfnSjxcEV_KCoZj-Kl-h-Ko5_R7vSo5wEMI0gqYBpXzMn2Frun_EL-GM9eD8QZ402m55k_13h_sJBKreugYJORz9GyMSn_wQflUdKlPMQzd1q-FRZI9T_pfMqFGIMPTc4Ni_M-tv4BZsb9TiEHYd54Zcsy6hKd9UKW2VyDnJPZobUEuciJQ"
    private let _apiUrl = "https://mobile-demo.xapt.com/reverse170/mobapi/sales"

    required init() {
        super.init()
        title.val = "Menu"

        BaseDataProvider.instance.initialization(DataProviderContext(apiUrl: _apiUrl, token: _token))
                .delay(10, scheduler: MainScheduler.instance)
                .subscribe(onError: { print("Data provider init failed. \($0)") }, onCompleted: {
                    BaseDataProvider.instance.synchronize()
                }) => disposeBag

        menuItems.val = [
            MenuItemViewModel(MenuModel(id: Menu.EMRShipping, name: "Shipping", iconName: "menu_icon_24_dp_shipping")),
            MenuItemViewModel(MenuModel(id: Menu.EMRReceiving, name: "Receiving", iconName: "menu_icon_24_dp_receiving")),
        ]

        selectMenuCommand += { menu in
            switch menu.id {
            case .EMRShipping: self.next(step: RentalStep.EMR(type: EMRType.Shipping))
            case .EMRReceiving: self.next(step: RentalStep.EMR(type: EMRType.Receiving))
            }
        } => disposeBag

        showSettingsCommand += { _ in
            self.next(step: RentalStep.settings)
        } => disposeBag
    }
}
