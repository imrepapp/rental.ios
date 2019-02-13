//
//  EMRListViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NMDEF_Base

class EMRListViewController: BaseViewController<EMRListViewModel> {
    //MARK: IBOutlet-
    @IBOutlet weak var menuButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var enterBarcodeButton: UIButton!
    @IBOutlet weak var scanBarcodeButton: UIButton!
    
    override func initialize() {
        rx.viewCouldBind += { _ in
            self.viewModel.emrLines.bind(to: self.tableView.rx.items(cellIdentifier: "EMRCell", cellType: EMRTableViewCell.self)) {
                (_, item, cell) in
                item --> cell
            } => self.disposeBag

            self.tableView.rx.modelSelected(EMRItemViewModel.self) += { model in
                self.viewModel.selectEMRLineCommand.accept(model)
                self.tableView.deselectSelectedRow()
            } => self.disposeBag

            self.viewModel.isFiltered --> self.actionView.rx.isHidden => self.disposeBag
            self.viewModel.title --> self.actionButton.rx.title() => self.disposeBag

            self.menuButtonItem.rx.tap --> self.viewModel.menuCommand => self.disposeBag

            self.actionButton.rx.tap --> self.viewModel.actionCommand => self.disposeBag
            self.enterBarcodeButton.rx.tap --> self.viewModel.enterBarcodeCommand => self.disposeBag
            self.scanBarcodeButton.rx.tap --> self.viewModel.scanBarcodeCommand => self.disposeBag
        } => disposeBag
    }
}
