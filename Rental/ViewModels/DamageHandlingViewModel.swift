//
// Created by Róbert PAPP on 2019-04-05.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxCocoa
import NMDEF_Sync
import RxSwift

class DamageHandlingViewModel: BaseViewModel {

    let addDamageCommand = PublishRelay<Void>()
    let addPhotoCommand = PublishRelay<Void>()
    var viewController: DamageHandlingViewController?
    let damageCodesDataSource = BehaviorRelay<[String]>(value: [String]())

    private var _parameters = EMRLineParameters(emrLine: EMRItemViewModel())
    private var mobDamageHistory = MOB_DamageHistory()

    required public init() {
        super.init()
        title.val = "Damage handling"

        addDamageCommand += { _ in

            self.mobDamageHistory.damageCode = self.damageCodesDataSource.value[0]
            //TODO Mindig az első elemet veszi ki, nem a választottat és a description értéket nem is tölti fel, vagy nincs összemap-elve
            self.mobDamageHistory.damageDescription = "testdesc"

            //TODO AX oldalon generálni kell neki ID-t (Peti)

            BaseDataProvider.DAO(DamageHistoryDAO.self).insertAndPushIfOnline(model: (self.mobDamageHistory as! BaseEntity))
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { item in
                        self.isLoading.val = false
                        self.send(message: .alert(config: AlertConfig(title: "Success", message: "Save was successful.", actions: [
                            UIAlertAction(title: "Ok", style: .default, handler: { alert in self.next(step: RentalStep.dismiss) })
                        ])))
                    }, onError: { error in
                        self.isLoading.val = false
                        self.send(message: .msgBox(title: "Error", message: error.message))
                    })
        } => disposeBag

        addPhotoCommand += { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self.viewController!
            self.viewController!.present(vc, animated: true)
        } => disposeBag
    }

    var emrLine: EMRItemViewModel {
        return _parameters.emrLine
    }

    override func instantiate(with params: Parameters) {
        _parameters = params as! EMRLineParameters

        BaseDataProvider.DAO(DamageCodesDAO.self).items.map {
            damageCodesDataSource.val.append($0.damageCode)
        }

        if emrLine.emrId.val != nil && emrLine.eqId.val != nil {
            mobDamageHistory.emrId = emrLine.emrId.val!
            mobDamageHistory.equipmentId = emrLine.eqId.val!
        }

        //TODO Hol tolti fel a meglevo DamageCode-okat?

        super.instantiate(with: params)
    }
}
