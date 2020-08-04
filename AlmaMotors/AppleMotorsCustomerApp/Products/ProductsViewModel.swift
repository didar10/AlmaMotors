//
//  TiresViewModel.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 6/2/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import UIKit

class ProductsViewModel {

    private let service: ProductsServiceProtocol

    var model: products = products() {
        didSet {
            self.count = self.model.count
        }
    }

    /// Count your data in model
    var count: Int = 0

    //MARK: -- Network checking

    /// Define networkStatus for check network connection

    /// Define boolean for internet status, call when network disconnected
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = "No network connection. Please connect to the internet"
            self.internetConnectionStatus?()
        }
    }

    //MARK: -- UI Status



    /// Showing alert message, use UIAlertController or other Library
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    /// Define selected model
//    var selectedFriend: Tire?

    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?
    var didGetData: (() -> ())?

    init(withTires serviceProtocol: ProductsServiceProtocol = ProductsService() ) {
        self.service = serviceProtocol
    }
    
    func getTires(success: @escaping () -> Void) {
          self.service.getTires(success: { tires in
          self.model = tires
            success()
          }) { error in
            self.alertMessage = error
        }
    }
    
    

}


