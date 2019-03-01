//
// Created by Attila AMBRUS on 2019-02-28.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Sync
import RxSwift

class BarcodeScanService: BarcodeScan {
    func check(barcode: String) throws -> RenEMRLine {
        var warehouses = BaseDataProvider.DAO(RenWorkerWarehouseDAO.self).items.map { $0.inventLocationId }

        var filterStr = "barCode = %@ and isShipped = No and isReceived = No and emrStatus != %@ and emrType IN {1,2}"
        filterStr += " and (toInventLocation IN %@ or fromInventLocation IN %@ or (toInventLocation = '' and fromInventLocation = ''))"

        let foundLine = BaseDataProvider.DAO(RenEMRLineDAO.self).lookUp(predicate: NSPredicate(format: filterStr, argumentArray: [
            barcode,
            "Received",
            warehouses,
            warehouses
        ]))

        if foundLine == nil {
            throw BarcodeScanError.Unassigned
        }

        if foundLine?.emr == nil {
            throw BarcodeScanError.NotOnEMR
        }

        return foundLine!
    }

    func setAsScanned(line: RenEMRLine) -> Observable<Bool> {
        line.isScanned = true
        return BaseDataProvider.DAO(RenEMRLineDAO.self).update(model: line)
    }
}