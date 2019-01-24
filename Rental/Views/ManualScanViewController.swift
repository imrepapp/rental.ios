//
//  ManualScanViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NAXTMobileDataEntityFramework
import RxCocoa
import RxSwift

class ManualScanViewController: BaseViewController<ManualScanViewModel> {
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!

    override func initialize() {
        rx.viewCouldBind += { _ in
            self.viewModel.title --> self.navBar.topItem!.rx.title => self.disposeBag
            self.cancelButtonItem.rx.tap --> self.viewModel.cancelCommand => self.disposeBag
            self.saveButtonItem.rx.tap --> self.viewModel.saveCommand => self.disposeBag
            self.barcodeTextField.rx.text <-> self.viewModel.barcode => self.disposeBag
        } => disposeBag
    }
}
