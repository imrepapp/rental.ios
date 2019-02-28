//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import RxCocoa

class EMRItemViewModel: SimpleViewModel {
    let id = BehaviorRelay<String?>(value: nil)
    let emrId = BehaviorRelay<String?>(value: nil)

    let eqId = BehaviorRelay<String?>(value: nil)
    let quantity = BehaviorRelay<String?>(value: nil)

    let type = BehaviorRelay<String?>(value: nil)
    let direction = BehaviorRelay<String?>(value: nil)
    let status = BehaviorRelay<String?>(value: nil)
    let model = BehaviorRelay<String?>(value: nil)
    let serial = BehaviorRelay<String?>(value: nil)

    let agreementType = BehaviorRelay<String?>(value: nil)
    let agreement = BehaviorRelay<String?>(value: nil)

    let from = BehaviorRelay<String?>(value: nil)
    let fromAddress = BehaviorRelay<String?>(value: nil)

    let to = BehaviorRelay<String?>(value: nil)
    let toAddress = BehaviorRelay<String?>(value: nil)

    let contact = BehaviorRelay<String?>(value: nil)
    let phone = BehaviorRelay<String?>(value: nil)

    let deliveryNotes = BehaviorRelay<String?>(value: nil)
    let notes = BehaviorRelay<String?>(value: nil)

    let fuel = BehaviorRelay<String?>(value: nil)
    let smu = BehaviorRelay<String?>(value: nil)
    let secSMU = BehaviorRelay<String?>(value: nil)

    let isScanned = BehaviorRelay<Bool>(value: false)
    let isShipped = BehaviorRelay<Bool>(value: false)
    let isReceived = BehaviorRelay<Bool>(value: false)
    let isNotReplaceableAttachment = BehaviorRelay<Bool>(value: true)

    let emrType = BehaviorRelay<Int>(value: 0)
    let schedule = BehaviorRelay<String?>(value: nil)
    let addressLabel = BehaviorRelay<String?>(value: nil)
    let address = BehaviorRelay<String?>(value: nil)

    convenience init() {
        self.init(RenEMRLine())
    }

    init(_ model: RenEMRLine) {
        self.id.val = model.id

        self.emrId.val = model.emrId

        self.eqId.val = model.equipmentId
        self.quantity.val = String(format:"%.1f", model.quantity)

        self.emrType.val = model.emrType
        self.direction.val = model.emr?.direction

        self.model.val = model.machineTypeId
        self.serial.val = model.inventSerialId
        self.status.val = model.emrStatus
        self.agreementType.val = model.emr?.agreementRelationType
        self.agreement.val = model.emr?.agreementRelation

        self.from.val = model.emr?.fromRelationName
        self.fromAddress.val = model.emr?.fromAddressDisplay

        self.to.val = model.emr?.toRelationName
        self.toAddress.val = model.emr?.toAddressDisplay

        self.contact.val = model.emr?.customerContactName
        self.phone.val = model.emr?.customerContactPhone

        self.deliveryNotes.val = model.emr?.deliveryNote
        self.notes.val = model.note

        self.fuel.val = String(format:"%.1f", model.fuelLevel)
        self.smu.val = String(format:"%.1f", model.smu)
        self.secSMU.val = String(format:"%.1f", model.secondarySMU)

        self.isScanned.val = model.isScanned
        self.isShipped.val = model.isShipped
        self.isReceived.val = model.isReceived

        self.type.val = model.emr?.emrType

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var deliveryDateString = ""
        if let deliveryDate = model.emr?.deliveryDate {
            deliveryDateString = formatter.string(from: deliveryDate)
        }
        self.schedule.val = deliveryDateString

        self.addressLabel.val = model.addressLabel
        self.address.val = model.address
    }

    func asModel() -> EMRLineModel {
        fatalError("asModel() has not been implemented")
    }
}