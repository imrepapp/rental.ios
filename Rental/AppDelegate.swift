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

@UIApplicationMain
class AppDelegate: BaseAppDelegate<RentalSettings, RentalApi> {
    override init() {
        super.init(mainFlow: MainFlow(), initialStep: RentalStep.login)

        // add DAOs
        BaseDataProvider.instance.addDAO([
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

        container.register(BaseApi.self) { _ in
            RentalApi()
        }.inObjectScope(.container)

        container.register(BarcodeScan.self) { _ in
            BarcodeScanService()
        }.inObjectScope(.container)

        container.register(CustomApi.self) { _ in
            CustomApiService()
        }.inObjectScope(.container)
    }
}
