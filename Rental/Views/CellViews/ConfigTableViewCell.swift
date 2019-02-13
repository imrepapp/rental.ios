//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NMDEF_Base

class ConfigTableViewCell: UITableViewCell, BindableView {
    typealias Model = ConfigItemViewModel

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!

    func bind(_ model: ConfigItemViewModel) {
        model.name --> nameLabel.rx.text => disposeBag
        model.url --> urlLabel.rx.text => disposeBag
    }
}