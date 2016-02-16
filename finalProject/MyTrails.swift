//
//  MyTrails.swift
//  finalProject
//
//  Created by Joel Blumenthal on 10/22/15.
//  Copyright © 2015 Joel Blumenthal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MyTrails: UIViewController, CLLocationManagerDelegate {

    //global variable declarations
    let locationManager = CLLocationManager()
    var location: CLLocation?
    @IBOutlet weak var myTrailsMap: MKMapView!
    var annotations=[MKPointAnnotation]()
    
    //location services denied alert
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
   
    //cancel segue
    @IBAction func cancel (segue: UIStoryboardSegue)
    {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //gets location
        getLocation()
        
        //shows annotation pins
        showMarkers()
    }
    
    //gets user location
    func getLocation()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let authStatus = CLLocationManager.authorizationStatus()
        
        if (authStatus == .NotDetermined) {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        if (authStatus == .Denied || authStatus == .Restricted) {
            showLocationServicesDeniedAlert()
            return
        }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //ensures view reloads on appearing
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        getLocation()
        showMarkers()
    }
    
    //pulls from core data and shows annotations
    func showMarkers()
    {
        let appDel:AppDelegate=(UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext=appDel.managedObjectContext
        let request=NSFetchRequest(entityName: "Trails")
        let results:NSArray=try! context.executeFetchRequest(request)
        
        //loads core data and shows annotation
        if (results.count>0)
        {
            annotations.removeAll()
            
            for (var i=0; i<results.count; i++)
            {
                let res=results[i] as! NSManagedObject
                let lat=res.valueForKey("startLat")
                let long=res.valueForKey("startLong")
                let name=res.valueForKey("name")
                let date=res.valueForKey("date")
                
                let tempAnnotation=MKPointAnnotation()
                tempAnnotation.coordinate=CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                tempAnnotation.title="\(name!)"
                tempAnnotation.subtitle="\(date!)"
                
                annotations.append(tempAnnotation)
                myTrailsMap.addAnnotation(annotations[i])
            }
        }
    }

    //updates user location shown when the user location updates
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation] ){
        myTrailsMap.showsUserLocation=true
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

