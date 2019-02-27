//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import RxCocoa

class EMRItemViewModel: SimpleViewModel {
    let eqId = BehaviorRelay<String?>(value: nil)
    let emrId = BehaviorRelay<String?>(value: nil)
    let type = BehaviorRelay<String?>(value: nil)
    let direction = BehaviorRelay<String?>(value: nil)
    let model = BehaviorRelay<String?>(value: nil)
    let schedule = BehaviorRelay<String?>(value: nil)
    let addressLabel = BehaviorRelay<String?>(value: nil)
    let address = BehaviorRelay<String?>(value: nil)
    let isScanned = BehaviorRelay<Bool>(value: false)
    let isShipped = BehaviorRelay<Bool>(value: false)
    let isReceived = BehaviorRelay<Bool>(value: false)

    init(_ model: RenEMRLine) {
        self.eqId.val = model.equipmentId
        self.emrId.val = model.emrId
        self.type.val = model.lineType
        self.direction.val = "Inbound"
        self.schedule.val = "Schedule"
        self.addressLabel.val = model.addressLabel
        self.address.val = model.address
        self.direction.val = model.machineTypeId
        self.isScanned.val = model.isScanned
        self.isShipped.val = model.isShipped
        self.isReceived.val = model.isReceived
    }

    func asModel() -> EMRLineModel {
        fatalError("asModel() has not been implemented")
    }
}
