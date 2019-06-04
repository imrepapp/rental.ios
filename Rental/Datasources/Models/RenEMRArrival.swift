import NMDEF_Sync

public final class RenEMRArrival: MOB_RenEMRArrival, EMRFormItem {
    var quantity: Double {
        get {
            return super.qty
        }
        set {
            super.qty = newValue
        }
    }

    func fromViewModel(viewModel: EMRFormItemViewModelGeneric<RenEMRArrival>) -> Self {
        self.equipmentId = viewModel.eqId.val!
        self.model = viewModel.modelId.val!
        self.inventLocationId = viewModel.toInventLocation.val!
        self.wmsLocationId = viewModel.toWMSLocation.val!
        self.qty = Double(viewModel.qty.val ?? "0") ?? 0
        self.fuelLevel = Double(viewModel.fuelLevel.val ?? "0") ?? 0
        self.smu = Double(viewModel.SMU.val ?? "0") ?? 0
        self.secondarySMU = Double(viewModel.secondarySMU.val ?? "0") ?? 0

        return self
    }
}
		