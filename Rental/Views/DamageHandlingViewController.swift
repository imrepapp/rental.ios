//
// Created by Róbert PAPP on 2019-04-05.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import UIKit
import NMDEF_Base
import RxSwift
import RxCocoa

class DamageHandlingViewController:
        BaseViewController<DamageHandlingViewModel>, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var itemId: UILabel!
    @IBOutlet weak var emrId: UILabel!
    @IBOutlet weak var damageCodesPickerView: UIPickerView!

    @IBOutlet weak var addDamageButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!

    override func initialize() {
        rx.viewCouldBind += { _ in

            self.addDamageButton.rx.tap --> self.viewModel.addDamageCommand => self.disposeBag
            self.addPhotoButton.rx.tap --> self.viewModel.addPhotoCommand => self.disposeBag
            self.viewModel.emrLine.eqId --> self.itemId.rx.text => self.disposeBag
            self.viewModel.emrLine.emrId --> self.emrId.rx.text => self.disposeBag
            self.viewModel.viewController = self

            self.damageCodesPickerView.delegate = self
            self.damageCodesPickerView.dataSource = self

        } => disposeBag
    }

    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.damageCodesDataSource.val[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.damageCodesDataSource.val.count
    }
}
