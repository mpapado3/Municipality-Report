//
//  ViewController.swift
//  Memorable places
//
//  Created by Michael Papadopoulos on 5/10/15.
//  Copyright © 2015 Razzmatazz. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!

    @IBOutlet weak var map: MKMapView!
    
    func displayAlert (title:String, message:String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
            
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        } else {
            
            if (places[activePlace]["lat"] != nil || places[activePlace]["lon"] != nil || places[activePlace]["name"] != nil) {
            
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["lon"]!).doubleValue
            
            var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            var latDelta:CLLocationDegrees = 0.01
            
            var longDelta:CLLocationDegrees = 0.01
            
            var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            
            var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = places[activePlace]["name"]
            annotation.subtitle = places[activePlace]["issue"]
            
            self.map.addAnnotation(annotation)
            
            }


            
        }
        
        
        var longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 1
        map.addGestureRecognizer(longPress)

        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var userLocation:CLLocation = locations[0]
        
        var latitude = userLocation.coordinate.latitude
        
        var longitude = userLocation.coordinate.longitude
        
        var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        var latDelta:CLLocationDegrees = 0.01
        
        var longDelta:CLLocationDegrees = 0.01
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        self.map.setRegion(region, animated: true)
    }
    
    func action(gestionRecognizer: UIGestureRecognizer) {
        
        if gestionRecognizer.state == UIGestureRecognizerState.Began {
            
            var touchPoint = gestionRecognizer.locationInView(self.map)
            
            var newCoordinate:CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            var userLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) -> Void in
                
                var title = ""
                
                if (error != nil) {
                    print(error)
                } else {
                    if let p = placemarks?[0] {
                        var subThoroughFare: String = ""
                        var thoroughFare: String = ""
                        
                        if (p.subThoroughfare != nil) {
                            subThoroughFare = p.subThoroughfare!
                        }
                        if (p.thoroughfare != nil) {
                            thoroughFare = p.thoroughfare!
                        }
                        title = "\(subThoroughFare) \(thoroughFare)"
                    }
                }
                
                if title == "" {
                    title = "Added \(NSDate())"
                }
                
                
                let refreshAlert = UIAlertController(title: "Ενημέρωσε!", message: "Διάλεξε τύπο πρόβλήματος", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Δρόμος", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    var place = "Δρόμος"
                    places.append(["name":title,"issue":place,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                    NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
                    let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
                    let myURL = NSURL(string: "http://www.razzmatazz.gr/municipapp/scripts/issueInsert.php")
                    let request = NSMutableURLRequest(URL: myURL!)
                    request.HTTPMethod = "POST"
                    
                    let postString = "name=\(title)&issue=\(place)&lon=\(newCoordinate.longitude)&lan=\(newCoordinate.latitude)&userID=\(userId!)&isitok=false"
                    
                    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                    
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue())
                            {
                                if error != nil {
                                    self.displayAlert("Error", message: (error?.localizedDescription)!)
                                    return
                                }
                                
                                do {
                                    
                                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                                    
                                    if let parseJSON = json {
                                        var issueId = parseJSON["Id"] as? String
                                        
                                                                                
                                        if issueId != nil {
                                            /* self.dismissViewControllerAnimated(true, completion: nil)
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let vc = storyboard.instantiateViewControllerWithIdentifier("initialStoryBoard") as! UIViewController
                                            self.presentViewController(vc, animated: true, completion: nil) */
                                        } else {
                                           let errorMessage = parseJSON["message"] as? String
                                            if errorMessage != nil {
                                                self.displayAlert("Succeed", message: (errorMessage!))
                                            }
                                        }
                                    }
                                } catch {
                                    
                                }
                                
                                
                        }
                        
                    }
                    task.resume()

                    
                    
                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Φώτα", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    var place = "Φώτα"
                    print(place)
                    places.append(["name":title,"issue":place,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                    NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
                    let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
                    let myURL = NSURL(string: "http://www.razzmatazz.gr/municipapp/scripts/issueInsert.php")
                    let request = NSMutableURLRequest(URL: myURL!)
                    request.HTTPMethod = "POST"
                    
                    let postString = "name=\(title)&issue=\(place)&lon=\(newCoordinate.longitude)&lan=\(newCoordinate.latitude)&userID=\(userId!)&isitok=false"
                    
                    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                    
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue())
                            {
                                if error != nil {
                                    self.displayAlert("Error", message: (error?.localizedDescription)!)
                                    return
                                }
                                
                                do {
                                    
                                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                                    
                                    if let parseJSON = json {
                                        var issueId = parseJSON["Id"] as? String
                                        
                                        
                                        
                                        if issueId != nil {
                                           /* self.dismissViewControllerAnimated(true, completion: nil)
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let vc = storyboard.instantiateViewControllerWithIdentifier("initialStoryBoard") as! UIViewController
                                            self.presentViewController(vc, animated: true, completion: nil) */
                                        } else {
                                            let errorMessage = parseJSON["message"] as? String
                                            if errorMessage != nil {
                                                self.displayAlert("Succeed", message: (errorMessage!))
                                            }
                                        }
                                    }
                                } catch {
                                    
                                }
                                
                                
                        }
                        
                    }
                    task.resume()

                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Δέντρο", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    var place = "Δέντρο"
                    print(place)
                    places.append(["name":title,"issue":place,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                    NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
                    let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
                    let myURL = NSURL(string: "http://www.razzmatazz.gr/municipapp/scripts/issueInsert.php")
                    let request = NSMutableURLRequest(URL: myURL!)
                    request.HTTPMethod = "POST"
                    
                    let postString = "name=\(title)&issue=\(place)&lon=\(newCoordinate.longitude)&lan=\(newCoordinate.latitude)&userID=\(userId!)&isitok=false"
                    
                    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                    
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue())
                            {
                                if error != nil {
                                    self.displayAlert("Error", message: (error?.localizedDescription)!)
                                    return
                                }
                                
                                do {
                                    
                                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                                    
                                    if let parseJSON = json {
                                        var issueId = parseJSON["Id"] as? String
                                        
                                        
                                        
                                        if issueId != nil {
                                           /* self.dismissViewControllerAnimated(true, completion: nil)
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let vc = storyboard.instantiateViewControllerWithIdentifier("initialStoryBoard") as! UIViewController
                                            self.presentViewController(vc, animated: true, completion: nil) */
                                        } else {
                                            let errorMessage = parseJSON["message"] as? String
                                            if errorMessage != nil {
                                                self.displayAlert("Succeed", message: (errorMessage!))
                                            }
                                        }
                                    }
                                } catch {
                                    
                                }
                                
                                
                        }
                        
                    }
                    task.resume()

                    
                }))
                
                
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
                
                var annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                
                self.map.addAnnotation(annotation)
                
            }
            
        }

        
    }
    
    func newPlace(place: String) -> String {
        let issueName = place
        return issueName
    }
    
    func pinColor() -> MKPinAnnotationColor  {
        let discipline: String = ""
        switch discipline {
        case "Δρόμος":
            return .Red
        case "Δέντρο":
            return .Purple
        default:
            return .Green
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

