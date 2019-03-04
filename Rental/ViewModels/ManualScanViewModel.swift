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
    let barcodeDidScanned = PublishRelay<RenEMRLine>()

    required init() {
        super.init()

        title.val = "Manual scan"

        cancelCommand += { _ in
            self.next(step: RentalStep.dismiss)
        } => disposeBag

        saveCommand += { _ in
            var errorStr = ""

            do {
                var barcodeService = BarcodeScanService()
                var line = try barcodeService.check(barcode: self.barcode.val!)
                self.barcodeDidScanned.accept(line)
                self.next(step: RentalStep.dismiss)
                return
            } catch (BarcodeScanError.Unassigned) {
                errorStr = "This barcode is currently not assigned to an equipment/item!"
            } catch BarcodeScanError.NotOnEMR {
                errorStr = "The searched item is currently not on an EMR!"
            } catch {
                errorStr = "An error has been occurred!"
            }

            self.send(message: .alert(title: "Error", message: errorStr))
        } => disposeBag
    }
}
