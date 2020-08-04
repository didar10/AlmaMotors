//
//  FriendAnnotationView.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/27/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import Mapbox

class FriendAnnotationView: MGLAnnotationView {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let size: CGFloat = 32
    let imageLayer = CALayer()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(annotation: MGLAnnotation?, reuseIdentifier: String?, friend: Seller) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        imageLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        let imageName = "carcity.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageLayer.contents = imageView.image?.cgImage
        imageLayer.cornerRadius = imageLayer.frame.size.width/2
        imageLayer.masksToBounds = true
        imageLayer.borderWidth = 2.0
        imageLayer.borderColor = UIColor.white.cgColor
        layer.addSublayer(imageLayer)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
