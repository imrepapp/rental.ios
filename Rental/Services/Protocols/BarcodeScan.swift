//
// Created by Attila AMBRUS on 2019-02-28.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import RxSwift

protocol BarcodeScan {
    func check(barcode: String) throws -> RenEMRLine
    func setAsScanned(line: RenEMRLine) -> Observable<Bool>
}

enum BarcodeScanError: Error {
    case Unassigned
    case NotOnEMR
}

