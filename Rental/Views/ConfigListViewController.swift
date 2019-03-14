//
//  ConfigListViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NMDEF_Base
import RxSwift
import RxCocoa

class ConfigListViewController: BaseViewController<ConfigListViewModel> {
    //MARK: IBOutlet-
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderView: UIView!
    
    override func initialize() {
        rx.viewDidLoad += { _ in
            self.navigationItem.hidesBackButton = true
        } => self.disposeBag

        rx.viewCouldBind += { _ in
            self.viewModel.configItems.bind(to: self.tableView.rx.items(cellIdentifier: "ConfigCell", cellType: ConfigTableViewCell.self)) {
                (_, item, cell) in
                item --> cell
            } => self.disposeBag

            self.tableView.rx.modelSelected(ConfigItemViewModel.self) += { model in
                self.viewModel.selectConfigCommand.accept(model)
                self.tableView.deselectSelectedRow()
            } => self.disposeBag

            self.viewModel.isLoading.map {
                !$0
            }.bind(to: self.loaderView.rx.isHidden) => self.disposeBag
        } => disposeBag
    }
}
