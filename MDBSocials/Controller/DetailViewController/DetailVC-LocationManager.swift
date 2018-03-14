//
//  DetailVC-LocationManager.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/14/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import MapKit
import CoreGraphics
import CoreLocation

extension DetailVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        log.info("Updated location")
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentLocation = currentLocation
    }

    func queryLyft(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        let eventlocation = CLLocationCoordinate2D(latitude: currPost.latitude!, longitude: currPost.longitude!)
        log.info(eventlocation)
        if self.currentLocation != nil {
            LyftHelper.getRideEstimate(pickup: self.currentLocation!, dropoff: eventlocation) { costEstimate in
                self.lyftLabel.setTitle("A Lyft will cost $" + String(describing: costEstimate.estimate!.maxEstimate.amount) + " from your location.", for: .normal)
            }
        } else {
            log.error("Cant get current location")
        }
    }
    
    @objc func toLyft() {
        if lyftInstalled() {
            open(scheme: "lyft://partner=YOUR_CLIENT_ID")
        } else {
            open(scheme: "https://www.lyft.com/signup/SDKSIGNUP?clientId=YOUR_CLIENT_ID&sdkName=iOS_direct")
        }
    }
    
    func lyftInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "lyft://")!)
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func addPointer(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: currPost.latitude!, longitude: currPost.longitude!)
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.002, 0.002)), animated: true)
    }
    
    @objc func openAppleMaps() {
        let coordinate = CLLocationCoordinate2DMake(37.786272279415272, -122.40631651595199)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Destination/Target Address or Name"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}
