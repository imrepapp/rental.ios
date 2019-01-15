//
//  ReplaceAttachmentViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit
import TextImageButton
import ActionSheetPicker_3_0

class ReplaceAttachmentViewController: UIViewController {

    
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var emrLabel: UILabel!
    
    @IBOutlet weak var selectAttachmentButtonOutlet: TextImageButton!
    @IBOutlet weak var selectReasonButtonOutlet: TextImageButton!
    @IBOutlet weak var selectReasonPickerView: UIPickerView!
    
    var localEMRLine: EMRLine!
    var selectedAttachment: ReplaceAttachment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        updateUI()
    }
    
    func updateUI() {
        
        attachmentLabel.text = localEMRLine.eqId
        emrLabel.text = localEMRLine.emrId
        
        if selectedAttachment != nil {
            selectAttachmentButtonOutlet.setTitle(selectedAttachment?.eqId, for: .normal)
        }
        
        selectAttachmentButtonOutlet.imagePosition = .right
        selectReasonButtonOutlet.imagePosition = .right

    }

    
    @IBAction func selectAttachmentButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ReplaceAttachmentToAttachmentShow", sender: self)
    }
    
    @IBAction func selectReasonButtonPressed(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Reasons", rows: ["One", "Two", "A lot"], initialSelection: 1, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index!)")
            print("picker = \(picker!)")
            
            self.selectReasonButtonOutlet.setTitle(index as? String, for: .normal)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ReplaceAttachmentToAttachmentShow" {

            let attachmentVC = segue.destination as! AttachmentsViewController
            
            attachmentVC.localEMRLine = self.localEMRLine
            
        }
    }
    
}
