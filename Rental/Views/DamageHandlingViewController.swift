//
// Created by Róbert PAPP on 2019-04-05.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import NMDEF_Base

class DamageHandlingViewController: BaseViewController<ConfigListViewModel> {

    @IBOutlet weak var itemId: UILabel!
    @IBOutlet weak var emrId: UILabel!
    @IBOutlet weak var damageCodes: UIPickerView!

    override func initialize() {
        super.initialize()
    }

    @IBAction func onTapAddDamageButton(_ sender: UIButton) {
    }

    @IBAction func onTapAddPhotoButton(_ sender: UIButton) {
    }
}
