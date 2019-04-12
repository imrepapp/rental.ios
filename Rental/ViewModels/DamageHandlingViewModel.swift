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
            BaseDataProvider.DAO(DamageCodesDAO.self).updateAndPushIfOnline(model: self.mobDamageHistory)
                    .observeOn(MainScheduler.instance)
                    .map { result in
                        self.isLoading.val = false

                        if result {
                            //Success alert
                            self.send(message: .msgBox(title: self.title.val!, message: "Save was successful."))
                        } else {
                            //Unsuccess alert
                            self.send(message: .msgBox(title: self.title.val!, message: "Save was unsuccessful."))
                        }
                    }
                    .catchError({ error in
                        self.isLoading.val = false
                        let e = error.localizedDescription
                        if e != nil {
                            self.send(message: .msgBox(title: "Error", message: e))
                        } else {
                            self.send(message: .msgBox(title: "Error", message: "An error has been occurred"))
                        }

                        return Observable.empty()
                    }).subscribe() => self.disposeBag

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
            mobDamageHistory.xap_emrTable_EMRId = emrLine.emrId.val!
            mobDamageHistory.xap_EquipmentTable_EquipmentId = emrLine.eqId.val!
        }

        /*for index in 1...5 {
            damageCodesDataSource.val.append("\(index)")
        }*/
        super.instantiate(with: params)
    }
}
