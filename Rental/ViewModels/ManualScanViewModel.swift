//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa

struct ManualScanParameters : Parameters {

}

class ManualScanViewModel: BaseViewModel {
    private var parameters = ManualScanParameters()

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
            guard let line = BaseDataProvider.DAO(RenEMRLineDAO.self).lookUp(predicate: NSPredicate(format: "barcode = %@", argumentArray: [self.barcode])) else {
                self.send(message: .alert(title: "ERROR", message: "EMR line not found by barcode: \(self.barcode)"))
                return
            }

            self.next(step: RentalStep.EMRLine(EMRLineParameters(emrLine: EMRItemViewModel(line))))
        } => disposeBag
    }
}
