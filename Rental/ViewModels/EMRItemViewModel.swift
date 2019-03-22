//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa

class EMRItemViewModel: SimpleViewModel {
    let id = BehaviorRelay<String?>(value: nil)
    let emrId = BehaviorRelay<String?>(value: nil)

    let eqId = BehaviorRelay<String?>(value: nil)
    let eqIdTitle = BehaviorRelay<String?>(value: "EQ/Item ID")
    let quantity = BehaviorRelay<String?>(value: nil)

    let type = BehaviorRelay<String?>(value: nil)
    let direction = BehaviorRelay<String?>(value: nil)
    let status = BehaviorRelay<String?>(value: nil)
    let model = BehaviorRelay<String?>(value: nil)
    let modelTitle = BehaviorRelay<String?>(value: "Model")
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
    let isHiddenShipped = BehaviorRelay<Bool>(value: true)
    let isHiddenModel = BehaviorRelay<Bool>(value: false)
    let isReceived = BehaviorRelay<Bool>(value: false)
    let isNotReplaceableAttachment = BehaviorRelay<Bool>(value: true)

    let emrType = BehaviorRelay<Int>(value: 0)
    let schedule = BehaviorRelay<String?>(value: nil)
    let addressLabel = BehaviorRelay<String?>(value: nil)
    let address = BehaviorRelay<String?>(value: nil)
    let customer = BehaviorRelay<String?>(value: nil)
    let itemType = BehaviorRelay<String?>(value: nil)

    let barcode = BehaviorRelay<String?>(value: nil)
    let replaceAttachmentId = BehaviorRelay<String?>(value: nil)

    convenience init() {
        self.init(RenEMRLine())
    }

    init(_ model: RenEMRLine) {
        self.id.val = model.id

        self.emrId.val = model.emrId

        self.eqId.val = model.equipmentId

        if (model.itemType == "Equipment") {
            self.eqIdTitle.val = "Equipment ID"
            self.isHiddenModel.val = false
        } else if (model.itemType == "Attachment") {
            self.eqIdTitle.val = "Attachment ID"
            self.isHiddenModel.val = false
        } else {
            self.eqIdTitle.val = "Item ID"
            self.isHiddenModel.val = true
        }

        self.quantity.val = String(format: "%.1f", model.quantity)

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

        self.fuel.val = String(format: "%.1f", model.fuelLevel)
        self.smu.val = String(format: "%.1f", model.smu)
        self.secSMU.val = String(format: "%.1f", model.secondarySMU)

        self.isScanned.val = model.isScanned
        self.isShipped.val = model.isShipped
        self.isHiddenShipped.val = !(model.isShipped)
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
        self.customer.val = model.customer
        self.itemType.val = model.itemType

        self.barcode.val = model.barCode
    }

    func asModel() -> EMRLineModel {
        fatalError("asModel() has not been implemented")
    }

    func asBaseEntity() -> MOB_RenEMRLine {

        var _baseEntity = BaseDataProvider.DAO(RenEMRLineDAO.self).lookUp(id: self.id.val!)

        _baseEntity?.quantity = Double(self.quantity.val!)!
        _baseEntity?.smu = Double(self.smu.val!)!
        _baseEntity?.secondarySMU = Double(self.secSMU.val!)!
        _baseEntity?.fuelLevel = Double(self.fuel.val!)!

        return _baseEntity!
    }
}