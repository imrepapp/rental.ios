//
//  AttachmentModel.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 14..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import NMDEF_Base

struct AttachmentModel: BaseModel, Decodable {
    var eqId: String
    var inventSerialId: String
    var machineTypeId: String
    var fleetType: Int64
    var warehouse: String
    var location: String

    enum CodingKeys: String, CodingKey {
        case eqId = "EquipmentId"
        case inventSerialId = "InventSerialId"
        case machineTypeId = "MachineTypeId"
        case fleetType = "FleetType"
        case warehouse = "Warehouse"
        case location = "Location"
    }
}