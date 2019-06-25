//
// Created by Attila AMBRUS on 2019-04-15.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Base
import RxCocoa

class EMRCheckListItemViewModel: SimpleViewModel {
    private var _model: MOB_RenInspectionChecklistHistory
    var equipmentId = BehaviorRelay<String?>(value: nil)
    var emrId = BehaviorRelay<String?>(value: nil)
    var desc = BehaviorRelay<String?>(value: nil)
    var checked = BehaviorRelay<Bool>(value: false)

    init(model: MOB_RenInspectionChecklistHistory) {
        self._model = model

        self.equipmentId.val = model.equipmentId
        self.emrId.val = model.emrId
        self.desc.val = model.name
        self.checked.val = model.checked == "Yes"
    }

    func asModel() -> MOB_RenInspectionChecklistHistory {
        _model.checked = checked.val ? "Yes" : "No"
        return _model
    }
}
