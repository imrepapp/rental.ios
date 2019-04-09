//
// Created by Róbert PAPP on 2019-04-05.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base
import RxCocoa

class DamageHandlingViewModel: BaseViewModel {

    let addDamageCommand = PublishRelay<Void>()


    required public init() {
        super.init()
        title.val = "Damage handling"

        addDamageCommand += { _ in
            print("Add damage button tapped")
        } => disposeBag

    }
}
