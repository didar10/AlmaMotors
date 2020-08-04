//
//  ThumbSlidingView.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/29/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import UIKit

class ThumbSlidingView: UIView {

    override var intrinsicContentSize: CGSize {
        return .init(width: 40, height: 6)
    }

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 3
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

