//
//  ReplaceAttachmentTableViewCell.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 14..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class ReplaceAttachmentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var fleetTypeLabel: UILabel!
    @IBOutlet weak var warehouseLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(attachment: ReplaceAttachment) {
        attachmentLabel.text = attachment.eqId
        serialLabel.text = attachment.inventSerialId
        modelLabel.text = attachment.machineTypeId
        fleetTypeLabel.text = attachment.fleetType
        warehouseLabel.text = attachment.warehouse
        locationLabel.text = attachment.location
        
    }

}
