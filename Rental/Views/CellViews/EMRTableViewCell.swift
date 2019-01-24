//
//  EMRTableViewCell.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NAXTMobileDataEntityFramework

class EMRTableViewCell: UITableViewCell, BindableView {
    typealias Model = EMRItemViewModel

    @IBOutlet weak var eqIdLabel: UILabel!
    @IBOutlet weak var emrIdLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromCellLabel: UILabel!

    func bind(_ model: EMRItemViewModel) {
        model.eqId --> eqIdLabel.rx.text => disposeBag
        model.emrId --> emrIdLabel.rx.text => disposeBag
        model.type --> typeLabel.rx.text => disposeBag
        model.direction --> directionLabel.rx.text => disposeBag
        model.model --> modelLabel.rx.text => disposeBag
        model.schedule --> scheduleDateLabel.rx.text => disposeBag
        model.from --> fromLabel.rx.text => disposeBag
        model.fromLabel --> fromCellLabel.rx.text => disposeBag
    }
}
