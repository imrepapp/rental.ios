import NMDEF_Sync

public class MOB_RenReplacementReason: BaseEntity {
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var reason: String = ""

    public override class func ignoredProperties() -> [String] {
        return ["version", "createdAt"]
    }
}
		