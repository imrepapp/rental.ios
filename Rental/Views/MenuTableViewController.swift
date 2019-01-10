//
//  MenuTableViewController.swift
//  PreEMRLite_01
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        tableView.tableFooterView = UIView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "MenuToEMRListShow") {
            
            
            (segue.destination as! EMRListViewController).type = sender as! String
            
            
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print ("Table selected")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                //Shipping
                performSegue(withIdentifier: "MenuToEMRListShow", sender: "Shipping")
                break
                
            case 1:
                //Receiving
                performSegue(withIdentifier: "MenuToEMRListShow", sender: "Receiving")
                break
            default:
                break
            }
        default:
            break
        }
    }
}
