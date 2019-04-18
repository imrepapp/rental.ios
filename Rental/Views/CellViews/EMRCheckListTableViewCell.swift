//
// Created by Attila AMBRUS on 2019-04-15.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NMDEF_Base

class EMRCheckListTableViewCell: UITableViewCell, BindableView {
    typealias Model = EMRCheckListItemViewModel
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var checkedSwitch: UISwitch!
    
    func bind(_ model: EMRCheckListItemViewModel) {
        self.checkedSwitch.rx.value <-> model.checked => self.disposeBag
        model.desc --> self.descLabel.rx.text => self.disposeBag
    }
}
