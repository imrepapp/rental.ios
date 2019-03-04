//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa

struct ManualScanParameters: Parameters {

}

class ManualScanViewModel: BaseViewModel {
    private var parameters = ManualScanParameters()

    let barcode = BehaviorRelay<String?>(value: "")
    let cancelCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()
    let barcodeDidScanned = PublishRelay<String>()

    required init() {
        super.init()

        title.val = "Manual scan"

        cancelCommand += { _ in
            self.next(step: RentalStep.dismiss)
        } => disposeBag

        saveCommand += { _ in
            if self.barcode.val!.isEmpty {
                self.send(message: .alert(title: "Error", message: "Barcode is mandatory"))
                return
            }

            self.barcodeDidScanned.accept(self.barcode.val!)
            self.next(step: RentalStep.dismiss)
        } => disposeBag
    }
}
