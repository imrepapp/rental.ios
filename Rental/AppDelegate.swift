//
//  AppDelegate.swift
//  Rental
//
//  Created by Krisztián KORPA on 2018. 12. 13..
//  Copyright © 2018. XAPT Kft. All rights reserved.
//

import NAXTMobileDataEntityFramework
import NMDEF_Sync
import RxFlow

@UIApplicationMain
class AppDelegate : BaseAppDelegate {
    override init () {
        super.init(mainFlow: MainFlow(), initialStep: RentalStep.login)
//        super.init(mainFlow: EMRFlow(), initialStep: RentalStep.EMRList(EMRListParameters(type: EMRType.Shipping, filter: false)))

        // add DAOs
        BaseDataProvider.instance.addDAO([
            ModDateTimesDAO(),
            RenEMRLineDAO(),
            RenEMRTableDAO(),
            RenReplacementReasonDAO(),
            RenWorkerWarehouseDAO()
        ])

        // add handlers
    }
}
