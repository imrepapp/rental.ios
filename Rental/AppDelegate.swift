//
//  AppDelegate.swift
//  Rental
//
//  Created by Krisztián KORPA on 2018. 12. 13..
//  Copyright © 2018. XAPT Kft. All rights reserved.
//

import NMDEF_Base
import NMDEF_Sync
import RxFlow
import UserNotifications

@UIApplicationMain
class AppDelegate: BaseAppDelegate<RentalSettings, RentalApiService> {
    override init() {
        super.init(mainFlow: MainFlow(), initialStep: RentalStep.login)

        // add DAOs
        BaseDataProvider.instance.addDAO([
            DamageCodesDAO(),
            DamageHistoryDAO(),
            RenParametersDAO(),
            ModDateTimesDAO(),
            RenEMRLineDAO(),
            RenEMRTableDAO(),
            RenReplacementReasonDAO(),
            RenWorkerWarehouseDAO()
        ])

        // add handlers

        // register services
        container.register(UserAuthServiceProtocol.self) { _ in
            UserAuthService(
                    loginAuthServiceProtocol: LoginAuthService<LoginResponse>(),
                    hcmWorkerAuthServiceProtocol: HcmWorkerAuthService<WorkerData>()
            )
        }.inObjectScope(.container)

        container.register(BaseSettings.self) { _ in
            RentalSettings()
        }.inObjectScope(.container)

        container.register(BarcodeScan.self) { _ in
            BarcodeScanService()
        }.inObjectScope(.container)

        container.register(BaseApi.self) { _ in
            RentalApiService()
        }.inObjectScope(.container)

        container.register(NetworkManagerProtocol.self) { _ in
            NetworkManager()
        }.inObjectScope(.container)

        // Request user's permission to send notifications.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notifications permission granted.")
            }
            else {
                print("Notifications permission denied because: \(error?.localizedDescription ?? "unknown error happened").")
            }
        }
    }
}
