//
// Created by Attila AMBRUS on 2019-04-04.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import MicrosoftAzureMobile_Xapt
import EVReflection
import NMDEF_Sync

class MOB_EquipmentBarCode: BaseEntity {
    @objc dynamic var inventSerialId: String = ""
    @objc dynamic var fromRelationName: String = ""
    @objc dynamic var fromRelationType: String = "None"
    @objc dynamic var rentalId: String = ""
    @objc dynamic var barCode: String = ""
    @objc dynamic var machineType: String = ""
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var deliveryDate: Date = Date(timeIntervalSince1970: 1)
}