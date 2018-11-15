//
//  PanicViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-14.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
import CoreLocation

class PanicViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func sosEmergencyCall(_ sender: Any) {
        print("Panic mode")
        guard let numberString = String("911"), let url = URL(string: "telprompt://\(numberString)") else { return }
        UIApplication.shared.open(url)
        
        let sms: String = "sms:+1234567890&body=Hello Abc How are You I am ios developer."
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    

    @IBAction func goHomeButton(_ sender: Any) {
        getDirectionsHome()
    }
    
    
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        

        // Do any additional setup after loading the view.
    }
    
    func getDirectionsHome() {
        
        // Home coordinates
        let latitude: CLLocationDegrees = 37.2
        let longitude: CLLocationDegrees = 22.9
        
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("Location = \(locValue.latitude) \(locValue.longitude) ")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 500, 500)
        self.mapView.setRegion(viewRegion, animated: true)
        self.mapView.showsUserLocation = true;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
