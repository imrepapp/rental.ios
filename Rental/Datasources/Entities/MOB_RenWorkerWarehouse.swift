import NMDEF_Sync

public class MOB_RenWorkerWarehouse: BaseEntity {
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var inventLocationId: String = ""
    @objc dynamic var responsibleWorker: Int64 = 0

    @objc dynamic var activeWarehouse: String = "No"

    public override class func ignoredProperties() -> [String] {
        return ["version", "createdAt"]
    }
}
		