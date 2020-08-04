////
////  SellerInfoCell.swift
////  AppleMotorsCustomerApp
////
////  Created by Didar Bakhitzhanov on 5/30/20.
////  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
////
//
//import UIKit
//import Mapbox
//
//class SellerView: UIView {
//    
//    let mapsVC = MapsVC()
//    var pin: AnnotationPin!
//    let nameLabel = UILabel()
//    let lastSeenLabel = UILabel()
//    
//    override var intrinsicContentSize: CGSize {
//        return .init(width: 12, height: 120)
//    }
//
//    init(annotation: MGLAnnotation) {
//        super.init(frame: .zero)
//        backgroundColor = UIColor.red.withAlphaComponent(0.2)
//        setupNameLabel()
//        setupLastSeenLabel()
//        setupUserInfo(annotation)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupUserInfo(_ annotation: MGLAnnotation){
//        if let pin = annotation as? AnnotationPin {
//            self.pin = pin
//            guard let title = annotation.title, let lastSeen = annotation.subtitle else { return }
//            nameLabel.text = title
//            lastSeenLabel.text = lastSeen
//        }
//    }
//    
//    private func setupNameLabel(){
//        addSubview(nameLabel)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
//        let constraints = [
//            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8)
//        ]
//        NSLayoutConstraint.activate(constraints)
//    }
//    
//    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
//    
//    private func setupLastSeenLabel() {
//        addSubview(lastSeenLabel)
//        lastSeenLabel.translatesAutoresizingMaskIntoConstraints = false
//        lastSeenLabel.font = UIFont(name: "Helvetica Neue", size: 14)
//        lastSeenLabel.textColor = .lightGray
//        let constraints = [
//            lastSeenLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
//            lastSeenLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 8)
//        ]
//        NSLayoutConstraint.activate(constraints)
//    }
//    
//}
//
//class SellerInfoCell: UITableViewCell {
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
//        setupStackView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    fileprivate func setupStackView() {
//        let stackView = UIStackView(arrangedSubviews: [
//            SellerView(annotation: annotation)
//            ])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: topAnchor),
//            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
//            ])
//
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//    }
//
//}
