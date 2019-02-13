//
// Created by Papp Imre on 2019-01-19.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import RxCocoa
import RxFlow

struct EMRListParameters: Parameters {
    let type: EMRType
    let filter: Bool
}

class EMRListViewModel: BaseViewModel {
    private var parameters = EMRListParameters(type: EMRType.Receiving, filter: false)

    let emrLines = BehaviorRelay<[EMRItemViewModel]>(value: [EMRItemViewModel]())
    let selectEMRLineCommand = PublishRelay<EMRItemViewModel>()
    let isFiltered = BehaviorRelay<Bool>(value: false)
    let actionCommand = PublishRelay<Void>()
    let enterBarcodeCommand = PublishRelay<Void>()
    let scanBarcodeCommand = PublishRelay<Void>()
    let menuCommand = PublishRelay<Void>()

    override func instantiate(with params: Parameters) {
        parameters = params as! EMRListParameters

        title.val = "\(parameters.type)"

        //TODO: get EMRLines
        emrLines.val = [
            EMRItemViewModel(EMRLineModel(eqId: "EQ008913", emrId: "EMR003244", type: "Rental", direction: "Inbound", model: "X758", schedule: "21/11/2018", from: "Raleigh Blueridge Road - Industrial")),
            EMRItemViewModel(EMRLineModel(eqId: "EQ008912", emrId: "EMR003242", type: "Rental", direction: "Outbound", model: "X758", schedule: "25/11/2018", from: "Raleigh Blueridge Road - Industrial")),
            EMRItemViewModel(EMRLineModel(eqId: "EQ008914", emrId: "EMR004489", type: "Rental", direction: "Inbound", model: "X758", schedule: "21/11/2018", from: "Raleigh Blueridge Road - Industrial")),
            EMRItemViewModel(EMRLineModel(eqId: "EQ008915", emrId: "EMR006985", type: "Rental", direction: "Outbound", model: "X758", schedule: "25/11/2018", from: "Raleigh Blueridge Road - Industrial"))
        ]

        //TODO: set is filtered
        isFiltered.val = parameters.filter

        menuCommand += { _ in
            self.next(step:RentalStep.menu)
        } => disposeBag

        selectEMRLineCommand += { emrItem in
            self.next(step:RentalStep.EMRLine(EMRLineParameters(id: emrItem.emrId.val!, type: self.parameters.type)))
        } => disposeBag

        actionCommand += { _ in
            self.send(message: .alert(title: "\(self.parameters.type)".uppercased(), message: "ACTION!"))
        } => disposeBag

        enterBarcodeCommand += { _ in
            self.next(step:RentalStep.manualScan(ManualScanParameters(type: self.parameters.type)))
        } => disposeBag

        scanBarcodeCommand += { _ in
            self.send(message: .alert(title: "\(self.parameters.type)".uppercased(), message: "SCAN!"))
        } => disposeBag

    }
}

enum EMRType {
    case Shipping
    case Receiving
}
