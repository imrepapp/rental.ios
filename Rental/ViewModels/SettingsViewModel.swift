//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Base
import RxSwift
import RxCocoa
import RxFlow
import NMDEF_Sync

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

        emailAddress.val = AppDelegate.settings.userAuthContext?.userIdentifier
        environmentName.val = AppDelegate.settings.userAuthContext?.selectedConfig?.name
        appVersion.val = AppDelegate.settings.appVersion
        syncDate.val = AppDelegate.settings.syncConfig.lastTime == Date.distantPast ? "Not synced" : AppDelegate.settings.syncConfig.lastTime.toString()
        connectionStatus.val = AppDelegate.networkManager.isNetworkAvailable.val ? "Connected" : "Not connected"

        synchronizeCommand += {
            self.send(message: .alert(config: AlertConfig(
                    title: "Synchronization",
                    message: "Are you sure that you want to synchronize?",
                    actions: [UIAlertAction(title: "Ok", style: .default, handler: { alert in

                        BaseDataProvider.instance.synchronize(priority: .high)
                        AppDelegate.settings.syncConfig.lastTime = Date()

                    }), UIAlertAction(title: "Cancel", style: .default, handler: { alert in
                        self.next(step: RentalStep.dismiss)
                    })])))
            return

        } => disposeBag

        logoutCommand += {
            self.send(message: .alert(config: AlertConfig(
                    title: "Logout",
                    message: "Are you sure that you want to log out from the application",
                    actions: [UIAlertAction(title: "Ok", style: .default, handler: { alert in

                        //TODO: Change the step to .end version to clear navigation history (close the flow)
                        self.next(step: RentalStep.login)
                    }), UIAlertAction(title: "Cancel", style: .default, handler: { alert in
                        self.next(step: RentalStep.dismiss)
                    })])))
            return
        } => disposeBag
    }
}
