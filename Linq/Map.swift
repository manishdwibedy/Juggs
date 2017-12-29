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
import JPSThumbnailAnnotation
import SDWebImage

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class Map: UIViewController,MKMapViewDelegate,UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tbPosts: UITableView!
    let locationManager = CLLocationManager()
    
    //    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    var posts = [Post]()
    
    var tempPosts = [Post]()
    
    var address = [AnyObject]() // Add address coordinates if we have to go that route
    var followers = [String]()
    //////   ADDS  RADIUS  CIRCLE   //////
    
    let addRadiusCircle = CLLocation()
    var circle: MKCircle?
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        handleLocation()
        fetchFollowers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.barTintColor = UIColor.black
       
        mapView.tintColor = UIColor.black
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tbPosts.isHidden = true
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if  (searchBar.text?.characters.count)! > 0 {
            
            tempPosts = self.posts.filter() {
                if let type = ($0 as Post).nameOfEvent {
                    return type.localizedCaseInsensitiveContains(searchBar.text!)
                } else {
                    return false
                }
            }
            
            self.tbPosts.reloadData()
            self.tbPosts.isHidden = false
            
        }
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        tempPosts = self.posts.filter() {
            if let type = ($0 as Post).nameOfEvent {
                return type.localizedCaseInsensitiveContains(searchText)
            } else {
                return false
            }
        }
        
        self.tbPosts.reloadData()
        self.tbPosts.isHidden = false
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func fetchFollowers() {
        
        let ref = Database.database().reference()
        let userID : String = (Auth.auth().currentUser?.uid)!
        
        let childRef = ref.child("Users").child(userID)
        
        childRef.child("Following").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let followingUsers = snapshot.value as? [String : AnyObject] {
                for(_, value) in followingUsers {
                    //                    print(value)
                    self.followers.append(value as! String)
                }
            }
            self.fetchAddress()
            
        })
    }
    
    
    // Fetch Move Name and Address
    func fetchAddress() {
        
        let ref = Database.database().reference()
        
        let uID : String = (Auth.auth().currentUser?.uid)!
        
        ref.child("Flyers").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let posts = snapshot.value as! [String : AnyObject]
            
            self.posts.removeAll()
            
            for(_,value) in posts {
                if let userID = value["UserID"] as? String {
                    let newPost = Post()
                    let eventName = value["NameOfMove"] as? String
                    let address = value["Address"] as? String
                    let movePrivate = value["Private"] as? Bool
                    let description = value["Description"] as? String
                    let pathToImage = value["PathToImage"] as? String
                    
                    let requests = value["Requests"] as? [String:AnyObject]
                    let invites = value["Invites"] as? [String:AnyObject]
                    let AP = value["AP"] as? String
                    let date = value["Date"] as? String
                    let time = value["Time"] as? String
                    
                    newPost.AP = AP
                    newPost.date = date
                    newPost.time = time
                    
                    newPost.nameOfEvent = eventName
                    newPost.address = address
                    newPost.movePrivate = movePrivate
                    newPost.userID = userID
                    newPost.pathToImage = pathToImage
                    newPost.moveDesc = description
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                    let dateTime = "\(newPost.date ?? "") \(newPost.time ?? "") \(newPost.AP ?? "")"
                    let postdate =  dateFormatter.date(from: dateTime)
                    if postdate != nil {
                        let elapsed = Date().timeIntervalSince(postdate!)
                        let diff = self.stringFromTimeInterval(interval: elapsed)
                        
                        if diff.intValue >= 24
                        {
                            continue
                        }
                    }
                    
                    let geocoder = CLGeocoder()
                    geocoder.geocodeAddressString(address!) {
                        placemarks, error in
                        
                        let placemark = placemarks?.first
                        let lat = placemark?.location!.coordinate.latitude
                        let lon = placemark?.location!.coordinate.longitude
                        
                        let eventLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat ?? 0.00, lon ?? 0.00)
                        
                        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
                        
                        let annotation = JPSThumbnail()
                        annotation.title = newPost.nameOfEvent
                        annotation.subtitle = newPost.moveDesc
                        annotation.coordinate = eventLocation
                        
                        let manager = SDWebImageManager()
                        manager.downloadImage(with: URL.init(string: newPost.pathToImage!), options: SDWebImageOptions(rawValue: 0), progress: { (receivedSize, expectedSize) in
                            
                        }, completed: { (downloadImage , error , cacheType, finished, url ) in
                            annotation.image = downloadImage
                        })
                        
                        annotation.disclosureBlock = {() -> Void in
                            self.selectedPin = MKPlacemark.init(coordinate: annotation.coordinate)
                            self.getDirections()
                        }
                        
                        
                        if newPost.movePrivate {
                            if requests != nil {
                                
                                for(_,values) in requests! {
                                    if values["from"] as! String == uID {
                                        if values["status"] as! String == "1" || values["status"] as! String == "3" {
                                            self.posts.append(newPost)
                                            self.mapView.addAnnotation(JPSThumbnailAnnotation.init(thumbnail: annotation))
                                        }
                                    }
                                }
                                
                            }
                            
                            if invites != nil {
                                
                                for(_,values) in invites! {
                                    if values["touserID"] as! String == uID {
                                        if values["status"] as! String == "1" || values["status"] as! String == "3" {
                                            self.posts.append(newPost)
                                            self.mapView.addAnnotation(JPSThumbnailAnnotation.init(thumbnail: annotation))
                                        }
                                    }
                                }
                                
                            }
                            
                        } else {
                            if(self.getDistance(from: location, to: eventLocation)) < 160934 {
                                self.posts.append(newPost)
                                self.mapView.addAnnotation(JPSThumbnailAnnotation.init(thumbnail: annotation))
                            } else {
                                if self.followers.contains(userID) {
                                    self.posts.append(newPost)
                                    self.mapView.addAnnotation(JPSThumbnailAnnotation.init(thumbnail: annotation))
                                }
                            }
                        }
                    }
                }
            }
            
        })
        
        ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = tempPosts[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.nameOfEvent
        cell.detailTextLabel?.text = searchResult.moveDesc
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.tbPosts.isHidden = true
        self.view.endEditing(true)
        let searchResult = tempPosts[indexPath.row]
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchResult.address) { (placemarks, error ) in
            
            if error  == nil {
                let placemark = placemarks?.first
                let lat = placemark?.location!.coordinate.latitude
                let lon = placemark?.location!.coordinate.longitude
                
                let eventLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat ?? 0.00, lon ?? 0.00)
                
                self.mapView.setCenter(eventLocation, animated: true)
            } else {
                print(error?.localizedDescription as Any)
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.conforms(to: JPSThumbnailAnnotationViewProtocol.self) {
            (view as! JPSThumbnailAnnotationViewProtocol).didSelectAnnotationView(inMap: mapView)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.conforms(to: JPSThumbnailAnnotationViewProtocol.self) {
            (view as! JPSThumbnailAnnotationViewProtocol).didDeselectAnnotationView(inMap: mapView)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        if annotation.conforms(to: JPSThumbnailAnnotationProtocol.self) {
            return (annotation as! JPSThumbnailAnnotationProtocol).annotationView(inMap: mapView)
        }
        
        //        if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        //            return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
        //        }
        //
        //        let reuseId = "pin"
        //        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        //        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        //        pinView?.pinTintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        //        // black - Color for private pins
        //        pinView?.canShowCallout = true
        //        let smallSquare = CGSize(width: 30, height: 30)
        //        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        //        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        //        button.addTarget(self, action: #selector(Map.getDirections), for: .touchUpInside)
        //        pinView?.leftCalloutAccessoryView = button
        //        return pinView
        
        return nil
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
    
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let hours = (ti / 3600)
        return NSString(format: "%0.2d",hours)
    }
    
    func handleLocation() {
        
        locationManager.delegate = (self as CLLocationManagerDelegate)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // locationManager.startUpdatingLocation()
        //        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        //        resultSearchController?.searchResultsUpdater = locationSearchTable
        //        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        //        locationSearchTable.handleMapSearchDelegate = self
        
        //        resultSearchController = UISearchController()
        //        let searchBar = resultSearchController!.searchBar
        //
        //        searchBar.sizeToFit()
        //
        //        searchBar.placeholder = "Search for Juggs"
        
        //      People, Gender, etc
        
        //        navigationItem.titleView = resultSearchController?.searchBar
        
        //        resultSearchController?.hidesNavigationBarDuringPresentation = false
        //        resultSearchController?.dimsBackgroundDuringPresentation = true
        //        definesPresentationContext = true
        
        //        locationSearchTable.mapView = mapView
        
        
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
            
        }
        
        let location = CLLocation(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        addRadiusCircle(location)
        self.mapView.delegate = self
        circle = MKCircle(center: location.coordinate, radius: 160934 as CLLocationDistance)
        self.mapView.add(circle!)
        //        print(location)
        
        let center = CLLocationCoordinate2DMake( locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude)
        let span: MKCoordinateSpan = MKCoordinateSpanMake(5.0, 5.0)
        let regionToDisplay: MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        self.mapView.setRegion(regionToDisplay, animated: false)
        
        if locations.first != nil {
            // print("location:: (location)")
            fetchFollowers()
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
        let span = MKCoordinateSpanMake(100.0, 100.0)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

//extension Map : MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
//        if annotation is MKUserLocation {
//            //return nil so map view draws "blue dot" for standard user location
//            return nil
//        }
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        pinView?.pinTintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
//        // black - Color for private pins
//        pinView?.canShowCallout = true
//        let smallSquare = CGSize(width: 30, height: 30)
//        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
//        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
//        button.addTarget(self, action: #selector(Map.getDirections), for: .touchUpInside)
//        pinView?.leftCalloutAccessoryView = button
//        return pinView
//    }
//}







