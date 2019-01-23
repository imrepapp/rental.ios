//
//  EMRLineViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NAXT_Mobile_Data_Entity_Framework
import RxSwift
import RxCocoa

class EMRLineViewController: BaseViewController<EMRLineViewModel> {
    @IBOutlet weak var replaceAttachmentView: UIView!

    @IBOutlet weak var eqIdLabel: UILabel!

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!

    //TODO: add missing fields

    @IBOutlet weak var fuelTextField: UITextField!
    @IBOutlet weak var smuTextField: UITextField!
    @IBOutlet weak var secSMUTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!

    @IBOutlet weak var replaceAttachmentButton: UIButton!
    @IBOutlet weak var scanBarcodeButton: UIButton!
    @IBOutlet weak var enterBarcodeButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var emrListButton: UIButton!

    override func initialize() {
        rx.viewCouldBind += { _ in
            self.viewModel.eqId --> self.eqIdLabel.rx.text => self.disposeBag
            self.viewModel.type --> self.typeLabel.rx.text => self.disposeBag
            self.viewModel.direction --> self.directionLabel.rx.text => self.disposeBag
            self.viewModel.status --> self.statusLabel.rx.text => self.disposeBag
            self.viewModel.model --> self.modelLabel.rx.text => self.disposeBag
            self.viewModel.serial --> self.serialLabel.rx.text => self.disposeBag

            //TODO: add missing fields' bindings

            self.viewModel.fuel <-> self.fuelTextField.rx.text => self.disposeBag
            self.viewModel.smu <-> self.smuTextField.rx.text => self.disposeBag
            self.viewModel.secSMU <-> self.secSMUTextField.rx.text => self.disposeBag
            self.viewModel.quantity <-> self.quantityTextField.rx.text => self.disposeBag

            self.viewModel.isNotReplaceableAttachment --> self.replaceAttachmentView.rx.isHidden => self.disposeBag
            self.replaceAttachmentButton.rx.tap --> self.viewModel.replaceAttachmentCommand => self.disposeBag

            self.scanBarcodeButton.rx.tap --> self.viewModel.scanBarcodeCommand => self.disposeBag
            self.enterBarcodeButton.rx.tap --> self.viewModel.enterBarcodeCommand => self.disposeBag
            self.photoButton.rx.tap --> self.viewModel.photoCommand => self.disposeBag

            self.viewModel.emrListTitle --> self.emrListButton.rx.title() => self.disposeBag
            self.emrListButton.rx.tap --> self.viewModel.emrListCommand => self.disposeBag
        } => disposeBag
    }
}
