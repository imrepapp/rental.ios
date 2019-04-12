import NMDEF_Sync

public class MOB_RenParameters: BaseEntity {
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var updatedAt: Date = Date(timeIntervalSince1970: 1)

    @objc dynamic var useChecklistForShipping: String = "No"
    @objc dynamic var useChecklistForReceiving: String = "No"
    @objc dynamic var activateInspectionForReceiving: String = "No"
    @objc dynamic var scheduleEMRInMobile: String = "No"
    @objc dynamic var activateInspectionForShipping: String = "No"
    @objc dynamic var createEMRInMobile: String = "No"
}
		