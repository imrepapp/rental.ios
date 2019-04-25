//
// Created by Attila AMBRUS on 2019-04-15.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import MicrosoftAzureMobile_Xapt
import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa
import EVReflection
import RealmSwift

struct EMRCheckListParameters: Parameters {
    var line: RenEMRLine
}

class EMRCheckListViewModel: BaseDataLoaderViewModel<[MOB_RenInspectionChecklistHistory]> {
    var parameters = BehaviorRelay<EMRCheckListParameters>(value: EMRCheckListParameters(line: RenEMRLine()))
    var items = BehaviorRelay<[EMRCheckListItemViewModel]>(value: [])
    var cancelCommand = PublishRelay<Void>()
    var saveCommand = PublishRelay<Void>()

    override var datasource: Observable<[MOB_RenInspectionChecklistHistory]> {
        return RenInspectionChecklistHistoryDAO().filterAsync(predicate: NSPredicate(format: "EMRId = %@ and EquipmentId = %@ and StatusAction = %@", argumentArray: [
            self.parameters.val.line.emrId,
            self.parameters.val.line.equipmentId,
            self.parameters.val.line.emrType == 1 ? "Ship" : "Receive"
        ])).asObservable()
    }

    override func loadData(data: [MOB_RenInspectionChecklistHistory]) {
        items.val = []
        _ = data.map {
            items.val.append(EMRCheckListItemViewModel(model: $0))
        }
    }

    override func instantiate(with params: Parameters) {
        parameters.val = params as! EMRCheckListParameters

        cancelCommand += {
            self.next(step: RentalStep.dismiss)
        }

        saveCommand += {
            self.isLoading.val = true

            var inserts: [Observable<Bool>] = []
            var errorCount: [String] = []

            for var model in self.items.val {
                inserts.append(self._save(model: model.asModel())
                        .asObservable()
                        .do(onError: { error in
                            if !errorCount.contains(error.message) {
                                errorCount.append(error.message)
                            }
                        })
                        .catchErrorJustReturn(false))
            }

            Observable.merge(inserts).do(onError: { error in
                        self.send(message: .msgBox(title: "Error", message: "An error has been occurred."))
                    }, onCompleted: {
                        self.isLoading.val = false

                        if errorCount.count > 0 {
                            self.send(message: .msgBox(title: "Error", message: errorCount.joined(separator: "\n")))
                        } else {
                            var realm = try! Realm()
                            var item: MOB_RenEMRLine = MOB_RenEMRLine.init(dictionary: self.parameters.val.line.toDictionary())
                            item.isChecked = true

                            try! realm.write {
                                realm.add(item, update: true)
                            }

                            self.send(message: .alert(config: AlertConfig(title: "", message: "Save was successful.", actions: [
                                UIAlertAction(title: "Ok", style: .default, handler: { alert in 
                                    self.next(step: RentalStep.dismiss)
                                })
                            ])))
                        }
                    })
                    .subscribe()
        }
    }

    private func _save(model: MOB_RenInspectionChecklistHistory) -> Single<Bool> {
        return RenInspectionChecklistHistoryDAO().update(model: model)
    }
}
