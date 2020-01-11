//
//  ToolBarButtonKeyboard.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 10/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import UIKit

enum TypeButtonKeyboard {
    case enable
    case disable
}

final class ToolBarButtonKeyboard: UIView {
    
    private var confirm: (() -> Void)
    
    fileprivate lazy var view: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    fileprivate lazy var buttonConfirm: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Pagar", for: .normal)
        button.backgroundColor = ColorName.green.color
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(frame: CGRect, confirm: @escaping () -> Void, cancel: @escaping () -> Void) {
        self.confirm = confirm
        super.init(frame: frame)
        setupViews()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        buttonConfirm.layer.cornerRadius = 25.0
        buttonConfirm.addTarget(self, action: #selector(actionConfirm(_:)), for: .touchUpInside)
    }
    
    @objc private func actionConfirm(_ sender: UIButton) {
        self.confirm()
    }
    
    func configButton(type: TypeButtonKeyboard) {
        buttonConfirm.setTitleColor(.white, for: .normal)
        buttonConfirm.backgroundColor = ColorName.green.color

        switch type {
        case .enable:
            buttonConfirm.isUserInteractionEnabled = true
        case .disable:
            buttonConfirm.isUserInteractionEnabled = false
            buttonConfirm.setTitleColor(.darkGray, for: .normal)
            buttonConfirm.backgroundColor = .gray
        }
    }
    
}

extension ToolBarButtonKeyboard: CodeViewProtocol {
    
    func buildViewHierarchy() {
        addSubview(view)
        view.addSubview(buttonConfirm)
    }
    
    func setupConstraints() {
        
        view.anchor(top: self.topAnchor,
                    leading: self.leadingAnchor,
                    bottom: self.bottomAnchor,
                    trailing: self.trailingAnchor,
                    insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        
        buttonConfirm.anchor(leading: self.view.leadingAnchor,
                             trailing: self.view.trailingAnchor,
                             insets: .init(top: 0, left: 30.0, bottom: 0, right: 20.0))
        
        buttonConfirm.anchor(trailing: self.trailingAnchor, insets: .init(top: 0, left: 0, bottom: 0, right: 20.0))
        buttonConfirm.anchor(height: 48.0)
        buttonConfirm.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

    }
}
