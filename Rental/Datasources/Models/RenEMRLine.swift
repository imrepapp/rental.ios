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
        return lineType == 1 ? equipmentId : itemId
    }
}
		