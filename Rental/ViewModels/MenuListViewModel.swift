//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Base
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

    required init() {
        super.init()
        title.val = "Menu"

        isLoading.val = true

        AppDelegate.userAuthService.getWorkerData()
                .map { workerData in
                    if workerData.hcmWorkerId == 0 {
                        self.send(message: .alert(config: AlertConfig(title: "Error", message: "Your user doesn't have a worker. Please set one for it.", actions: [
                            UIAlertAction(title: "Ok", style: .default, handler: { alert in
                                self.next(step: RentalStep.login)
                                return
                            })
                        ])))
                        return
                    }

                    if workerData.dataAreaId.isEmpty {
                        self.send(message: .alert(config: AlertConfig(title: "Error", message: "You don't have a company set in the AX.", actions: [
                            UIAlertAction(title: "Ok", style: .default, handler: { alert in
                                self.next(step: RentalStep.login)
                                return
                            })
                        ])))
                        return
                    }

                    BaseDataProvider.instance.initialization(DataProviderContext(apiUrl: AppDelegate.settings.apiUrl, token: AppDelegate.token))
                            .observeOn(MainScheduler.instance)
                            .subscribe(onError: { error in
                                self.send(message: .alert(config: AlertConfig(title: "Error", message: "Data provider init failed. \(error)", actions: [
                                    UIAlertAction(title: "Ok", style: .default, handler: { alert in
                                        self.next(step: RentalStep.login)
                                        return
                                    })
                                ])))
                            }, onCompleted: {
                                self.isLoading.val = false
                            }) => self.disposeBag
                }
                .subscribe(onError: { error in
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
                            self.next(step: RentalStep.login)
                        })
                    ])))
                }) => self.disposeBag

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
