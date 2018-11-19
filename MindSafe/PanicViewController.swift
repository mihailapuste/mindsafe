//
//  PanicViewController.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-11-14.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import MessageUI
import CoreLocation

class PanicViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    var contacts: [Contacts] = [];
    
    @IBOutlet weak var contactsTable: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for : indexPath) as! ContactTableViewCell
        
        let firstName = contacts[indexPath.row].value(forKey: "firstName") as? String
        let lastName = contacts[indexPath.row].value(forKey: "lastName") as? String
        let contactRelationship = contacts[indexPath.row].value(forKey: "contactRelationship") as? String
        let phoneNumber = contacts[indexPath.row].value(forKey: "phoneNumber") as? String
//        let contactEmail = contacts[indexPath.row].value(forKey: "contactEmail") as? String
//        let contactAddress = contacts[indexPath.row].value(forKey: "contactAddress") as? String
        //        cell.title?.text =  String(firstName! + " " + lastName!)
        //        cell.relationship?.text = contactRelationship
        //        cell.cellID = indexPath.row
        
        cell.nameLabel?.text = String(firstName! + " " + lastName!)
        cell.relationshipLabel?.text = contactRelationship
        cell.phoneNumber = phoneNumber!
        
        return cell
    }
    
    
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
    
    //Constructor arguments -> getting data from coredata and reloading table content
    override func viewWillAppear(_ animated: Bool) {
        getData() // get the data from core data
        contactsTable.reloadData() // reload table view
    }
    
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext;
        
        do
        {
            contacts = try context.fetch(Contacts.fetchRequest())
        }
        catch
        {
            print("fetch failed!")
        }
        
    }
    
    func getDirectionsHome() {
        
        let street = UserDefaults.standard.object(forKey: "street") as? String
        let city = UserDefaults.standard.object(forKey: "city") as? String
        let provstate = UserDefaults.standard.object(forKey: "provstate") as? String
        let zip = UserDefaults.standard.object(forKey: "zip") as? String
        let country = UserDefaults.standard.object(forKey: "country") as? String
        
        if "\(street!)\(city!)\(provstate!)\(zip!)\(country!)" != "" {
        
        
        let address = "\(street!), \(city!), \(provstate!) \(zip!), \(country!)"
        

        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    self.showAlert(title: "Location not found!", message: "Please ensure your address is properly filled in!")
                    // handle no location found
                    return
            }
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Lat: \(lat), Lon: \(lon)")
            // Use your location
            
            // Home coordinates
            let latitude: CLLocationDegrees = lat
            let longitude: CLLocationDegrees = lon
            
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
           
            let firstName = UserDefaults.standard.object(forKey: "firstName") as? String
            
            mapItem.name = "\(firstName!)'s Home"
            mapItem.openInMaps(launchOptions: options)
        }
        }
        else{
             showAlert(title: "No home address found!", message: "Please ensure your personal address is provided in your personal information.")
        }
        
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
