//
//  TrackerViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-13.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class TrackerViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var editSafeZoneSwitch: UISwitch!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func searchButton(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func addRegion(_ sender: Any) {
        if (editSafeZoneSwitch.isOn == true){
            guard let longPress = sender as? UILongPressGestureRecognizer else { return }
            let touchlocation = longPress.location(in: mapView)
            let coordinate = mapView.convert(touchlocation, toCoordinateFrom: mapView)
            let locationLat = NSNumber(value:coordinate.latitude)
            let locationLon = NSNumber(value:coordinate.longitude)
            UserDefaults.standard.set(["lat": locationLat, "lon": locationLon], forKey:"safeZoneCoordinate")
            let safeZoneRadius = UserDefaults.standard.object(forKey: "safeZoneRadius") as! Int
            let region = CLCircularRegion(center: coordinate, radius: Double(safeZoneRadius), identifier: "GEOFENCE")
            
            mapView.removeOverlays(mapView.overlays)
            locationManager.startMonitoring(for: region)
            let circle = MKCircle(center: coordinate, radius: region.radius)
            mapView.add(circle)
            editSafeZoneSwitch.isOn = false;
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayPathRenderer()}
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = .blue
        circleRenderer.fillColor = .blue
        circleRenderer.alpha = 0.3
        
        return circleRenderer
    }
    
    // method creating alerts
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // method creating
    func showNotification(title: String, subtitle: String, body: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Geofence notifiaction", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    // Method triggered when ENTERING GEOFENCE
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let safezone = UserDefaults.standard.object(forKey: "safeZoneNotifications") as? Bool
        if safezone == true {
        showAlert(title: "Safe Zone Entered", message: "You have entered your set Safe Zone!")
        showNotification(title: "Safe Zone Entered", subtitle: "You have entered your set Safe Zone.", body:
            "To change or disable your Safe Zone, go to the Tracker page.")
        }
    }
    
    // Method triggered when LEAVING GEOFENCE
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let safezone = UserDefaults.standard.object(forKey: "safeZoneNotifications") as? Bool
        if safezone == true {
        showAlert(title: "Safe Zone Exited", message: "You have left your set Safe Zone! Emergency contacts will be notified.")
        showNotification(title: "Safe Zone Exited", subtitle: "You have left your Safe Zone!", body:"Emergency contacts will be notified!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if let locationDictionary = UserDefaults.standard.object(forKey: "safeZoneCoordinate") as? Dictionary<String,NSNumber> {
            let locationLat = locationDictionary["lat"]!.doubleValue
            let locationLon = locationDictionary["lon"]!.doubleValue
            let coordinate = CLLocationCoordinate2DMake(locationLat, locationLon)
            let safeZoneRadius = UserDefaults.standard.object(forKey: "safeZoneRadius") as! Int
            
            let region = CLCircularRegion(center: coordinate, radius: Double(safeZoneRadius), identifier: "GEOFENCE")
            mapView.removeOverlays(mapView.overlays)
            locationManager.startMonitoring(for: region)
            let circle = MKCircle(center: coordinate, radius: region.radius)
            mapView.add(circle)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("Location = \(locValue.latitude) \(locValue.longitude) ")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 500, 500)
        self.mapView.setRegion(viewRegion, animated: true)
        self.mapView.showsUserLocation = true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        // Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        // activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        // hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Create search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print("Error")
            }else{
                // Remove annotations
                //                let annotations = self.mapView.annotations
                //                self.mapView.removeAnnotation(annotations as! MKAnnotation)
                
                // Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                // Create annotation
                let annotation = MKPointAnnotation()
                
                annotation.title = searchBar.text! // <- not workings
                
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                // Zooming in on location
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
        
        
    }
    
 
}

