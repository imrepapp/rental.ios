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

class EMRLineViewController: BaseViewController<EMRLineViewModel>, BarcodeScannerView {
    @IBOutlet weak var replaceAttachmentView: UIView!

    @IBOutlet weak var eqIdLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    
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
    @IBOutlet weak var quantityTextField: UITextField!

    @IBOutlet weak var replaceAttachmentButton: UIButton!
    @IBOutlet weak var scanBarcodeButton: UIButton!
    @IBOutlet weak var enterBarcodeButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var emrListButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var loaderView: UIView!
    
    override func initialize() {
        rx.viewCouldBind += { _ in
            self.viewModel.emrLine.eqId --> self.eqIdLabel.rx.text => self.disposeBag

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

            self.viewModel.emrLine.isNotReplaceableAttachment --> self.replaceAttachmentView.rx.isHidden => self.disposeBag

            self.replaceAttachmentButton.rx.tap --> self.viewModel.replaceAttachmentCommand => self.disposeBag
            self.enterBarcodeButton.rx.tap --> self.viewModel.enterBarcodeCommand => self.disposeBag
            self.photoButton.rx.tap --> self.viewModel.photoCommand => self.disposeBag

            self.saveButton.rx.tap --> self.viewModel.saveCommand => self.disposeBag
            self.fromMapButton.rx.tap --> self.viewModel.fromMapCommand => self.disposeBag
            self.viewModel.isHiddenFromAddress --> self.fromMapButton.rx.isHidden => self.disposeBag
            self.toMapButton.rx.tap --> self.viewModel.toMapCommand => self.disposeBag
            self.viewModel.isHiddenToAddress --> self.toMapButton.rx.isHidden => self.disposeBag

            self.viewModel.emrButtonTitle.bind(to: self.emrListButton.rx.title()).disposed(by: self.disposeBag)
            self.emrListButton.rx.tap --> self.viewModel.emrListCommand => self.disposeBag

            self.viewModel.isScanViewHidden.bind(to: self.scanView.rx.isHidden).disposed(by: self.disposeBag)
            self.viewModel.isLoading.map { !$0 }.bind(to: self.loaderView.rx.isHidden).disposed(by: self.disposeBag)
        } => disposeBag
    }
    
    @IBAction func onTapScanBarcode(_ sender: UIButton) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}
