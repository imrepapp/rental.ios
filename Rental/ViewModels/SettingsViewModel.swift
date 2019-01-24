//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NAXTMobileDataEntityFramework
import RxSwift
import RxCocoa
import RxFlow

class SettingsViewModel: BaseViewModel {
    let emailAddress = BehaviorRelay<String?>(value: nil)
    let environmentName = BehaviorRelay<String?>(value: nil)
    let appVersion = BehaviorRelay<String?>(value: nil)
    let syncDate = BehaviorRelay<String?>(value: nil)
    let connectionStatus = BehaviorRelay<String?>(value: nil)

    let synchronizeCommand = PublishRelay<Void>()
    let logoutCommand = PublishRelay<Void>()

    required init() {
        super.init()
        title.val = "Settings"
        emailAddress.val = "email address"
        environmentName.val = "environment name"
        appVersion.val = "application version"
        syncDate.val = "synchronization date"
        connectionStatus.val = "connection status"

        synchronizeCommand += {
            //TODO: ask for synchronize
            //TODO: start synchronization
            self.send(message: .alert(title: "SYNCHRONIZE", message: "synchronize button pressed"))
        } => disposeBag

        logoutCommand += {
            //TODO: ask for logout
            //TODO: logout
            self.next(step: RentalStep.login)
        } => disposeBag
    }
}
