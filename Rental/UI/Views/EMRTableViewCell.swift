//
//  EMRTableViewCell.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class EMRTableViewCell: UITableViewCell {

    
    @IBOutlet weak var eqIdLabel: UILabel!
    @IBOutlet weak var emrIdLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var fromCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(emr: EMRLine) {
        
        eqIdLabel.text = emr.eqId
        emrIdLabel.text = emr.emrId
        typeLabel.text = emr.type
        directionLabel.text = emr.direction
        modelLabel.text = emr.model
        scheduleDateLabel.text = emr.schedule
        fromLabel.text = emr.from
        
        if (emr.direction == "Inbound") {
            fromCellLabel.text = "To"
        } else {
            fromCellLabel.text = "From"
        }
        
    }

}
