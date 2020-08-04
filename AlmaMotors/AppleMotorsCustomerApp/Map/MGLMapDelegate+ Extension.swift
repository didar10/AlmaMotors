//
//  MGLMapDelegate+ Extension.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/27/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.


import UIKit
import Mapbox

extension MapsVC: MGLMapViewDelegate {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            guard let pin = annotation as? AnnotationPin else { return nil }
            let reuseIdentifier = "FriendAnnotation"
            return FriendAnnotationView(annotation: pin, reuseIdentifier: reuseIdentifier, friend: pin.seller)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        mapView.setCenter(annotation.coordinate, zoomLevel: 13, animated: true)
            guard let pin = annotation as? AnnotationPin else { return }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.userInfoTab = UserInfoTab(annotation: pin)
//                self.userInfoTab = SellerInfoView(annotation: pin)
               
                self.selectedSeller = pin.seller
                
    
                self.view.addSubview(self.userInfoTab!)
//                self.addSlideUpSettings()
            })
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        self.userInfoTab?.removeFromSuperview()
        self.userInfoTab = nil
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
