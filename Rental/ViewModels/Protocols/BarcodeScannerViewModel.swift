//
// Created by Attila AMBRUS on 2019-03-11.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Base

protocol BarcodeScannerViewModel: class {
    var barcode: String? { get set }
    var shouldProcessBarcode: Bool { get set }
    func barcodeDidScanned(_ bc: String)
}

extension BarcodeScannerViewModel where Self: BaseViewModel {
    func barcodeDidScanned(_ bc: String) {
        self.barcode = bc
        self.shouldProcessBarcode = true
    }
}
