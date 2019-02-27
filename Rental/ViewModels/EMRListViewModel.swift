//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import NMDEF_Sync
import RxSwift
import RxCocoa
import RxFlow
import RealmSwift

struct EMRListParameters: Parameters {
    let type: EMRType
    let filter: Bool
}

class EMRListViewModel: BaseIntervalSyncViewModel<[RenEMRLine]> {
    private var parameters = EMRListParameters(type: EMRType.Receiving, filter: false)

    let emrLines = BehaviorRelay<[EMRItemViewModel]>(value: [EMRItemViewModel]())
    let selectEMRLineCommand = PublishRelay<EMRItemViewModel>()
    let isFiltered = BehaviorRelay<Bool>(value: false)
    let actionCommand = PublishRelay<Void>()
    let enterBarcodeCommand = PublishRelay<Void>()
    let scanBarcodeCommand = PublishRelay<Void>()
    let menuCommand = PublishRelay<Void>()
    override var syncInterval: Double {
        return 3
    }
    override var depencies: [BaseDataAccessObjectProtocol.Type] {
        return [
            RenWorkerWarehouseDAO.self,
            RenEMRTableDAO.self,
            RenEMRLineDAO.self
        ]
    }
    override var datasource: Observable<[RenEMRLine]> {
        var workerWarehouses = BaseDataProvider.DAO(RenWorkerWarehouseDAO.self)
                .filter(predicate: NSPredicate(format: "activeWarehouse = %@", argumentArray: ["Yes"]))
                .map {
                    $0.inventLocationId
                }

        if workerWarehouses.isEmpty {
            return Observable<[RenEMRLine]>.empty()
        }

        var predicateStr = "emrType == %i AND emrStatus != 'Cancelled'"
        var params: [Any] = []
        params.append(parameters.type.rawValue)
        var fromDirection: [String] = []
        var toDirection: [String] = []

        switch parameters.type {
            case .Shipping:
                predicateStr += " && isShipped = 0"
                fromDirection.append(contentsOf: ["Outbound", "Internal"])
                toDirection.append(contentsOf: ["Inbound"])
            case .Receiving:
                predicateStr += " && isReceived = 0"
                fromDirection.append(contentsOf: ["Outbound"])
                toDirection.append(contentsOf: ["Internal", "Inbound"])
            case .Other:
                return Observable<[RenEMRLine]>.empty()
        }

        predicateStr += "  AND ((direction IN %@ AND fromInventLocation IN %@) OR (direction IN %@ AND toInventLocation IN %@) OR direction == 'BetweenJobsites')"

        return BaseDataProvider.DAO(RenEMRLineDAO.self).filterAsync(predicate: NSPredicate(format: predicateStr, argumentArray: [
            parameters.type.rawValue,
            fromDirection,
            workerWarehouses,
            toDirection,
            workerWarehouses]))
    }

    override func instantiate(with params: Parameters) {
        parameters = params as! EMRListParameters

        title.val = "\(parameters.type)"

        //TODO: set is filtered
        isFiltered.val = parameters.filter

        menuCommand += { _ in
            self.next(step: RentalStep.menu)
        } => disposeBag

        selectEMRLineCommand += { emrItem in
            self.next(step: RentalStep.EMRLine(EMRLineParameters(emrLine: emrItem)))
        } => disposeBag

        //Ez helyett emrItem-et átadni


        actionCommand += { _ in
            self.send(message: .alert(title: "\(self.parameters.type)".uppercased(), message: "ACTION!"))
        } => disposeBag

        enterBarcodeCommand += { _ in
            self.next(step: RentalStep.manualScan(ManualScanParameters(type: self.parameters.type)))
        } => disposeBag

        scanBarcodeCommand += { _ in
            self.send(message: .alert(title: "\(self.parameters.type)".uppercased(), message: "SCAN!"))
        } => disposeBag
    }

    override func loadData(data: [RenEMRLine]) {
        emrLines.val = data.map({ EMRItemViewModel($0) })
    }
}

enum EMRType: Int {
    case Other
    case Shipping
    case Receiving
}
