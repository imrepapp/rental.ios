import NMDEF_Sync

public class MOB_RenEMRArrival: BaseEntity {
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var wmsLocationId: String = ""
    @objc dynamic var smu: Double = 0.0
    @objc dynamic var model: String = ""
    @objc dynamic var secondarySMU: Double = 0.0
    @objc dynamic var equipmentId: String = ""
    @objc dynamic var inventLocationId: String = ""
    @objc dynamic var notes: String = ""
    @objc dynamic var fuelLevel: Double = 0.0
    @objc dynamic var itemId: String = ""
    @objc dynamic var qty: Double = 0.0

    @objc dynamic var operation: String = "CreateReceivingEMR"
}
		