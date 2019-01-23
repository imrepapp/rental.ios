//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NAXT_Mobile_Data_Entity_Framework
import RxSwift
import RxCocoa

class EMRItemViewModel: SimpleViewModel {
    let eqId = BehaviorRelay<String?>(value: nil)
    let emrId = BehaviorRelay<String?>(value: nil)
    let type = BehaviorRelay<String?>(value: nil)
    let direction = BehaviorRelay<String?>(value: nil)
    let model = BehaviorRelay<String?>(value: nil)
    let schedule = BehaviorRelay<String?>(value: nil)
    let from = BehaviorRelay<String?>(value: nil)
    let fromLabel = BehaviorRelay<String?>(value: nil)

    init(_ model: EMRLineModel) {
        self.eqId.val = model.eqId
        self.emrId.val = model.emrId
        self.type.val = model.type
        self.direction.val = model.direction
        self.model.val = model.model
        self.schedule.val = model.schedule
        self.from.val = model.from

        self.direction.bind { [weak self] dir in
            self!.fromLabel.val = dir == "Inbound" ? "To" : "From"
        } => disposeBag
    }

    func asModel() -> EMRLineModel {
        fatalError("asModel() has not been implemented")
    }
}
