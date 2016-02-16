//
//  NewRoute.swift
//  finalProject
//
//  Created by Joel Blumenthal on 11/3/15.
//  Copyright © 2015 Joel Blumenthal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NewRoute: UIViewController, CLLocationManagerDelegate {

    //global variable declarations
    @IBOutlet weak var currentMap: MKMapView!
    let locationManager=CLLocationManager()
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var publishButton: UISwitch!
    
    //declares date keyboard for date field
    @IBAction func dateKeyboard(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //changes value for date picker change
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    //moves variables to segued view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "runningSegue") {
            let svc=segue.destinationViewController as! Running;
            
            svc.name=nameField.text!
            svc.date=dateField.text!
            svc.publish=publishButton.on
        }
    }
    
    //ends editing when touching screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //loads maps
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        currentMap.mapType=MKMapType.Hybrid
        currentMap.showsUserLocation=true
        currentMap.userTrackingMode = MKUserTrackingMode.Follow
        
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .LongStyle, timeStyle: .NoStyle)
        dateField.text="\(timestamp)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}