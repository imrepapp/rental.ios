//
// Created by Attila AMBRUS on 2019-02-28.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import RxSwift

protocol BarcodeScan {
    func check(barcode: String, emrId: String) throws -> RenEMRLine
    func setAsScanned(_ line: RenEMRLine) -> Bool
    func checkAndScan(barcode: String, emrId: String) -> Observable<RenEMRLine>
    func handleNotFound(barcode: String)
}

enum BarcodeScanError: Error {
    case Error(msg: String)
    case NotFound
    case Unknown

    case EqBarcode(data: MOB_EquipmentBarCode)
}

