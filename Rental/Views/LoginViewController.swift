//
//  LoginViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2018. 12. 13..
//  Copyright © 2018. XAPT Kft. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

import NMDEF_Base

final class LoginViewController: BaseViewController<LoginViewModel> {
    //MARK: IBOutlet-
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var apiTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func initialize() {
        rx.viewWillAppear += { _ in
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        } => disposeBag

        rx.viewWillDisappear += { _ in
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        } => disposeBag

        rx.viewCouldBind += { _ in
            self.emailTextField.rx.text <-> self.viewModel.emailAddress => self.disposeBag
            self.passwordTextField.rx.text <-> self.viewModel.password => self.disposeBag
            self.apiTextField.rx.text <-> self.viewModel.apiUrl => self.disposeBag

            self.loginButton.rx.tap --> self.viewModel.loginCommand => self.disposeBag
            self.viewModel.version --> self.versionLabel.rx.text => self.disposeBag

            self.viewModel.isLoading.map { !$0 }.bind(to: self.loaderView.rx.isHidden).disposed(by: self.disposeBag)
        } => disposeBag
    }
}
