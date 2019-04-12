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
    func createEMROrReceive(_ eqBarcode: MOB_EquipmentBarCode)
}

extension BarcodeScannerViewModel where Self: BaseViewModel {
    func barcodeDidScanned(_ bc: String) {
        self.barcode = bc
        self.shouldProcessBarcode = true
    }

    func createEMROrReceive(_ eqBarcode: MOB_EquipmentBarCode) {
        let allowCreateEMR = true
        var message = ""
        var formType = EMRFormType.receiving

        // if the "Allow mobile to create EMR" checkbox is checked, and the equipment is not on a rental contract
        // create receiving record
        if allowCreateEMR && eqBarcode.rentalId.isEmpty {
            message = String(format: "%@ is not on EMR. Would you like to create receiving record?", eqBarcode.id)
            formType = .receiving
        }
        // if the "Allow mobile to create EMR" is checked
        else if allowCreateEMR && !eqBarcode.rentalId.isEmpty {
            message = String(format: "%@ is not on EMR. Would you like to create inbound EMR?", eqBarcode.id)
            formType = .emr
        }
        // if the "Allow mobile to create EMR" checkbox is not checked
        // create receiving record
        else {
            message = String(format: "%@ is not on EMR. Would you like to create receiving record?", eqBarcode.id)
            formType = .receiving
        }

        self.send(message: .alert(config: AlertConfig(
                title: "",
                message: message,
                actions: [
                    UIAlertAction(title: "Yes", style: .default, handler: { alert in
                        self.next(step: RentalStep.EMRCreateForm(EMRFormParameters(formType: formType, eqBarcode: eqBarcode)))
                    }),
                    UIAlertAction(title: "No", style: .cancel, handler: nil)
                ])))
    }
}
