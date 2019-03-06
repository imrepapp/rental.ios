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
import NMDEF_Base

class EMRTableViewCell: UITableViewCell, BindableView {
    typealias Model = EMRItemViewModel

    @IBOutlet weak var eqIdLabel: UILabel!
    @IBOutlet weak var emrIdLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromCellLabel: UILabel!
    @IBOutlet weak var scannedView: UIView!
    
    func bind(_ model: EMRItemViewModel) {
        model.eqId --> eqIdLabel.rx.text => disposeBag
        model.emrId --> emrIdLabel.rx.text => disposeBag
        model.type --> typeLabel.rx.text => disposeBag
        model.direction --> directionLabel.rx.text => disposeBag
        model.model --> modelLabel.rx.text => disposeBag
        model.schedule --> scheduleDateLabel.rx.text => disposeBag
        model.serial --> serialLabel.rx.text => disposeBag
        model.barcode --> barcodeLabel.rx.text => disposeBag

        model.address --> fromLabel.rx.text => disposeBag
        model.addressLabel --> fromCellLabel.rx.text => disposeBag

        model.isHiddenShipped --> scannedView.rx.isHidden => disposeBag
    }
}
