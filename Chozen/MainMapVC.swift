//
//  MainMapVC.swift
//  Chozen
//
//  Created by HamiltonMac on 9/14/16.
//  Copyright © 2016 HamiltonMac. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class MainMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate { //, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    //@IBOutlet weak var detailButton: UIButton!
    //@IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var centerBtn: UIButton!
    
    let locationManager = CLLocationManager()
    var mapHasCenter = false
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    let regionRadius: CLLocationDistance = 3000
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        centerBtn.isHidden = true
        
        //self.mainTableView.dataSource = self
        //self.mainTableView.delegate = self
        
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        locationAuthStatus()
        forwardGeocoding(address: "12661 W Lake Houston Pkwy")
        
    }

    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        locationAuthStatus()
        
    }
    
    // This will set the location of the business
    func forwardGeocoding(address: String){
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            print("forwardGeocode")
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                let loc = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                //createSighting(forLocation: loc, withBusiness: "Starbucks")
                self.geoFire.setLocation(loc, forKey: "Starbucks")
                /*
                if (placemark?.areasOfInterest?.count)! > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
                 */
            }
           
        })
    
    }
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Sample Text"
        return cell
    }
    */
    
    @IBAction func onBtnTapped(_ sender: AnyObject) {
        print("buttonTap")
        centerMapOnLocation(location: locationManager.location!)
        
    }

    func locationAuthStatus(){
        print("locAthStatus")
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            print("authorizedwheninuse")
            centerBtn.isHidden = false
            let coordinateRegion = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, regionRadius * 10, regionRadius * 10)
            mapView.setRegion(coordinateRegion, animated: true)
            mapView.showsUserLocation = true
            
        } else {
            print("authnotinuse")
            locationManager.requestWhenInUseAuthorization()
           
        }
        
    }
    
    // This is called if the user changes his/her authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuth")
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationAuthStatus()
            print("didChangeAuth_true")
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        print("centerMap")
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 10, regionRadius * 10)
        mapView.setRegion(coordinateRegion, animated: true)

        }
        
    /*
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
            
            if let loc = userLocation.location{
            
                if !mapHasCenter {
                    centerMapOnLocation(location: loc)
                    //print("Im here, HEYYY")
                    mapHasCenter = true
                }
            }
    }
 */
 
    func createSighting(forLocation location: CLLocation, withBusiness businessId: String){
        geoFire.setLocation(location, forKey: businessId)
    }
    
    func showSightingsOnMap(location: CLLocation){
        let circleQuery = geoFire!.query(at: location, withRadius: 20)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            if let key = key, let location = location {
                let anno = BusinessAnnotation(coordinate: location.coordinate, businessName: key)
                
                self.mapView.addAnnotation(anno)
            }
            
        })
    }

   
    
    
    // Create custom annotation for user
    
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     
     var annotationView: MKAnnotationView?
     let annoIdentifier = "Business"
     
     if annotation.isKind(of: MKUserLocation.self) {
     annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
     annotationView?.image = UIImage(named: "ash")
     } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
     annotationView = deqAnno
     annotationView?.annotation = annotation
     } else {
     let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
     av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
     annotationView = av
     }
     
     if let annotationView = annotationView, let _ = annotation as? BusinessAnnotation {
     
     annotationView.canShowCallout = true
     annotationView.image = UIImage(named: "location_icon")
     let btn = UIButton()
     btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
     btn.setImage(UIImage(named: "map"), for: .normal)
     annotationView.rightCalloutAccessoryView = btn
     }
     
     return annotationView
     }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showSightingsOnMap(location: loc)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? BusinessAnnotation {
            let place = MKPlacemark(coordinate: anno.coordinate)
            let destination = MKMapItem(placemark: place)
            
            destination.name = anno.businessName
            let regionDistance: CLLocationDistance = 5000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
        
    }
     /*
     
     
     
     
     
     This code shows how to press a button for spot location
    
    func createSighting(forLocation location: CLLocation, withPokemon pokeId: Int){
        geoFire.setLocation(location, forKey: "\(pokeId)")
    }
    
    func showSightingsOnMap(location: CLLocation){
        let circleQuery = geoFire!.query(at: location, withRadius: 5)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            if let key = key, let location = location {
                let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                
                self.mapView.addAnnotation(anno)
            }
            
        })
    }
     
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
     
     if let anno = view.annotation as? PokeAnnotation {
     let place = MKPlacemark(coordinate: anno.coordinate)
     let destination = MKMapItem(placemark: place)
     
     destination.name = "Pokemon Sighting"
     let regionDistance: CLLocationDistance = 1000
     let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
     
     let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
     
     MKMapItem.openMaps(with: [destination], launchOptions: options)
     }
     
     }
     
    */
    
    /*
     
    
     func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
     
     let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
     
     showSightingsOnMap(location: loc)
     }
     
     
     }
     
     @IBAction func spotRandomPokemon(_ sender: AnyObject) {
     
     let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
     
     let rand = arc4random_uniform(151) + 1
     
     createSighting(forLocation: loc, withPokemon: Int(rand))
     
     }
     }
     */

    
}
