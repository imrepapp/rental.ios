//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import RxCocoa

class EMRItemViewModel: SimpleViewModel {
    let id = BehaviorRelay<String?>(value: nil)
    let eqId = BehaviorRelay<String?>(value: nil)
    let emrId = BehaviorRelay<String?>(value: nil)
    let type = BehaviorRelay<String?>(value: nil)
    let emrType = BehaviorRelay<Int>(value: 0)
    let direction = BehaviorRelay<String?>(value: nil)
    let model = BehaviorRelay<String?>(value: nil)
    let schedule = BehaviorRelay<String?>(value: nil)
    let addressLabel = BehaviorRelay<String?>(value: nil)
    let address = BehaviorRelay<String?>(value: nil)
    let isScanned = BehaviorRelay<Bool>(value: false)
    let isShipped = BehaviorRelay<Bool>(value: false)
    let isReceived = BehaviorRelay<Bool>(value: false)
    let status = BehaviorRelay<String?>(value: nil)
    let serial = BehaviorRelay<String?>(value: nil)
    let fuel = BehaviorRelay<String?>(value: nil)
    let smu = BehaviorRelay<String?>(value: nil)
    let secSMU = BehaviorRelay<String?>(value: nil)
    let quantity = BehaviorRelay<String?>(value: nil)
    let isNotReplaceableAttachment = BehaviorRelay<Bool>(value: true)

    convenience init() {
        self.init(RenEMRLine())
    }

    init(_ model: RenEMRLine) {
        self.id.val = model.id
        self.eqId.val = model.equipmentId
        self.emrId.val = model.emrId
        self.type.val = model.lineType
        self.emrType.val = model.emrType
        self.direction.val = "Inbound"
        self.schedule.val = "Schedule"
        self.addressLabel.val = model.addressLabel
        self.address.val = model.address
        self.direction.val = model.machineTypeId
        self.isScanned.val = model.isScanned
        self.isShipped.val = model.isShipped
        self.isReceived.val = model.isReceived
        self.status.val = model.emrStatus
        self.serial.val = model.inventSerialId
        self.fuel.val = String(format:"%.1f", model.fuelLevel)
        self.smu.val = String(format:"%.1f", model.smu)
        self.secSMU.val = String(format:"%.1f", model.secondarySMU)
        self.quantity.val = String(format:"%.1f", model.quantity)
    }

    func asModel() -> EMRLineModel {
        fatalError("asModel() has not been implemented")
    }
}