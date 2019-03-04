import NMDEF_Sync
import RealmSwift

public class RenEMRLine: MOB_RenEMRLine {
    public var emr: RenEMRTable? {
        get {
            return BaseDataProvider.DAO(RenEMRTableDAO.self).lookUp(id: emrId)
        }
    }

    public var addressLabel: String {
        return direction == "Inbound" ? "From" : "To"
    }

    public var address: String {
        get {
            if let e = emr {
                return direction == "Inbound" ? e.fromAddressDisplay : e.toAddressDisplay
            }

            return "-"
        }
    }

    public var listItemId: String {
        return lineType == "Equipment" ? equipmentId : itemId
    }

    public var itemType: String {
        get {
            if (lineType == "Equipment" && isAttachment == "Yes") {
                return "Attachment"
            }

            if (lineType == "Equipment" && isAttachment == "No") {
                return "Equipment"
            }

            if (lineType == "Regular" && renBulkItemAvail == "Yes") {
                return "Bulk"
            }

            return "Item"
        }
    }
}