//
//  CustomButton.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 27/11/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation
import UIKit

enum CustomButtonState {
    case enabled
    case disabled
    case loading
}

class CustomButton: UIButton {
    
    var originalButtonText: String?
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
      let animation = createActivityIndicator()
      return animation
    }()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        self.addSubview(activityIndicator)
        layoutButton(.enabled)
        centerActivityIndicatorInButton()
    }
    
    func setupUI() {
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.darkGray, for: .disabled)
    }
    
    func layoutButton(_ state: CustomButtonState) {
        originalButtonText = self.titleLabel?.text
        self.setTitle(self.titleLabel?.text, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.titleLabel?.isHidden = false
        self.isEnabled = true
        self.backgroundColor = ColorName.green.color
        self.layer.cornerRadius = 25
        self.contentEdgeInsets = UIEdgeInsets(top: 26, left: 16, bottom: 26, right: 16)
        
        switch state {
        case .enabled:
            hideLoading()
            return
        case .disabled:
            hideLoading()
            self.isEnabled = false
            self.backgroundColor = .gray
        case .loading:
            showSpinning()
            self.setTitle("", for: .normal)
            self.titleLabel?.isHidden = true
            self.isEnabled = false
        }
    }
    
    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
