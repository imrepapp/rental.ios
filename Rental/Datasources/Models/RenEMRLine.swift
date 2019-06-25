// This is a generated class, generated by the DataClassGenerator.
// To read more about the tool:https://xapt.sharepoint.com/:w:/s/MobileTeam/EVd0056mkIxApxs4_wo3f2IB6wWS4ydQ7TvbjOB-oez1NQ?e=EEWfDO

import NMDEF_Sync
import NMDEF_Base
import RealmSwift
import RxCocoa

public final class RenEMRLine: MOB_RenEMRLine, EMRFormItem {
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

    public var customer: String {
        get {
            if let e = emr {
                return direction == "Inbound" ? e.fromRelationName : e.toRelationName
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

    var lineListType: EMRType {
        if emrType == 1 {
            return .Shipping
        } else if emrType == 2 {
            return .Receiving
        }

        return .Other
    }

    var uploadedPhotos: [MOB_RenEMRLinePhoto] {
        get {
            var realm = try! Realm()
            return realm.objects(MOB_RenEMRLinePhoto.self)
                    .filter(NSPredicate(format: "lineId = %@", argumentArray: [super.id]))
                    .map {
                        $0
                    }
        }
    }


    func fromViewModel(viewModel: EMRFormItemViewModelGeneric<RenEMRLine>) -> Self {
        self.equipmentId = viewModel.eqId.val!
        self.machineTypeId = viewModel.modelId.val!
        self.inventSerialId = viewModel.serialNumber.val!
        self.barCode = viewModel.barcode.val!
        self.toInventLocation = viewModel.toInventLocation.val!
        self.towmsLocation = viewModel.toWMSLocation.val!
        self.note = viewModel.notes.val!
        self.quantity = Double(viewModel.qty.val ?? "0") ?? 0
        self.fuelLevel = Double(viewModel.fuelLevel.val ?? "0") ?? 0
        self.smu = Double(viewModel.SMU.val ?? "0") ?? 0
        self.secondarySMU = Double(viewModel.secondarySMU.val ?? "0") ?? 0

        return self
    }
}