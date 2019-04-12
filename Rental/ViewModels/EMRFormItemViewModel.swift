//
// Created by Attila AMBRUS on 2019-04-05.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa

protocol EMRFormItemVars: BaseModel {
    var fuelLevel: Double { get set }
    var smu: Double { get set }
    var secondarySMU: Double { get set }
    var quantity: Double { get set }
    var operation: String { get set }
}

protocol EMRFormItem: EMRFormItemVars where Self: BaseEntity {
    func fromViewModel(viewModel: EMRFormItemViewModelGeneric<Self>) -> Self
}

class EMRFormItemViewModel: SimpleViewModel {
    let eqId = BehaviorRelay<String?>(value: nil)
    let contractId = BehaviorRelay<String?>(value: nil)
    let modelId = BehaviorRelay<String?>(value: nil)
    let serialNumber = BehaviorRelay<String?>(value: nil)
    let barcode = BehaviorRelay<String?>(value: nil)
    let deliveryDate = BehaviorRelay<String?>(value: nil)
    let emrType = BehaviorRelay<String?>(value: nil)
    let direction = BehaviorRelay<String?>(value: nil)
    let fromRelationName = BehaviorRelay<String?>(value: nil)
    let fromRelationType = BehaviorRelay<String?>(value: nil)
    let toInventLocation = BehaviorRelay<String?>(value: nil)
    let toWMSLocation = BehaviorRelay<String?>(value: nil)
    let qty = BehaviorRelay<String?>(value: nil)
    let fuelLevel = BehaviorRelay<String?>(value: nil)
    let SMU = BehaviorRelay<String?>(value: nil)
    let secondarySMU = BehaviorRelay<String?>(value: nil)
    let deliveryNotes = BehaviorRelay<String?>(value: nil)
    let notes = BehaviorRelay<String?>(value: nil)

    convenience init() {
        self.init(MOB_EquipmentBarCode())
    }

    init(_ model: MOB_EquipmentBarCode) {
        self.eqId.val = model.id
        self.contractId.val = model.rentalId
        self.modelId.val = model.machineType
        self.serialNumber.val = model.inventSerialId
        self.barcode.val = model.barCode
        self.emrType.val = "Rental"
        self.direction.val = "Inbound"
        self.fromRelationName.val = model.fromRelationName
        self.fromRelationType.val = model.fromRelationType
        self.qty.val = "1"

        if let activeWarehouse = BaseDataProvider.DAO(WorkerInvLocationsDAO.self)
                .lookUp(predicate: NSPredicate(format: "responsibleWorker = %d and defReceiptWMSLoc = %@", argumentArray: [
                    AppDelegate.settings.userAuthContext!.hcmWorkerId,
                    "Yes"
                ])) {
            self.toInventLocation.val = activeWarehouse.inventLocationId
            self.toWMSLocation.val = activeWarehouse.wmsLocationId
        }
    }

    func asModel() -> BaseEntity {
        fatalError("asModel() has not been implemented")
    }
}

class EMRFormItemViewModelGeneric<T: EMRFormItem>: EMRFormItemViewModel {
    override func asModel() -> BaseEntity {
        return T.init().fromViewModel(viewModel: self)
    }
}
