//
//  SellerInfoView.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/30/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import Mapbox

class SellerInfoView: UIView{
    
    let mapsVC = MapsVC()
    var pin: AnnotationPin!
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let statsLabel = UILabel()

    init(annotation: MGLAnnotation) {
        super.init(frame: .zero)
        backgroundColor = .yellow
        setupLabels()
        setupStackView()
        setupUserInfo(annotation)
    }
    

    func setupUserInfo(_ annotation: MGLAnnotation){
        if let pin = annotation as? AnnotationPin {
            self.pin = pin
            guard let title = annotation.title, let lastSeen = annotation.subtitle else { return }
            nameLabel.text = title
            usernameLabel.text = lastSeen
        }
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            usernameLabel
            ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 16, left: 24, bottom: 16, right: 16)
    }

    fileprivate func setupLabels() {
        nameLabel.text = "Chris"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        usernameLabel.text = "@ChrisKiix"
        usernameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        usernameLabel.textColor = .lightBlue

        let attributedText = NSMutableAttributedString(string: "37 ",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
        attributedText.append(NSAttributedString(string: "Following   ", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.lightBlue
            ]))
        attributedText.append(NSAttributedString(string: "2 ",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]))
        attributedText.append(NSAttributedString(string: "Followers", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.lightBlue
            ]))

        statsLabel.attributedText = attributedText
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
