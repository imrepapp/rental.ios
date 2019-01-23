//
//  AttachmentModel.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 14..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import NAXT_Mobile_Data_Entity_Framework

struct AttachmentModel: BaseModel {
    var eqId: String
    var inventSerialId: String
    var machineTypeId: String
    var fleetType: String
    var warehouse: String
    var location: String
}