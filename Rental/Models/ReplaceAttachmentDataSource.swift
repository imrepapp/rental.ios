//
//  AttachmentDataSource.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 14..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class ReplaceAttachmentDataSource: NSObject, UITableViewDataSource {
    
    
    private var attachmentList: [ReplaceAttachment] = []
    
    override init() {
        
        let attach1 = ReplaceAttachment(_eqId: "EQ008912", _inventSerialId: "SN003243", _machineTypeId: "X758", _fleetType: "Component", _warehouse: "00", _location: "L10")
        
        let attach2 = ReplaceAttachment(_eqId: "EQ008911", _inventSerialId: "SN003248", _machineTypeId: "X758", _fleetType: "Component", _warehouse: "00", _location: "L10")
        
        let attach3 = ReplaceAttachment(_eqId: "EQ008910", _inventSerialId: "SN004232", _machineTypeId: "X758", _fleetType: "Component", _warehouse: "00", _location: "L10")
        
        attachmentList.append(attach1)
        attachmentList.append(attach2)
        attachmentList.append(attach3)
    }
    
    func get(index: Int) -> ReplaceAttachment {
        return self.attachmentList[index]
    }
    
    func remove(index: Int) {
        attachmentList.remove(at: index)
    }
    
    
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentCell", for: indexPath) as! ReplaceAttachmentTableViewCell
        let attachmentItem = attachmentList[indexPath.row]
        cell.setupCell(attachment: attachmentItem)
        
        return cell
    }
}
