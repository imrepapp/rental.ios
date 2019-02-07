import NMDEF_Sync

public class ModDateTimesDAO: NSObject, DataAccessObjectProtocol {
    public typealias Model = ModDateTimes

    public var priority: Int {
        get {
            return -1000
        }
    }
}
		