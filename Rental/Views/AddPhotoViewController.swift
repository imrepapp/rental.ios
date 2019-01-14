//
//  AddPhotoViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class AddPhotoViewController: UIViewController {

    var localEMRLine: EMRLine!
    var type: String = "Shipping"
    
    @IBOutlet weak var eqIDLabel: UILabel!
    @IBOutlet weak var emrIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        
        eqIDLabel.text = localEMRLine.eqId
        emrIdLabel.text = localEMRLine.emrId
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "AddPhoneToEMRLineShow", sender: self)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "AddPhoneToEMRLineShow":
            let emrLineVC = segue.destination as! EMRLineViewController
            
            emrLineVC.type = self.type
            emrLineVC.localEMRLine = self.localEMRLine
            
        default:
            print("Unknown identifier")
        }
    }

}
