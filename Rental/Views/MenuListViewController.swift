//
//  MenuListViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NMDEF_Base
import RxSwift
import RxCocoa

class MenuListViewController: BaseViewController<MenuListViewModel> {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsButtonItem: UIBarButtonItem!
    @IBOutlet weak var loaderView: UIView!

    override func initialize() {
        rx.viewDidLoad += { _ in
            self.navigationItem.hidesBackButton = true
        } => self.disposeBag

        rx.viewCouldBind += { _ in
            self.settingsButtonItem.rx.tap --> self.viewModel.showSettingsCommand => self.disposeBag
            self.viewModel.isLoading.map {
                !$0
            }.bind(to: self.loaderView.rx.isHidden) => self.disposeBag

            self.viewModel.menuItems.bind(to: self.tableView.rx.items(cellIdentifier: "MenuCell", cellType: MenuTableViewCell.self)) {
                (_, item, cell) in
                item --> cell
            } => self.disposeBag

            self.tableView.rx.modelSelected(MenuItemViewModel.self) += { model in
                self.viewModel.selectMenuCommand.accept(model)
                self.tableView.deselectSelectedRow()
            } => self.disposeBag
        } => self.disposeBag
    }
}
