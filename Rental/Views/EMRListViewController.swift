//
//  EMRListViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxViewController
import NMDEF_Base
import BarcodeScanner

class EMRListViewController: BaseViewController<EMRListViewModel>, BarcodeScannerView {
    //MARK: IBOutlet-
    @IBOutlet weak var menuButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var enterBarcodeButton: UIButton!
    @IBOutlet weak var scanBarcodeButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!


    required init(coder: NSCoder) {
        super.init(coder: coder)

        rx.viewDidLoad += { _ in
            //self.viewModel.isLoading.val = true
        }
    }

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

            self.viewModel.title --> self.actionButton.rx.title() => self.disposeBag
            self.viewModel.isLoading --> self.buttonStackView.rx.isHidden => self.disposeBag
            self.viewModel.isLoading --> self.tableView.rx.isHidden => self.disposeBag
            self.viewModel.isLoading.map {
                !$0
            }.bind(to: self.loaderView.rx.isHidden) => self.disposeBag
            self.viewModel.isShippingButtonHidden --> self.actionView.rx.isHidden => self.disposeBag
            self.viewModel.isShippingButtonEnabled.bind(to: self.actionButton.rx.isEnabled).disposed(by: self.disposeBag)

            self.menuButtonItem.rx.tap --> self.viewModel.menuCommand => self.disposeBag

            self.actionButton.rx.tap --> self.viewModel.actionCommand => self.disposeBag
            self.enterBarcodeButton.rx.tap --> self.viewModel.enterBarcodeCommand => self.disposeBag

            self.searchText.rx.text <-> self.viewModel.searchText => self.disposeBag


        } => disposeBag


    }

    @IBAction func onTapScanBarcode(_ sender: UIButton) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}
