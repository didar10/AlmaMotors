//
//  AccountItemCell.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/29/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

class AccountItemCell: UITableViewCell {
    
    let mapsVC = MapsVC()
    var pin: AnnotationPin!

    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightBlue
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    
    func setupUserInfo(_ annotation: MGLAnnotation){
        if let pin = annotation as? AnnotationPin {
            self.pin = pin
            guard let title = annotation.title, let lastSeen = annotation.subtitle else { return }
            storeNameLabel.text = title
            addressLabel.text = lastSeen
        }
    }

    fileprivate func setupViews() {
        let labelStackView = UIStackView(arrangedSubviews: [storeNameLabel, addressLabel])
        labelStackView.axis = .vertical

        let stackView = UIStackView(arrangedSubviews: [
            labelStackView,
            UIView()
            ])

        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

