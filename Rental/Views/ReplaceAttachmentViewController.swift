//
//  ReplaceAttachmentViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import UIKit
import TextImageButton
import ActionSheetPicker_3_0
import NAXTMobileDataEntityFramework
import RxSwift
import RxCocoa

class ReplaceAttachmentViewController: BaseViewController<ReplaceAttachmentViewModel> {
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var emrLabel: UILabel!

    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!

    @IBOutlet weak var selectAttachmentButton: TextImageButton!
    @IBOutlet weak var selectReasonButton: TextImageButton!

    override func initialize() {
        rx.viewWillAppear += { _ in
            self.selectAttachmentButton.imagePosition = .right
            self.selectReasonButton.imagePosition = .right
        } => disposeBag

        rx.viewCouldBind += { _ in
            self.viewModel.title --> self.navBar.topItem!.rx.title => self.disposeBag

            self.viewModel.eqId --> self.attachmentLabel.rx.text => self.disposeBag
            self.viewModel.emrId --> self.emrLabel.rx.text => self.disposeBag

            self.cancelButtonItem.rx.tap --> self.viewModel.cancelCommand => self.disposeBag
            self.saveButtonItem.rx.tap --> self.viewModel.saveCommand => self.disposeBag

            self.viewModel.newEqId --> self.selectAttachmentButton.rx.title() => self.disposeBag
            self.selectAttachmentButton.rx.tap --> self.viewModel.selectAttachmentCommand => self.disposeBag

            self.viewModel.reason --> self.selectReasonButton.rx.title() => self.disposeBag
            self.selectReasonButton.rx.tap += {
                ActionSheetStringPicker.show(
                        withTitle: "Reasons",
                        rows: self.viewModel.reasons.val,
                        initialSelection: 1,
                        doneBlock: { picker, index, value in
                            self.viewModel.reason.accept(value as? String)
                        },
                        cancel: { _ in
                        },
                        origin: self.selectReasonButton
                )
            } => self.disposeBag
        } => disposeBag
    }
}
