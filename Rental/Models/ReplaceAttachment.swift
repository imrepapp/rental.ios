//
//  Attachment.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 14..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import Foundation

class ReplaceAttachment {
    
    var eqId: String
    var inventSerialId: String
    var machineTypeId: String
    var fleetType: String
    var warehouse: String
    var location: String
    
    init(_eqId: String, _inventSerialId: String, _machineTypeId: String, _fleetType: String, _warehouse: String, _location: String) {
        eqId = _eqId
        inventSerialId = _inventSerialId
        machineTypeId = _machineTypeId
        fleetType = _fleetType
        warehouse = _warehouse
        location = _location
    }
    
}
