//
//  EMRLineModel.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import NAXT_Mobile_Data_Entity_Framework

struct EMRLineModel: BaseModel {
    var eqId: String
    var emrId: String
    var type: String
    var direction: String
    var model: String
    var schedule: String
    var from: String
}
