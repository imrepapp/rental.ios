//
// Created by Attila AMBRUS on 2019-04-04.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import MicrosoftAzureMobile_Xapt
import NMDEF_Base
import NMDEF_Sync
import RxCocoa
import RxSwift

enum EMRFormType {
    case emr
    case receiving
}

struct EMRFormParameters: Parameters {
    var formType: EMRFormType
    var eqBarcode: MOB_EquipmentBarCode
}

class EMRFormViewModel: BaseViewModel {
    private var _formType = EMRFormType.emr

    var formItem = EMRFormItemViewModel()
    var formType = PublishRelay<EMRFormType>()
    var activeWmsLocation = BehaviorRelay<RenWorkerWarehouse>(value: RenWorkerWarehouse())
    var inventLocation = BehaviorRelay<WorkerInvLocations>(value: WorkerInvLocations())
    var inventLocations = BehaviorRelay<[RenWorkerWarehouse]>(value: [RenWorkerWarehouse]())
    var wmsLocations = BehaviorRelay<[WorkerInvLocations]>(value: [WorkerInvLocations]())
    var isEMRTypeViewHidden = BehaviorRelay<Bool>(value: true)
    var fromViewIsHidden = BehaviorRelay<Bool>(value: true)
    var cancelCommand = PublishRelay<Void>()
    var saveCommand = PublishRelay<Void>()

    override func instantiate(with params: Parameters) {
        var parameters = params as! EMRFormParameters

        switch parameters.formType {
        case .emr: formItem = EMRFormItemViewModelGeneric<RenEMRLine>(parameters.eqBarcode)
        case .receiving: formItem = EMRFormItemViewModelGeneric<RenEMRArrival>(parameters.eqBarcode)
        }

        self.formType += { ft in
            self._formType = ft
            var type = ft == .receiving ? "receiving" : "EMR"
            self.title.val = String(format: "Create %@ record", type)
            self.fromViewIsHidden.val = ft == .receiving

            switch ft {
            case .emr:
                self.formItem.emrType.val = "Rental"
                self.formItem.direction.val = "Inbound"
            case .receiving:
                break
            }
        }

        formItem.toInventLocation += { id in
            self.wmsLocations.val = []
            self.formItem.toWMSLocation.val = ""

            if let wmsId = id {
                BaseDataProvider.DAO(WorkerInvLocationsDAO.self)
                        .filter(predicate: NSPredicate(format: "inventLocationId = %@", argumentArray: [id]))
                        .map {
                            self.wmsLocations.val.append($0)
                        }

                if self.wmsLocations.val.count > 0 {
                    self.formItem.toWMSLocation.val = self.wmsLocations.val.filter({ (wms) -> Bool in wms.defReceiptWMSLoc == "Yes" }).first?.wmsLocationId
                            ?? self.wmsLocations.val.first?.wmsLocationId
                } else {
                    self.formItem.toWMSLocation.val = ""
                }
            }
        } => disposeBag

        cancelCommand += {
            self.next(step: RentalStep.dismiss)
        } => disposeBag

        saveCommand += {
            self.isLoading.val = true
            var s: EMRFormItemVars = self.formItem.asModel() as! EMRFormItemVars

            switch self._formType {
            case .emr:
                s.operation = "CreateReceivingEMR"
                (s as! RenEMRLine).emrType = 2
                (s as! RenEMRLine).emrId = "DummyEMRId"
                (s as! RenEMRLine).direction = "Inbound"
            case .receiving:
                //(s as! RenEMRArrival).notes = "Notes"
                //(s as! RenEMRArrival).itemId = "ItemId"
                s.operation = "CreateReceivingRecord"
            }

            var dao: BaseSyncDataAccessObject

            switch parameters.formType {
            case .emr: dao = BaseDataProvider.DAO(RenEMRLineDAO.self)
            case .receiving: dao = BaseDataProvider.DAO(RenEMRArrivalDAO.self)
            }

            dao.insertAndPushIfOnline(model: (s as! BaseEntity))
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { item in
                        self.isLoading.val = false
                        self.send(message: .alert(config: AlertConfig(title: "Success", message: "Save was successful.", actions: [
                            UIAlertAction(title: "Ok", style: .default, handler: { alert in self.next(step: RentalStep.dismiss) })
                        ])))
                    }, onError: { error in
                        self.isLoading.val = false
                        self.send(message: .msgBox(title: "Error", message: error.message))
                    })
        } => disposeBag

        BaseDataProvider.DAO(RenWorkerWarehouseDAO.self).items.map {
            self.inventLocations.val.append($0)
        }

        formItem.toInventLocation.val = self.inventLocations.val.filter {
            $0.activeWarehouse == "Yes"
        }.first?.inventLocationId
        formType.accept(parameters.formType)
        isEMRTypeViewHidden.val = _formType == .receiving
    }
}
