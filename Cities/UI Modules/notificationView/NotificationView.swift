//
//  NotificationView.swift
//  Cities
//
//  Created by Влад Казмирчук on 8/28/19.
//  Copyright © 2019 Влад Казмирчук. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    @IBOutlet weak var textNotification: UILabel!
    @IBOutlet weak var imageNotification: UIImageView!
    
    private let cornerRadius: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    private func setupXib() {
        UINib(nibName: "NotificationView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(mainView)
        mainView.frame = bounds
        setupView()
    }
    
    private func setupView() {
        mainView.layer.cornerRadius = cornerRadius
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.clipsToBounds = true
        mainView.layer.shadowColor = UIColor.darkGray.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 4
    }
    
    //MARK: Public methods
    func setText(_ text: String) {
        textNotification.text = text
    }
    
    func setImage(_ image: UIImage) {
        imageNotification.image = image
    }
    
}
