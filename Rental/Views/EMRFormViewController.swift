//
// Created by Attila AMBRUS on 2019-04-05.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import UIKit
import NMDEF_Base
import RxSwift
import RxCocoa
import TextImageButton
import ActionSheetPicker_3_0

final class EMRFormViewController: BaseViewController<EMRFormViewModel> {

    @IBOutlet weak var eqLabel: UILabel!
    @IBOutlet weak var contractIdLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var emrTypeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var relationTypeLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var deliveryNotesTextView: UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var warehouseImageButton: TextImageButton!
    @IBOutlet weak var locationImageButton: TextImageButton!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var smuTextField: UITextField!
    @IBOutlet weak var secondarySMUTextField: UITextField!
    @IBOutlet weak var fuelLevelTextField: UITextField!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var emrTypeView: UIView!
    
    override func initialize() {
        rx.viewCouldBind += {
            self.viewModel.formItem.eqId --> self.eqLabel.rx.text => self.disposeBag
            self.viewModel.formItem.contractId --> self.contractIdLabel.rx.text => self.disposeBag
            self.viewModel.formItem.modelId --> self.modelLabel.rx.text => self.disposeBag
            self.viewModel.formItem.serialNumber --> self.serialNumberLabel.rx.text => self.disposeBag
            self.viewModel.formItem.barcode --> self.barcodeLabel.rx.text => self.disposeBag
            self.viewModel.formItem.emrType --> self.emrTypeLabel.rx.text => self.disposeBag
            self.viewModel.formItem.direction --> self.directionLabel.rx.text => self.disposeBag
            self.viewModel.formItem.fromRelationName --> self.fromLabel.rx.text => self.disposeBag
            self.viewModel.formItem.fromRelationType --> self.relationTypeLabel.rx.text => self.disposeBag
            self.viewModel.title --> self.navigationBar.items!.first!.rx.title => self.disposeBag
            self.viewModel.formItem.toInventLocation --> self.warehouseImageButton.rx.title() => self.disposeBag
            self.viewModel.formItem.toWMSLocation --> self.locationImageButton.rx.title() => self.disposeBag
            self.viewModel.fromViewIsHidden --> self.fromView.rx.isHidden => self.disposeBag
            self.cancelButton.rx.tap --> self.viewModel.cancelCommand => self.disposeBag
            self.saveButton.rx.tap --> self.viewModel.saveCommand => self.disposeBag
            self.viewModel.isEMRTypeViewHidden --> self.emrTypeView.rx.isHidden => self.disposeBag
            self.viewModel.isLoading.map {
                !$0
            }.bind(to: self.loaderView.rx.isHidden).disposed(by: self.disposeBag)

            self.viewModel.formItem.qty <-> self.qtyTextField.rx.text => self.disposeBag
            self.viewModel.formItem.fuelLevel <-> self.fuelLevelTextField.rx.text => self.disposeBag
            self.viewModel.formItem.SMU <-> self.fuelLevelTextField.rx.text => self.disposeBag
            self.viewModel.formItem.secondarySMU <-> self.secondarySMUTextField.rx.text => self.disposeBag
            self.viewModel.formItem.deliveryNotes <-> self.deliveryNotesTextView.rx.text => self.disposeBag
            self.viewModel.formItem.notes <-> self.notesTextView.rx.text => self.disposeBag

            self.warehouseImageButton.rx.tap += {
                ActionSheetStringPicker.show(
                        withTitle: "Warehouse",
                        rows: self.viewModel.inventLocations.val.map {
                            $0.inventLocationId
                        },
                        initialSelection: 0,
                        doneBlock: { picker, index, value in
                            self.viewModel.formItem.toInventLocation.accept(self.viewModel.inventLocations.val[index].inventLocationId)
                        },
                        cancel: { _ in
                        },
                        origin: self.warehouseImageButton
                )
            } => self.disposeBag

            self.locationImageButton.rx.tap += {
                ActionSheetStringPicker.show(
                        withTitle: "Location",
                        rows: self.viewModel.wmsLocations.val.map {
                            $0.wmsLocationId
                        },
                        initialSelection: 0,
                        doneBlock: { picker, index, value in
                            self.viewModel.formItem.toWMSLocation.accept(self.viewModel.wmsLocations.val[index].wmsLocationId)
                        },
                        cancel: { _ in
                        },
                        origin: self.locationImageButton
                )
            } => self.disposeBag
        }
    }
}
