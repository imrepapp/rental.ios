//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxSwift
import RxCocoa

class AddPhotoViewModel: BaseViewModel {
    private var parameters = EMRLineParameters(emrLine: EMRItemViewModel())
    var emrLine: EMRItemViewModel {
        return parameters.emrLine
    }

    let cancelCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()

    override func instantiate(with params: Parameters) {
        parameters = params as! EMRLineParameters
        title.val = "Add Photo: \(parameters.emrLine.emrId)"

        cancelCommand += { _ in
            self.next(step:RentalStep.dismiss)
        } => disposeBag
        saveCommand += { _ in
            self.send(message: .alert(title: self.title.val!, message: "SAVE PHOTO TO: \(self.emrLine.eqId.val)"))
        } => disposeBag
    }
}
