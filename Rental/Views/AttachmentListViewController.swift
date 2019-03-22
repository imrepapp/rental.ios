//
//  AttachmentListViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import NMDEF_Base
import RxSwift
import RxCocoa

class AttachmentListViewController: BaseViewController<AttachmentListViewModel> {
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderView: UIView!
    
    override func initialize() {
        rx.viewCouldBind += { _ in
            self.viewModel.title --> self.navBar.topItem!.rx.title => self.disposeBag

            self.viewModel.attachmentItems.bind(to: self.tableView.rx.items(cellIdentifier: "AttachmentCell", cellType: AttachmentTableViewCell.self)) {
                (_, item, cell) in
                item --> cell
            } => self.disposeBag

            self.tableView.rx.modelSelected(AttachmentItemViewModel.self) += { model in
                self.viewModel.selectAttachmentCommand.accept(model)
                self.tableView.deselectSelectedRow()
            } => self.disposeBag

            self.cancelButtonItem.rx.tap --> self.viewModel.cancelCommand => self.disposeBag
            self.viewModel.isLoading.map {
                !$0
            }.bind(to: self.loaderView.rx.isHidden) => self.disposeBag
        } => disposeBag
    }
}
