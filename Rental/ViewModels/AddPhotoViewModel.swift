//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NAXT_Mobile_Data_Entity_Framework
import RxSwift
import RxCocoa

class AddPhotoViewModel: BaseViewModel {
    private var parameters = EMRLineParameters(id: "N/A", type: EMRType.Receiving)

    let eqId = BehaviorRelay<String?>(value: nil)
    let emrId = BehaviorRelay<String?>(value: nil)

    let cancelCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()

    override func instantiate(with params: Parameters) {
        parameters = params as! EMRLineParameters
        title.val = "Add Photo: \(parameters.id)"

        //TODO: get EMRLine by parameters.id
        let emrLine = EMRLineModel(eqId: "EQ008913", emrId: "EMR003244", type: "Rental", direction: "Inbound", model: "X758", schedule: "21/11/2018", from: "Raleigh Blueridge Road - Industrial")

        eqId.val = emrLine.eqId
        emrId.val = emrLine.emrId

        cancelCommand += { _ in
            self.next(step:RentalStep.dismiss)
        } => disposeBag
        saveCommand += { _ in
            self.send(message: .alert(title: self.title.val!, message: "SAVE PHOTO TO: \(emrLine.eqId)"))
        } => disposeBag
    }
}
