//
// Created by Attila AMBRUS on 2019-04-15.
// Copyright (c) 2019 XAPT Kft. All rights reserved.
//

import Foundation
import NMDEF_Base
import RxCocoa
import RxSwift

class EMRCheckListViewController: BaseViewController<EMRCheckListViewModel> {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var equipmentIdLabel: UILabel!
    @IBOutlet weak var emrIdLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var loaderView: UIView!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func initialize() {
        rx.viewCouldBind += { _ in
            self.viewModel.items.bind(to: self.tableView.rx.items(cellIdentifier: "EMRCheckListCell", cellType: EMRCheckListTableViewCell.self)) {
                (_, item, cell) in
                item --> cell
            } => self.disposeBag

            self.viewModel.parameters.map { $0.line.emrId }.bind(to: self.emrIdLabel.rx.text).disposed(by: self.disposeBag)
            self.viewModel.parameters.map { $0.line.equipmentId }.bind(to: self.equipmentIdLabel.rx.text).disposed(by: self.disposeBag)
            self.viewModel.isLoading.map { !$0 }.bind(to: self.loaderView.rx.isHidden).disposed(by: self.disposeBag)

            self.cancelButton.rx.tap --> self.viewModel.cancelCommand => self.disposeBag
            self.saveButton.rx.tap --> self.viewModel.saveCommand => self.disposeBag
        }
    }
}
