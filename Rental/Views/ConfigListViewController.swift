//
//  ConfigListViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NAXT_Mobile_Data_Entity_Framework
import RxSwift
import RxCocoa

class ConfigListViewController: BaseViewController<ConfigListViewModel> {
    //MARK: IBOutlet-
    @IBOutlet weak var tableView: UITableView!

    override func initialize() {
        rx.viewCouldBind += { _ in
            self.viewModel.configItems.bind(to: self.tableView.rx.items(cellIdentifier: "ConfigCell", cellType: ConfigTableViewCell.self)) {
                (_, item, cell) in
                item --> cell
            } => self.disposeBag

            self.tableView.rx.modelSelected(ConfigItemViewModel.self) += { model in
                self.viewModel.selectConfigCommand.accept(model)
                self.tableView.deselectSelectedRow()
            } => self.disposeBag
        } => disposeBag
    }
}
