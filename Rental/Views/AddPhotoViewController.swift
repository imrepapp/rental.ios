//
//  AddPhotoViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NAXT_Mobile_Data_Entity_Framework
import RxSwift
import RxCocoa

class AddPhotoViewController: BaseViewController<AddPhotoViewModel> {
    @IBOutlet weak var eqIdLabel: UILabel!
    @IBOutlet weak var emrIdLabel: UILabel!
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func initialize() {
        rx.viewCouldBind += { _ in
            self.viewModel.title --> self.navBar.topItem!.rx.title => self.disposeBag
            self.viewModel.eqId --> self.eqIdLabel.rx.text => self.disposeBag
            self.viewModel.emrId --> self.emrIdLabel.rx.text => self.disposeBag
            self.cancelButtonItem.rx.tap --> self.viewModel.cancelCommand => self.disposeBag
            self.saveButtonItem.rx.tap --> self.viewModel.saveCommand => self.disposeBag
        } => disposeBag
    }
}
