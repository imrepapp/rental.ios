//
// Created by Attila AMBRUS on 2019-02-28.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Sync
import RxSwift
import RealmSwift

class BarcodeScanService: BarcodeScan {
    func check(barcode: String, emrId: String = "") throws -> RenEMRLine {
        let warehouses = BaseDataProvider.DAO(RenWorkerWarehouseDAO.self).items.map {
            $0.inventLocationId
        }

        var filterStr = "barCode = %@ and isShipped = No and isReceived = No and emrStatus != %@ and emrType IN {1,2}"
        filterStr += " and (toInventLocation IN %@ or fromInventLocation IN %@ or (toInventLocation = '' and fromInventLocation = ''))"

        let foundLine = BaseDataProvider.DAO(RenEMRLineDAO.self).lookUp(predicate: NSPredicate(format: filterStr, argumentArray: [
            barcode,
            "Received",
            warehouses,
            warehouses
        ]))

        if foundLine == nil {
            throw BarcodeScanError.Error(msg: "This barcode is currently not assigned to an equipment/item!")
        }

        if foundLine?.emr == nil {
            throw BarcodeScanError.Error(msg: "The searched item is currently not on an EMR!")
        }

        if !emrId.isEmpty && foundLine?.emr?.id != emrId {
            throw BarcodeScanError.Error(msg: "The searched item is not on this EMR!")
        }

        return foundLine!
    }

    func setAsScanned(_ line: RenEMRLine) -> Bool {
        do {
            line.isScanned = true
            try BaseDataProvider.instance.store?.upsertItems([line.toDict()], table: BaseDataProvider.DAO(RenEMRLineDAO.self).datasource.name)
            return true
        } catch {
            print("BarcodeScanner: \(error)")
        }

        return false
    }

    func checkAndScan(barcode: String, emrId: String) -> Observable<RenEMRLine> {
        return Observable<RenEMRLine>.create { observer in
            do {
                let line = try self.check(barcode: barcode, emrId: emrId)

                if self.setAsScanned(line) {
                    observer.onNext(line)
                    observer.onCompleted()
                } else {
                    observer.onError(BarcodeScanError.Error(msg: "Scan was unsuccessful."))
                }
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
}
