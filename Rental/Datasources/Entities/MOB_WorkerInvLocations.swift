import NMDEF_Sync

public class MOB_WorkerInvLocations: BaseEntity {
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var updatedAt: Date = Date(timeIntervalSince1970: 1)
    @objc dynamic var inventLocationId: String = ""
    @objc dynamic var responsibleWorker: Int64 = 0
    @objc dynamic var wmsLocationId: String = ""

    @objc dynamic var defReceiptWMSLoc: String = "No"
}
		