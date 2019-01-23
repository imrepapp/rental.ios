//
//  AppDelegate.swift
//  Rental
//
//  Created by Krisztián KORPA on 2018. 12. 13..
//  Copyright © 2018. XAPT Kft. All rights reserved.
//

import NAXT_Mobile_Data_Entity_Framework
import RxFlow

@UIApplicationMain
class AppDelegate : BaseAppDelegate {
    override init () {
        super.init(mainFlow: MainFlow(), initialStep: RentalStep.login)
        //super.init(mainFlow: EMRFlow(), initialStep: RentalStep.EMRLine(EMRLineParameters(id: "LOFASZ", type: EMRType.Receiving)))
    }
}
