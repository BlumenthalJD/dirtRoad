//
//  Running.swift
//  finalProject
//
//  Created by Joel Blumenthal on 11/3/15.
//  Copyright © 2015 Joel Blumenthal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class Running: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //global variable declarations
    @IBOutlet weak var routeMap: MKMapView!
    let locationManager=CLLocationManager()
    var locations=[CLLocation]()
    var drawCount=0
    var startLocationLong:Double=0
    var startLocationLat:Double=0
    var name=""
    var date=""
    var publish=false
    
    //share button action
    @IBAction func shareButton(sender: AnyObject) {
        let myShare="I am offroading on \(name)!"
        let activityVC:UIActivityViewController=UIActivityViewController(activityItems: [myShare], applicationActivities: nil)
        presentViewController(activityVC, animated: true, completion: nil)
        print ("test")
    }
    
    //performs code before the segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print (name)
        print (date)
        print (publish.boolValue)
        
        //pushes to core data
        let appDel:AppDelegate=(UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext=appDel.managedObjectContext
        let newRunLocation=NSEntityDescription.insertNewObjectForEntityForName("Trails", inManagedObjectContext: context) as NSManagedObject
        
        newRunLocation.setValue(name, forKey: "name")
        newRunLocation.setValue(date, forKey: "date")
        newRunLocation.setValue(startLocationLat, forKey: "startLat")
        newRunLocation.setValue(startLocationLong, forKey: "startLong")
        
        do
        {
            try context.save()
        }
        catch _
        {
            print("There was a problem saving to Core Data.")
        }
        
        print (newRunLocation)
        print ("Just saved a new run!")
        
        //Got from http://www.kaleidosblog.com/nsurlsession-in-swift-get-and-post-data
        //posts to database if publish is true
        if (publish==true)
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "hostname")!)
            request.HTTPMethod = "POST"
            let postString = "name=\(name)&date=\(date)&startLocationLat=\(startLocationLat)&startLocationLong=\(startLocationLong)"
            print (postString)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
            }
            task.resume()
        }
    }
    
    //Got from http://www.johnmullins.co/blog/2014/08/14/location-tracker-with-maps/
    //places route over past user location
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
        //drawing path or route covered
        
        if let oldLocationNew = oldLocation as CLLocation?
        {
            drawCount++
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            
            if (drawCount>1)
            {
                routeMap.addOverlay(polyline)
            }
            
            if (drawCount==1)
            {
                startLocationLong=(locationManager.location?.coordinate.longitude)!
                startLocationLat=(locationManager.location?.coordinate.latitude)!
                print (startLocationLong)
                print (startLocationLat)
            }
        }
    }
    
    //Got from http://stackoverflow.com/questions/24798737/how-to-use-mkpolylineview-in-swift
    //draws polyline
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer!
    {
        if (overlay is MKPolyline) {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orangeColor()
            renderer.lineWidth = 5
            return renderer
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //loads map data
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        routeMap.delegate=self
        routeMap.mapType=MKMapType.Hybrid
        routeMap.showsUserLocation=true
        
        routeMap.userTrackingMode = MKUserTrackingMode.Follow
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}