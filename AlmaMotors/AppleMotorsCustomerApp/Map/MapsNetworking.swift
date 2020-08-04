//
//  MapsNetworkingMain.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/15/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//
import Foundation
import Mapbox

class MapsNetworking {
    
    var mapsVC: MapsVC!
    var sellerList: [Seller] = []
//    var sellerInfoTab: SellerInfoTab?
    
    func loadSelleers() {
        downloadSellerFromFirebase { (allseller) in
            self.sellerList = allseller
            self.observeSellerLocation()
        }
    }
    
    func observeSellerLocation(){
        for seller in sellerList{
            let lat = seller.latitude!
            let long = seller.longitude!
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            self.handleSellerLocation(seller, coordinate)
        }
    }
    
    func handleSellerLocation(_ seller: Seller, _ coordinate: CLLocationCoordinate2D){
        let sellerPin = AnnotationPin(coordinate, seller)
        mapsVC.sellerCoordinates[seller.sellerId ?? ""] = coordinate
        mapsVC.mapView.addAnnotation(sellerPin)
        if mapsVC.isSellerSelected && mapsVC.selectedSeller.sellerId != nil {
                   guard let coordinate = mapsVC.sellerCoordinates[mapsVC.selectedSeller.sellerId!] else { return }
                   mapsVC.mapView.setCenter(coordinate, zoomLevel: 13, animated: true)
        }
    }
       
//    func addAnnotation() {
//       // Initialize and add the marker annotation.
//    var pointAnnotations = [MGLPointAnnotation]()
//    for seller in sellerList {
//    let point = MGLPointAnnotation()
//    let lat = seller.latitude!
//    let long = seller.longitude!
//    point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//    point.title = seller.address
//    point.subtitle = seller.storeName
////    pointAnnotations.index(Int, offsetBy: <#T##Int#>)
////    var title = point.title
////    var subtitle = point.subtitle
////    title = seller.sellerName
////    subtitle = seller.address
////    sellerInfoTab?.addressLabel.text! = subtitle!
////    sellerInfoTab?.storeNameLabel.text! = title!
//    pointAnnotations.append(point)
//    }
//       // Add marker to the map.
//    mapsVC.mapView.addAnnotations(pointAnnotations)
//    }
    
}
