import NMDEF_Sync

public class RenWorkerWarehouseDAO: NSObject, DataAccessObjectProtocol {
    public typealias Model = RenWorkerWarehouse
    public var priority: Int {
        get {
            return 10
        }
    }

    public override init() {
        super.init()
    }
}
		