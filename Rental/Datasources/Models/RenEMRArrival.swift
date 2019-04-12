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

    func fromViewModel(viewModel: EMRFormItemViewModelGeneric<RenEMRArrival>) -> RenEMRArrival {
        fatalError("fromViewModel(viewModel:) has not been implemented")
    }
}
		