//
//  DamageTableViewCell.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 05. 30..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NMDEF_Base
import RxSwift
import RxCocoa
class DamageTableViewCell: UITableViewCell, BindableView {
    typealias Model = DamageHandlingViewModel
    
    @IBOutlet weak var codeLabel: UILabel!
    
    
    func bind(_ damage: Model) {
        //damage.code --> codeLabel.rx.text => disposeBag
    }
    
}
