//
//  Map.swift
//  Linq
//
//  Created by Quinton Askew on 5/29/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase



protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class Map: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
   
     let locationManager = CLLocationManager()
    
    
    var resultSearchController:UISearchController? = nil
    
    
    var selectedPin:MKPlacemark? = nil
    
    var posts = [Post]()
    var address = [AnyObject]() // Add address coordinates if we have to go that route
  
    
    //////   ADDS  RADIUS  CIRCLE   //////
    
    let addRadiusCircle = CLLocation()
    var circle: MKCircle?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        handleLocation()
        fetchAddress()
        mapView.tintColor = UIColor.black
    
    }

   // Fetch Move Name and Address
    
    func fetchAddress() {
        
        let ref = Database.database().reference()
        
        ref.child("Flyers").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
           
        let posts = snapshot.value as! [String : AnyObject]
          
        self.posts.removeAll()
        
            for(_,value) in posts {
                if let userID = value["UserID"] as? String {
                let newPost = Post()
                let eventName = value["NameOfMove"] as? String
                let address = value["Address"] as? String
                let movePrivate = value["Private"] as? String
                newPost.nameOfEvent = eventName
                newPost.address = address
                newPost.movePrivate = movePrivate
                newPost.userID = userID
                
                print(address!)
                    
                let geocoder = CLGeocoder()
                    geocoder.geocodeAddressString(address!) {
                        placemarks, error in
                        let placemark = placemarks?.first
                        let lat = placemark!.location!.coordinate.latitude
                        let lon = placemark!.location!.coordinate.longitude
                        
                        print("The address's coordinates are " + "Lat: \(lat), Lon: \(lon)")
                        let eventLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
                         let annotation = MKPointAnnotation()
                        annotation.title = eventName
                        annotation.coordinate = eventLocation
                        self.mapView.addAnnotation(annotation)
                       // let twoDLoction: CLLocation =
                        print(self.getDistance(from: location, to: eventLocation))
                        
                        if(self.getDistance(from: location, to: eventLocation)) > 160934 {
                            
                            self.mapView.removeAnnotation(annotation)
                        }

                        // Looks like it should work but doesnt
                      if(movePrivate == "true") {
                            
                            self.mapView.removeAnnotation(annotation)
                        }
                        
                    }
                   
                
                }
            }
            
        })
        
        ref.removeAllObservers()
    }
    
    
  
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }

    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
        
    }
    

 
    func handleLocation() {
        
        locationManager.delegate = (self as CLLocationManagerDelegate)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
       // locationManager.startUpdatingLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController?.searchResultsUpdater = locationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        locationSearchTable.handleMapSearchDelegate = self
        let searchBar = resultSearchController!.searchBar
        
        searchBar.sizeToFit()
        
        searchBar.placeholder = "Search for Juggs, People, Gender, etc"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

    
    
    
    }

    
  /*  func convertAddress(address: String) {
        
     /////IF I NEED TO CONVERT ADDRESS TO COORDINATES//////
     
     
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("143 W Modlin Rd, Ahoskie, NC, 27910") {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark!.location!.coordinate.latitude
            let lon = placemark!.location!.coordinate.longitude
            
            print("The address's coordinates are " + "Lat: \(lat), Lon: \(lon)")
            
           
        
        }
        
        
    }  */



    }

extension Map : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            
           // print("target position : =  \(location.coordinate)")
           // print(locationManager.location!.coordinate.latitude)
         
            locationManager.stopUpdatingLocation()
            
              Database.database().reference().child("Location").child(Auth.auth().currentUser!.uid).setValue(["Latitude": locationManager.location?.coordinate.latitude, "Longitude": locationManager.location?.coordinate.longitude])
            
            
        }
        
        let location = CLLocation(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        addRadiusCircle(location)
        self.mapView.delegate = self
        circle = MKCircle(center: location.coordinate, radius: 160934 as CLLocationDistance)
        self.mapView.add(circle!)
        print(location)
        
         if locations.first != nil {
           // print("location:: (location)")
             fetchAddress()
        }
        
    }
    
    @objc(mapView:rendererForOverlay:) public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        circleRenderer.lineWidth = 3.0
        return circleRenderer
    }


    func addRadiusCircle(_ location: CLLocation){
        self.mapView.delegate = self
        
        self.mapView.removeOverlays(self.mapView.overlays)
        
    }

/*
    func centerMapOnLocation(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        
    } */







}

extension Map: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension Map : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
         // black - Color for private pins
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(Map.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}







