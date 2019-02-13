//
//  SettingsViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NMDEF_Base

class SettingsViewController: BaseViewController<SettingsViewModel> {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var environmentLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var lastSyncLabel: UILabel!
    @IBOutlet weak var connectionStatusLabel: UILabel!

    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!

    override func initialize() {
        rx.viewCouldBind += { _ in
            self.viewModel.emailAddress --> self.emailLabel.rx.text => self.disposeBag
            self.viewModel.environmentName --> self.environmentLabel.rx.text => self.disposeBag
            self.viewModel.appVersion --> self.appVersionLabel.rx.text => self.disposeBag
            self.viewModel.syncDate --> self.lastSyncLabel.rx.text => self.disposeBag
            self.viewModel.connectionStatus --> self.connectionStatusLabel.rx.text => self.disposeBag

            self.syncButton.rx.tap --> self.viewModel.synchronizeCommand => self.disposeBag
            self.logoutButton.rx.tap --> self.viewModel.logoutCommand => self.disposeBag

        } => disposeBag
    }
}
