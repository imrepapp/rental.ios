//
// Created by Papp Imre on 2019-01-20.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NAXT_Mobile_Data_Entity_Framework

class MenuTableViewCell: UITableViewCell, BindableView {
    typealias Model = MenuItemViewModel

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!

    func bind(_ model: MenuItemViewModel) {
        model.name --> nameLabel.rx.text => disposeBag
        model.icon --> iconImage.rx.image => disposeBag
    }
}
