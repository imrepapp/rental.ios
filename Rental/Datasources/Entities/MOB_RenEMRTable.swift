import NMDEF_Sync
import RealmSwift

public class MOB_RenEMRTable: BaseEntity {
    @objc dynamic var dataAreaId: String = ""
    @objc dynamic var customerContactName: String = ""
    @objc dynamic var updatedAt: Date = Date(timeIntervalSince1970: 1)
    @objc dynamic var customerContactPhone: String = ""
    @objc dynamic var toAddressDisplay: String = ""
    @objc dynamic var fromAddressDisplay: String = ""
    @objc dynamic var toLocation: String = ""
    @objc dynamic var deliveryNote: String = ""
    @objc dynamic var agreementRelation: String = ""
    @objc dynamic var toRelationName: String = ""
    @objc dynamic var fromRelationName: String = ""
    @objc dynamic var deliveryDate: Date = Date(timeIntervalSince1970: 1)

    @objc dynamic var isReceived: String = "No"
    @objc dynamic var isShipped: String = "No"
    @objc dynamic var agreementRelationType: String = "Contract"
    @objc dynamic var direction: String = "Outbound"
    @objc dynamic var emrType: String = "Sales"
}
		