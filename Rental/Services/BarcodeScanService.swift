//
// Created by Attila AMBRUS on 2019-02-28.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Sync
import RxSwift
import RealmSwift
import EVReflection

class BarcodeScanService: BarcodeScan {
    func check(barcode: String, emrId: String = "") throws -> RenEMRLine {
        let warehouses = BaseDataProvider.DAO(RenWorkerWarehouseDAO.self).items.map {
            $0.inventLocationId
        }

        //var filterStr = "barCode contains[cd] %@ and isShipped = No and isReceived = No and emrStatus != %@ and emrType IN {0,2}"
        var filterStr = "barCode contains[cd] %@ and isShipped = No and isReceived = No and emrStatus != %@"
        filterStr += " and (toInventLocation IN %@ or fromInventLocation IN %@ or (toInventLocation = '' and fromInventLocation = ''))"

        guard let foundLine = BaseDataProvider.DAO(RenEMRLineDAO.self).lookUp(predicate: NSPredicate(format: filterStr, argumentArray: [
            barcode.lowercased(),
            "Received",
            warehouses,
            warehouses
        ])) else {
            throw BarcodeScanError.NotFound
        }

        if foundLine.emr == nil {
            throw BarcodeScanError.Error(msg: "The searched item is currently not on an EMR!")
        }

        if !emrId.isEmpty && foundLine.emr?.id != emrId {
            throw BarcodeScanError.NotOnThisEMR(line: foundLine)
        }

        return foundLine
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

    func checkAndScan(barcode: String, emrId: String, type: Int) -> Observable<RenEMRLine> {
        return Observable<RenEMRLine>.create { observer in
            do {
                let line = try self.check(barcode: barcode, emrId: emrId)

                if self.setAsScanned(line) {
                    observer.onNext(line)
                    observer.onCompleted()
                } else {
                    observer.onError(BarcodeScanError.Error(msg: "Scan was unsuccessful."))
                }
            } catch BarcodeScanError.NotFound {

                if (type == 2) {
                    BaseDataProvider.instance.client!.table(withName: String(describing: MOB_EquipmentBarCode.self))
                            .read(with: NSPredicate(format: "BarCode = %@", argumentArray: [barcode]), completion: { (result, eqError) in
                                if let e = eqError {
                                    observer.onError(BarcodeScanError.Error(msg: "Scan was unsuccessful."))
                                } else if let items = result?.items, items.count == 0 {
                                    observer.onError(BarcodeScanError.Error(msg: "Cannot find any equipment based on the given barcode."))
                                } else if let items = result?.items, items.count == 1 {
                                    observer.onError(BarcodeScanError.EqBarcode(data: MOB_EquipmentBarCode.init(dictionary: items.first as! NSDictionary)))
                                } else if let items = result?.items, items.count > 1 {

                                }
                            })
                }
                else {
                    observer.onError(BarcodeScanError.Error(msg: "Scan was unsuccessful."))
                }
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func handleNotFound(barcode: String) {

    }

    private func _getEqDataByBarcode(_ barcode: String) {

    }

}
