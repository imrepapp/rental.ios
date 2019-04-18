import NMDEF_Sync

public class MOB_RenInspectionChecklistHistory: BaseEntity {
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var updatedAt: Date = Date(timeIntervalSince1970: 1)
    @objc dynamic var name: String = ""
    @objc dynamic var userId: String = ""
    @objc dynamic var equipmentId: String = ""
    @objc dynamic var emrId: String = ""
    @objc dynamic var itemDescription: String = ""

    @objc dynamic var statusAction: String = "Schedule"
    @objc dynamic var checked: String = "No"
}
		