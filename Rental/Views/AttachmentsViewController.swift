//
//  AttachmentsViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class AttachmentsViewController: UIViewController, UITableViewDelegate {

    var localEMRLine: EMRLine!
    var attachmentList: ReplaceAttachmentDataSource?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.attachmentList = (self.tableView.dataSource as! ReplaceAttachmentDataSource)
                
        tableView.tableFooterView = UIView()
    }
    
    
    //MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "AttachmentToReplaceAttachmentShow", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AttachmentToReplaceAttachmentShow" {
            let indexPath = sender as! IndexPath
            let attachment = self.attachmentList!.get(index: indexPath.row)
            
            let replaceVC = segue.destination as! ReplaceAttachmentViewController
            
            replaceVC.localEMRLine = self.localEMRLine
            replaceVC.selectedAttachment = attachment
            
        }
    }


}
