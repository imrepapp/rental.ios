//
// Created by Róbert PAPP on 2019-04-05.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import UIKit
import NMDEF_Base
import TextImageButton
import ActionSheetPicker_3_0
import RxSwift
import RxCocoa

class DamageHandlingViewController:
        BaseViewController<DamageHandlingViewModel>, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate  {

    @IBOutlet weak var itemId: UILabel!
    @IBOutlet weak var emrId: UILabel!
    @IBOutlet weak var damageCodesPickerView: UIPickerView!
    @IBOutlet weak var damageCodeButton: TextImageButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addDamageButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!

    override func initialize() {

        rx.viewWillAppear += { _ in
            self.damageCodeButton.imagePosition = .right
        } => disposeBag

        rx.viewCouldBind += { _ in

            self.addDamageButton.rx.tap --> self.viewModel.addDamageCommand => self.disposeBag
            self.addPhotoButton.rx.tap --> self.viewModel.addPhotoCommand => self.disposeBag
            self.viewModel.emrLine.eqId --> self.itemId.rx.text => self.disposeBag
            self.viewModel.emrLine.emrId --> self.emrId.rx.text => self.disposeBag
            self.viewModel.damageDescription <-> self.descriptionTextView.rx.text => self.disposeBag

            self.viewModel.damageCode --> self.damageCodeButton.rx.title() => self.disposeBag
            self.damageCodeButton.rx.tap += {
                ActionSheetStringPicker.show(
                        withTitle: "Damage Codes",
                        rows: self.viewModel.damageCodesDataSource.val.map { $0 },
                        initialSelection: 0,
                        doneBlock: { picker, index, value in
                            self.viewModel.damageCode.accept(self.viewModel.damageCodesDataSource.val[index])
                        },
                        cancel: { _ in
                        },
                        origin: self.damageCodeButton
                )
            } => self.disposeBag

        } => disposeBag
    }
}
