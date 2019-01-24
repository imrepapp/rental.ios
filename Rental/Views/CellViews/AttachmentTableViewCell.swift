//
//  AttachmentTableViewCell.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 14..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NAXTMobileDataEntityFramework
import RxSwift
import RxCocoa
class AttachmentTableViewCell: UITableViewCell, BindableView {
    typealias Model = AttachmentItemViewModel

    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var fleetTypeLabel: UILabel!
    @IBOutlet weak var warehouseLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    func bind(_ attachment: Model) {
        attachment.eqId --> attachmentLabel.rx.text => disposeBag
        attachment.serial --> serialLabel.rx.text => disposeBag
        attachment.model --> modelLabel.rx.text => disposeBag
        attachment.fleetType --> fleetTypeLabel.rx.text => disposeBag
        attachment.warehouse --> warehouseLabel.rx.text => disposeBag
        attachment.location --> locationLabel.rx.text => disposeBag
    }
}
