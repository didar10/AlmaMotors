//
//  MapViewController.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/8/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {
    var mapView: MGLMapView!
    var latitude: Double = 0.0
    var longitude: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MGLMapView(frame: view.bounds)
        mapView.showsUserLocation = true
        // Almaty
        let center = CLLocationCoordinate2D(latitude: 43.21984255, longitude: 76.91835189)
         
        // Starting point
        mapView.setCenter(center, zoomLevel: 10, direction: 0, animated: false)
         //ADD YOU CUSTOM MAP STYLE HERE
        mapView.styleURL = URL(string:"mapbox://styles/mapbox/streets-v11")
        view.addSubview(mapView)
         
        // Setup single tap gesture
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        
         
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           setNeedsStatusBarAppearanceUpdate()
       }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissView()
    }
    
   
    
    
    // Handle single taps
    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        let point: CGPoint = sender.location(in: sender.view!)
        let coordinate:CLLocationCoordinate2D = mapView.convert(point, toCoordinateFrom: nil)
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        print("You tapped at: \(latitude) and \(longitude)")
        
        
        
        if mapView.annotations?.count != nil, let existingAnnotations = mapView.annotations {
            mapView.removeAnnotations(existingAnnotations)
            print("removed")
        }
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
       
        mapView.addAnnotation(annotation)
        print("added")
        
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "coordinates", sender: self)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RegistrationViewController
        vc.latitude = self.latitude
        vc.longitude = self.longitude
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
