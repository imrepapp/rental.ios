import NMDEF_Sync
import RealmSwift

public class MOB_RenEMRLine: BaseEntity {
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var itemId: String = ""
    @objc dynamic var toInventLocation: String = ""
    @objc dynamic var updatedAt: Date = Date(timeIntervalSince1970: 1)
    @objc dynamic var machineTypeId: String = ""
    @objc dynamic var fuelLevel: Double = 0.0
    @objc dynamic var emrType: Int = 0
    @objc dynamic var equipmentId: String = ""
    @objc dynamic var barCode: String = ""
    @objc dynamic var towmsLocation: String = ""
    @objc dynamic var inventSerialId: String = ""
    @objc dynamic var replacementEqId: String = ""
    @objc dynamic var replacementReason: String = ""
    @objc dynamic var fromInventLocation: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var emrDescription: String = ""
    @objc dynamic var secondarySMU: Double = 0.0
    @objc dynamic var emrId: String = ""
    @objc dynamic var smu: Double = 0.0
    @objc dynamic var quantity: Double = 0.0

    @objc dynamic var emrStatus: String = "Request"
    @objc dynamic var operation: String = "CreateReceivingEMR"
    @objc dynamic var isAttachment: String = "No"
    @objc dynamic var renBulkItemAvail: String = "No"
    @objc dynamic var lineType: String = "Regular"
    @objc dynamic var direction: String = "Outbound"

    @objc dynamic var isShipped: Bool = false
    @objc dynamic var isReceived: Bool = false
    @objc dynamic var isScanned: Bool = false
}
		