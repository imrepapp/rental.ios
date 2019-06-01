//
// Created by Róbert PAPP on 2019-04-05.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxCocoa
import NMDEF_Sync
import RxSwift

class DamageHandlingViewModel: BaseViewModel {

    //Checklist mintájára


    let addDamageCommand = PublishRelay<Void>()
    let addPhotoCommand = PublishRelay<Void>()
    var viewController: DamageHandlingViewController?
    let damageCodesDataSource = BehaviorRelay<[String]>(value: [String]())

    let damageDescription = BehaviorRelay<String?>(value: nil)

    private var _parameters = EMRLineParameters(emrLine: EMRItemViewModel())
    private var mobDamageHistory = MOB_DamageHistory()

    required public init() {
        super.init()
        title.val = "Damage handling"

        addDamageCommand += { _ in

            //TODO Mindig az első elemet veszi ki (kivenni és helyette replacement reason-nál lévőt használni!)
            self.mobDamageHistory.damageCode = self.damageCodesDataSource.value[0]
            //var selectedValue = pickerViewContent[pickerView.selectedRowInComponent(0)]

            self.mobDamageHistory.damageDescription = self.damageDescription.val!

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

        super.instantiate(with: params)
    }
}
