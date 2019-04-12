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

    required public init() {
        super.init()
        title.val = "Damage handling"

        addDamageCommand += { _ in
            print("Add damage button tapped")
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
        /*BaseDataProvider.DAO(DamageCodesDAO.self).items.map {
            damageCodes.val.append($0.damageCode)
        }*/

        for index in 1...5 {
            damageCodesDataSource.val.append("a")
        }

        _parameters = params as! EMRLineParameters
    }
}
