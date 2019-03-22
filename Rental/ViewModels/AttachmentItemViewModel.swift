//
// Created by Papp Imre on 2019-01-21.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxCocoa

class AttachmentItemViewModel: SimpleViewModel {
    let eqId = BehaviorRelay<String?>(value: nil)
    let serial = BehaviorRelay<String?>(value: nil)
    let model = BehaviorRelay<String?>(value: nil)
    let fleetType = BehaviorRelay<Int64>(value: 0)
    let warehouse = BehaviorRelay<String?>(value: nil)
    let location = BehaviorRelay<String?>(value: nil)

    init(_ model: AttachmentModel) {
        self.eqId.val = model.eqId
        self.serial.val = model.inventSerialId
        self.model.val = model.machineTypeId
        self.fleetType.val = model.fleetType
        self.warehouse.val = model.warehouse
        self.location.val = model.location
    }

    func asModel() -> AttachmentModel {
        return AttachmentModel(
                eqId: self.eqId.val!,
                inventSerialId: self.serial.val!,
                machineTypeId: self.model.val!,
                fleetType: self.fleetType.val,
                warehouse: self.warehouse.val!,
                location: self.location.val!
        )
    }
}
