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


/*
@objc dynamic var dataAreaId: String = ""
    @objc dynamic var replacementReason: String = ""
    @objc dynamic var updatedAt: Date = Date(timeIntervalSince1970: 1)
    @objc dynamic var barCode: String = ""
    @objc dynamic var emrType: Int = 0
    @objc dynamic var machineTypeId: String = ""
    @objc dynamic var emrId: String = ""
    @objc dynamic var equipmentId: String = ""
    @objc dynamic var smu: Double = 0.0
    @objc dynamic var inventSerialId: String = ""
    @objc dynamic var secondarySMU: Double = 0.0
    @objc dynamic var note: String = ""
    @objc dynamic var toInventLocation: String = ""
    @objc dynamic var fuelLevel: Double = 0.0
    @objc dynamic var itemId: String = ""
    @objc dynamic var replacementEqId: String = ""
    @objc dynamic var fromInventLocation: String = ""
    @objc dynamic var quantity: Double = 0.0
    @objc dynamic var emrDescription: String = ""

    @objc dynamic var emrStatus: String = "Request"
    @objc dynamic var renBulkItemAvail: String = "No"
    @objc dynamic var lineType: String = "Regular"
    @objc dynamic var isAttachment: String = "No"
    @objc dynamic var direction: String = "Outbound"

    @objc dynamic var isShipped: Bool = false
    @objc dynamic var isReceived: Bool = false
    @objc dynamic var isScanned: Bool = false
*/