//
//  EMRLineDataSource.swift
//  PreEMRLite_01
//
//  Created by Krisztián KORPA on 2019. 01. 08..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class EMRLineDataSource: NSObject, UITableViewDataSource {
    
    private var emrList: [EMRLine] = []
    
 
    
    override init() {
        
        let emr1 = EMRLine(_eqId: "EQ008913", _emrId: "EMR003244", _type: "Rental", _direction: "Inbound", _model: "X758", _schedule: "21/11/2018", _from: "Raleigh Blueridge Road - Industrial")
        
        let emr2 = EMRLine(_eqId: "EQ008912", _emrId: "EMR003242", _type: "Rental", _direction: "Outbound", _model: "X758", _schedule: "25/11/2018", _from: "Raleigh Blueridge Road - Industrial")
        
        let emr3 = EMRLine(_eqId: "EQ008914", _emrId: "EMR004489", _type: "Rental", _direction: "Inbound", _model: "X758", _schedule: "21/11/2018", _from: "Raleigh Blueridge Road - Industrial")
        
        let emr4 = EMRLine(_eqId: "EQ008915", _emrId: "EMR006985", _type: "Rental", _direction: "Outbound", _model: "X758", _schedule: "25/11/2018", _from: "Raleigh Blueridge Road - Industrial")
        
        emrList.append(emr1)
        emrList.append(emr2)
        emrList.append(emr3)
        emrList.append(emr4)
    }
    
    func get(index: Int) -> EMRLine {
        return self.emrList[index]
    }
    
    func remove(index: Int) {
        emrList.remove(at: index)
    }
    
    
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMRCell", for: indexPath) as! EMRTableViewCell
        let emrItem = emrList[indexPath.row]
        cell.setupCell(emr: emrItem)
        
        return cell
    }
}
