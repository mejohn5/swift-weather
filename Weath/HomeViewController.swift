//
//  FirstViewController.swift
//  Weath
//
//  Created by Marcus Johnson on 8/13/17.
//  Copyright © 2017 weather. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class HomeViewController: UIViewController ,CLLocationManagerDelegate,MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource{
    var locationManager: CLLocationManager!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    var cityList = [CityMO]()
    var currentLoction: CLPlacemark?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        map?.showsUserLocation = true
        requestLocationAccess()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(gestureReconizer:)))
        map.addGestureRecognizer(gestureRecognizer)
        loadSavedCities()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func loadSavedCities(){
        let fetchRequest =
            NSFetchRequest<CityMO>(entityName: Constants.entityName)
        do {
            cityList = try     CoreDataStack.shared.context.fetch(fetchRequest)
        } catch let _ as NSError {
        }
        tableView.reloadData()

    }
    @IBAction func saveCurrentLocation(_ sender: Any) {
        let entity =
            NSEntityDescription.entity(forEntityName: Constants.entityName,
                                       in:     CoreDataStack.shared.context)!
        if (currentLoction != nil){
            let city = CityMO.init(entity: entity, insertInto: CoreDataStack.shared.context)
            city.name  = currentLoction?.locality
            city.lat = (currentLoction?.location?.coordinate.latitude)!
            city.lng = (currentLoction?.location?.coordinate.longitude)!
            if( CoreDataStack.shared.save() == .saved){
                cityList.append(city)
                addNewRow()
            }
        }
        else{
            showError()
        }
        
    }
    func showError(){
        let alert = UIAlertController(title: "Error", message: "Not Location Found", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Working!!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.map.setRegion(region, animated: true)
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    func updateTableUI(){
        if cityList.count == 0{
            tableView.isHidden = true
        }
        else{
            tableView.isHidden = false

        }
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        updateTableUI()
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = cityList[indexPath.row].name
        return cell
    }
    func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        if(gestureReconizer.state == UIGestureRecognizerState.ended){
            let allAnnotations = self.map.annotations
            self.map.removeAnnotations(allAnnotations)
            let location = gestureReconizer.location(in: map)
            let coordinate = map.convert(location,toCoordinateFrom: map)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            map.addAnnotation(annotation)
            getAddressFromCurrentLocation(lat: coordinate.latitude, lng: coordinate.longitude)
            updatemapLocation(lat: coordinate.latitude, lng: coordinate.longitude)
        }
    }
    func getAddressFromCurrentLocation(lat: Double , lng:Double){
        let location = CLLocation(latitude: lat, longitude: lng)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                self.currentLoction = (placemarks?[0])!
                self.currentLocationLabel.text = self.currentLoction?.locality
                print(self.currentLoction)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })

        
    }
    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        updatemapLocation(lat: userLocation.coordinate.latitude, lng: userLocation.coordinate.longitude)
         getAddressFromCurrentLocation(lat: userLocation.coordinate.latitude, lng: userLocation.coordinate.longitude)
    }
    func updatemapLocation(lat: Double , lng:Double){
        let center = CLLocationCoordinate2D(latitude:lat, longitude: lng)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        
        self.map.setRegion(region, animated: true)
    }
    func addNewRow(){
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: cityList.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
}


