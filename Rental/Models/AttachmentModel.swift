//
//  AttachmentModel.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 14..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import NMDEF_Base

struct AttachmentModel: BaseModel {
    var eqId: String
    var inventSerialId: String
    var machineTypeId: String
    var fleetType: String
    var warehouse: String
    var location: String
}