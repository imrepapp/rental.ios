//
// Created by Attila AMBRUS on 2019-03-11.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import BarcodeScanner
import Foundation
import NMDEF_Base

protocol BarcodeScannerView: BarcodeScannerCodeDelegate {
}

extension BarcodeScannerView where Self: UIViewController, Self: HasViewModel, Self.TViewModel: BarcodeScannerViewModel  {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        self.viewModel.barcodeDidScanned(code)
        controller.navigationController?.popViewController(animated: false)
    }
}
