//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import RxCocoa

struct ManualScanParameters : Parameters {
    let type: EMRType
}

class ManualScanViewModel: BaseViewModel {
    private var parameters = ManualScanParameters(type: EMRType.Receiving)

    let barcode = BehaviorRelay<String?>(value: nil)
    let cancelCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()

    override func instantiate(with params: Parameters) {
        parameters = params as! ManualScanParameters

        title.val = "Manual scan"

        cancelCommand += { _ in
            self.next(step:RentalStep.dismiss)
        } => disposeBag
        
        saveCommand += { _ in
            self.send(message: .alert(title: "\(self.parameters.type)".uppercased(), message: "READ: \(self.barcode)"))
        } => disposeBag
    }
}
