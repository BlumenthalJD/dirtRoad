//
//  LocalTrails.swift
//  finalProject
//
//  Created by Joel Blumenthal on 10/22/15.
//  Copyright © 2015 Joel Blumenthal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocalTrails: UIViewController, CLLocationManagerDelegate{
    
    //global variable declarations
    @IBOutlet weak var trailsMap: MKMapView!
    let locationManager=CLLocationManager()
    var annotations=[MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //loads location
        let location2D = CLLocationCoordinate2D(latitude: (locationManager.location!.coordinate.latitude),longitude: (locationManager.location!.coordinate.longitude))
        let span = MKCoordinateSpanMake(0.7, 0.7)
        let region = MKCoordinateRegion(center: location2D, span: span)
        
        trailsMap.setRegion(region, animated: true)
        
        trailsMap.showsUserLocation=true
        
        //loads annotations
        loadPins()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        loadPins()
    }
    
    //Got from http://www.kaleidosblog.com/nsurlsession-in-swift-get-and-post-data
    //loads annotations
    func loadPins()
    {
        //pulls data through JSON from php page
        print ("loading pins")
        let url = NSURL(string: "hostname")
        let request = NSMutableURLRequest(URL: url!)
        
        // modify the request as necessary, if necessary
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            data, response, error in
            
            if data == nil
            {
                print("request failed \(error)")
                return
            }
            do
            {
                print ("Got to do")
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray
                {
                    self.annotations.removeAll()
                    
                    print("Got to Json")
                    for (var i = 0; i < jsonResult.count; i++)
                    {
                        let jsonElement: NSDictionary = jsonResult[i] as! NSDictionary;
                        
                        // Create a new location object and set its propertiess to JsonElement properties
                        let name = jsonElement["name"];
                        let date = jsonElement["date"];
                        let startLat: Double = ((jsonElement["startLat"] as? NSString)?.doubleValue)!;
                        let startLong: Double = ((jsonElement["startLong"] as? NSString)?.doubleValue)!;
                        
                        print (name!)
                        print (date!)
                        print (startLat)
                        print (startLong)
     
                        //fills annotation with pulled data
                        let tempAnnotation=MKPointAnnotation()
                        tempAnnotation.coordinate=CLLocationCoordinate2D(latitude: startLat as CLLocationDegrees, longitude: startLong as CLLocationDegrees)
                        tempAnnotation.title="\(name!)"
                        tempAnnotation.subtitle="\(date!)"
                        self.annotations.append(tempAnnotation)
                        self.trailsMap.addAnnotation(self.annotations[i])
                    }
                }
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

