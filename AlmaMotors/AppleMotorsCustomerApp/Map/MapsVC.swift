//
//  MapsVC.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/12/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Mapbox

class MapsVC: UIViewController {

    var mapView: MGLMapView!
    let mapNetworking = MapsNetworking()
    var isSellerSelected = false
    var selectedSeller: Seller!
    var sellerCoordinates = [String: CLLocationCoordinate2D]()
    var userInfoTab: UserInfoTab?
//    var userInfoTab: SellerInfoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
           let navBarAppearance = UINavigationBarAppearance()
           navBarAppearance.configureWithOpaqueBackground()
           navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
           navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
           navBarAppearance.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.00)
           self.navigationController?.navigationBar.standardAppearance = navBarAppearance
           self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        setupMapView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapNetworking.mapsVC = self
        mapNetworking.loadSelleers()

    }
    

    private func setupMapView(){
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.showsUserLocation = true
               // Almaty
        let center = CLLocationCoordinate2D(latitude: 43.21984255, longitude: 76.91835189)

               // Starting point
        mapView.setCenter(center, zoomLevel: 10, direction: 0, animated: false)

        view.addSubview(mapView)

               // Remember to set the delegate.
        mapView.delegate = self
        mapView.logoView.isHidden = true
    }
    
    func addSlideUpSettings() {
        let controller = SlideUpSettings()
        controller.modalPresentationStyle = .overCurrentContext
        self.parent?.parent?.present(controller, animated: false, completion: nil)
    }
    
    

    // MARK: - MapView

//    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//    return true
//    }
}
