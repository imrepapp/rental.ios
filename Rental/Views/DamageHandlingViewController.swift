//
// Created by Róbert PAPP on 2019-04-05.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import UIKit
import NMDEF_Base
import RxSwift
import RxCocoa

class DamageHandlingViewController: BaseViewController<DamageHandlingViewModel>, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemId: UILabel!
    @IBOutlet weak var emrId: UILabel!
    @IBOutlet weak var damageCodes: UIPickerView!

    @IBOutlet weak var addDamageButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!

    override func initialize() {
        rx.viewCouldBind += { _ in
            self.addDamageButton.rx.tap --> self.viewModel.addDamageCommand => self.disposeBag

            self.addPhotoButton.rx.tap --> self.viewModel.addPhotoCommand => self.disposeBag

            self.viewModel.viewController = self

        } => disposeBag
    }
}
