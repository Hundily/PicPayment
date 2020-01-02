//
//  ContactViewCell.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

final class ContactViewCell: UITableViewCell {
    
    // MARK: Outlets
    private lazy var viewContact: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.accessibilityIdentifier = "viewContact"
        return view
    }()
    
    private lazy var imageContact: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        image.accessibilityIdentifier = "imageContact"
        image.layer.borderColor = ColorName.grayStrong.color.cgColor
        return image
    }()
    
    private lazy var nickContactLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "nickContactLabel"
        label.font = UIFont(font: FontFamily.SFUIText.semibold, size: 16)
        label.textAlignment = .right
        label.textColor = .white
        label.text = "@mmarques"
        return label
    }()
    
    private lazy var nameContactLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "nameContactLabel"
        label.font = UIFont(font: FontFamily.SFUIText.regular, size: 14)
        label.textAlignment = .right
        label.textColor = .white
        label.alpha = 0.5
        label.text = "Hundily Cerqueira"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        setupViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureLayoutContact()
    }
    
    private func configureLayoutContact() {
        imageContact.layer.cornerRadius = imageContact.frame.size.width / 2
        imageContact.layer.masksToBounds = true
        imageContact.layer.borderWidth = 1.0
    }
    
    func configure(contact: Contact) {
        nameContactLabel.text = contact.name
        nickContactLabel.text = contact.username
        imageContact.imageFromURL(urlString: contact.img)
    }
}

extension ContactViewCell: CodeViewProtocol {
    func buildViewHierarchy() {
        addSubview(viewContact)
        viewContact.addSubview(imageContact)
        viewContact.addSubview(nickContactLabel)
        viewContact.addSubview(nameContactLabel)
    }
    
    func setupConstraints() {
        viewContact.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: trailingAnchor,
                           insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        viewContact.anchor(height: 80)
        
        imageContact.anchor(leading: viewContact.leadingAnchor,
                            insets: .init(top: 0, left: 20.0, bottom: 0, right: 0))
        imageContact.anchor(height: 52.0, width: 52.0)
        imageContact.anchorCenterYToSuperview()
        
        nickContactLabel.anchor(top: viewContact.topAnchor,
                                leading: imageContact.trailingAnchor,
                                insets: .init(top: 20.0, left: 16.0, bottom: 0, right: 0))
        
        nameContactLabel.anchor(top: nickContactLabel.bottomAnchor,
                                leading: imageContact.trailingAnchor,
                                insets: .init(top: 1.0, left: 16.0, bottom: 0, right: 0))
    }
}
