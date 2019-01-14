//
//  EMRLine.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import Foundation

class EMRLine {
    
    var eqId: String
    var emrId: String
    var type: String
    var direction: String
    var model: String
    var schedule: String
    var from: String
    
    init(_eqId: String, _emrId: String, _type: String, _direction: String, _model: String, _schedule: String, _from: String) {
        eqId = _eqId
        emrId = _emrId
        type = _type
        direction = _direction
        model = _model
        schedule = _schedule
        from = _from
    }
    
}
