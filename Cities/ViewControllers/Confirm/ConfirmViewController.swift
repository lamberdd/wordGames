//
//  ConfirmViewController.swift
//  Cities
//
//  Created by Владислав Казмирчук on 17.03.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class ConfirmViewController: BlackoutViewController {
    
    private var onCancelCallback: (()->Void)? = nil
    private var onConfirmCallback: (()->Void)? = nil
    private var titileText: String = ""
    private var descriptionText: String = ""
    private var confirmText: String?
    private var cancelText: String?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction private func onCancelClick(_ sender: UIButton) {
        onCancelCallback?()
    }
    @IBAction private func onConfirmClick(_ sender: UIButton) {
        onConfirmCallback?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titileText
        descriptionLabel.text = descriptionText
        if let confirmText = confirmText {
            confirmButton.setTitle(confirmText, for: .normal)
        }
        if let cancelText = cancelText {
            cancelButton.setTitle(cancelText, for: .normal  )
        }
    }
    
    //MARK: - Public
    func onCancel(_ callback: @escaping ()->Void) {
        self.onCancelCallback = callback
    }
    func onConfirm(_ callback: @escaping ()->Void) {
        self.onConfirmCallback = callback
    }
    
    func set(title: String, description: String) {
        if titleLabel != nil || descriptionLabel != nil {
            titleLabel.text = title
            descriptionLabel.text = description
        } else {
            titileText = title
            descriptionText = description
        }
    }
    
    func set(confirmTitle: String?, cancelTitle: String?) {
        confirmText = confirmTitle
        cancelText = cancelTitle
        if confirmButton != nil, let confirmTitle = confirmTitle {
            confirmButton.setTitle(confirmTitle, for: .normal)
        }
        if  cancelButton != nil, let cancelTitle = cancelTitle {
            cancelButton.setTitle(cancelTitle, for: .normal)
        }
    }
    
    
}
