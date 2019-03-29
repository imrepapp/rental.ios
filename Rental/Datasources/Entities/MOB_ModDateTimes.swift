import NMDEF_Sync

public class MOB_ModDateTimes: BaseEntity {
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var updatedAt: Date = Date(timeIntervalSince1970: 1)
    @objc dynamic var refTableId: Int = 0


    public override class func ignoredProperties() -> [String] {
        return ["version", "createdAt"]
    }
}