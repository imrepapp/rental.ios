//
//  EMRListViewController.swift
//  PreEMRLite_01
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class EMRListViewController: UIViewController, UITableViewDelegate {
    
    
    var type: String = "Shipping"
    var emrList: EMRLineDataSource?
    var isFilteredEMRList: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shipReceiveView: UIView!
    @IBOutlet weak var shipReceiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emrList = (self.tableView.dataSource as! EMRLineDataSource)
        
        self.title = self.type
        setUIElements()
        tableView.tableFooterView = UIView()
    }
    
    //MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "EMRListToEMRLineShow", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        self.emrList!.remove(index: indexPath.row)
        tableView.reloadData()
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EMRListToEMRLineShow" {
            let indexPath = sender as! IndexPath
            let tempEMRLine = self.emrList!.get(index: indexPath.row)
            let emrLineVC = segue.destination as! EMRLineViewController
            
            emrLineVC.type = self.type
            emrLineVC.localEMRLine = tempEMRLine
            
        }
    }
    
    func setUIElements() {
        
        shipReceiveButton.setTitle(self.type, for: .normal)
       
        if (self.isFilteredEMRList) {
            //show Shipping/Receiving view
            shipReceiveView.isHidden = false
        } else {
            //hide Shipping/Receiving view
            shipReceiveView.isHidden = true
        }
    }
}
