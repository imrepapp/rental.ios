//
//  EMRLineViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import BarcodeScanner
import NMDEF_Base
import RxSwift
import RxCocoa

class EMRLineViewController: BaseViewController<EMRLineViewModel>, BarcodeScannerView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var eqIdLabel: UILabel!
    @IBOutlet weak var eqIdTitleLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var modelTitleLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var serialTitleLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var barcodeTitleLabel: UILabel!
    
    @IBOutlet weak var agreementRelationTypeLabel: UILabel!
    @IBOutlet weak var agreementRelationLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var fromMapButton: UIButton!
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var toMapButton: UIButton!
    
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var deliveryNotesTextField: UITextView!
    @IBOutlet weak var notesTextField: UITextView!
    
    @IBOutlet weak var fuelTextField: UITextField!
    @IBOutlet weak var smuTextField: UITextField!
    @IBOutlet weak var secSMUTextField: UITextField!
    @IBOutlet weak var editableView: UIView!

    @IBOutlet weak var replaceAttachmentButton: UIButton!
    @IBOutlet weak var replaceAttachmentView: UIView!
    @IBOutlet weak var startInspectionButton: UIButton!
    @IBOutlet weak var startCheckListButton: UIButton!
    @IBOutlet weak var startInspectionView: UIView!
    @IBOutlet weak var startCheckListView: UIView!
    @IBOutlet weak var scanBarcodeButton: UIButton!
    @IBOutlet weak var enterBarcodeButton: UIButton!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var emrListButton: UIButton!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var loaderView: UIView!
    
    override func initialize() {
        rx.viewCouldBind += { _ in

            if (self.viewModel.emrLine.isHiddenModel.val) {
                self.viewModel.emrLine.itemId --> self.eqIdLabel.rx.text => self.disposeBag
            } else {
                self.viewModel.emrLine.eqId --> self.eqIdLabel.rx.text => self.disposeBag
            }

            self.viewModel.emrLine.type --> self.typeLabel.rx.text => self.disposeBag
            self.viewModel.emrLine.direction --> self.directionLabel.rx.text => self.disposeBag
            self.viewModel.emrLine.status --> self.statusLabel.rx.text => self.disposeBag
            self.viewModel.emrLine.model --> self.modelLabel.rx.text => self.disposeBag
            self.viewModel.emrLine.serial --> self.serialLabel.rx.text => self.disposeBag
            self.viewModel.emrLine.barcode --> self.barcodeLabel.rx.text => self.disposeBag

            self.viewModel.emrLine.agreementType --> self.agreementRelationTypeLabel.rx.text => self.disposeBag
            self.viewModel.emrLine.agreement --> self.agreementRelationLabel.rx.text => self.disposeBag

            self.viewModel.emrLine.from --> self.fromLabel.rx.text => self.disposeBag
            self.viewModel.emrLine.fromAddress --> self.fromAddressLabel.rx.text => self.disposeBag

            self.viewModel.emrLine.to --> self.toLabel.rx.text => self.disposeBag
            self.viewModel.emrLine.toAddress --> self.toAddressLabel.rx.text => self.disposeBag

            self.viewModel.emrLine.contact --> self.contactLabel.rx.text => self.disposeBag
            self.viewModel.emrLine.phone --> self.phoneLabel.rx.text => self.disposeBag

            self.viewModel.emrLine.deliveryNotes <-> self.deliveryNotesTextField.rx.text => self.disposeBag
            self.viewModel.emrLine.notes <-> self.notesTextField.rx.text => self.disposeBag

            self.viewModel.emrLine.fuel <-> self.fuelTextField.rx.text => self.disposeBag
            self.viewModel.emrLine.smu <-> self.smuTextField.rx.text => self.disposeBag
            self.viewModel.emrLine.secSMU <-> self.secSMUTextField.rx.text => self.disposeBag
            self.viewModel.emrLine.quantity <-> self.quantityTextField.rx.text => self.disposeBag

            //Commands
            self.replaceAttachmentButton.rx.tap --> self.viewModel.replaceAttachmentCommand => self.disposeBag
            self.startInspectionButton.rx.tap --> self.viewModel.startInspectionCommand => self.disposeBag
            self.startCheckListButton.rx.tap --> self.viewModel.startCheckListCommand => self.disposeBag
            self.enterBarcodeButton.rx.tap --> self.viewModel.enterBarcodeCommand => self.disposeBag
            self.saveButton.rx.tap --> self.viewModel.saveCommand => self.disposeBag
            self.fromMapButton.rx.tap --> self.viewModel.fromMapCommand => self.disposeBag
            self.toMapButton.rx.tap --> self.viewModel.toMapCommand => self.disposeBag
            self.emrListButton.rx.tap --> self.viewModel.emrListCommand => self.disposeBag

            //Title
            self.viewModel.emrLine.eqIdTitle --> self.eqIdTitleLabel.rx.text => self.disposeBag
            self.viewModel.emrButtonTitle.bind(to: self.emrListButton.rx.title()).disposed(by: self.disposeBag)
            self.viewModel.photoButtonTitle.bind(to: self.photoButton.rx.title()).disposed(by: self.disposeBag)

            //IsHidden
            self.viewModel.emrLine.isNotReplaceableAttachment --> self.replaceAttachmentView.rx.isHidden => self.disposeBag
            self.viewModel.isHiddenFromAddress --> self.fromMapButton.rx.isHidden => self.disposeBag
            self.viewModel.isHiddenToAddress --> self.toMapButton.rx.isHidden => self.disposeBag
            self.viewModel.isScanViewHidden.bind(to: self.scanView.rx.isHidden).disposed(by: self.disposeBag)
            self.viewModel.isCheckHidden --> self.startCheckListView.rx.isHidden => self.disposeBag
            self.viewModel.isInspectHidden --> self.startInspectionView.rx.isHidden => self.disposeBag
            self.viewModel.isLoading.map { !$0 }.bind(to: self.loaderView.rx.isHidden).disposed(by: self.disposeBag)

            //Bulk item
            self.viewModel.emrLine.isHiddenModel --> self.modelLabel.rx.isHidden => self.disposeBag
            self.viewModel.emrLine.isHiddenModel --> self.modelTitleLabel.rx.isHidden => self.disposeBag
            self.viewModel.emrLine.isHiddenModel --> self.serialLabel.rx.isHidden => self.disposeBag
            self.viewModel.emrLine.isHiddenModel --> self.serialTitleLabel.rx.isHidden => self.disposeBag
            self.viewModel.emrLine.isHiddenModel --> self.barcodeLabel.rx.isHidden => self.disposeBag
            self.viewModel.emrLine.isHiddenModel --> self.barcodeTitleLabel.rx.isHidden => self.disposeBag
            self.viewModel.emrLine.isHiddenModel --> self.editableView.rx.isHidden => self.disposeBag

            //Background
            self.viewModel.startCheckListBgr --> self.startCheckListButton.rx.backgroundColor => self.disposeBag

            //Enable
            self.viewModel.emrLine.quantityIsEditable --> self.quantityTextField.rx.isEnabled => self.disposeBag

            //Delegate
            self.fuelTextField.delegate = self
            self.smuTextField.delegate = self
            self.secSMUTextField.delegate = self

        } => disposeBag
    }
    
    @IBAction func onTapScanBarcode(_ sender: UIButton) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onTapPhotoButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        viewModel.photoCommand.accept(info[.editedImage] as? UIImage)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= 8
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let changedText = currentText.replacingCharacters(in: stringRange, with: text)

        return changedText.count <= 8
    }
}
