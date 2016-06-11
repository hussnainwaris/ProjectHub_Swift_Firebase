//
//  AddProject.swift
//  ProjectHub
//
//  Created by MacBook Pro on 09/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import MBProgressHUD
class AddProjectViewController: UIViewController,CLLocationManagerDelegate{

    
    @IBOutlet weak var projectTitle: UITextField!
    
    let locationManager = CLLocationManager()
    
    var progress = MBProgressHUD()
    
    
    @IBOutlet weak var projectLink: UITextField!
    
    var currentUsername = ""
    
    var long:Double = Double()
    
    var lati:Double = Double()
    
    
    @IBOutlet weak var tags: UITextField!

    
    
    @IBOutlet weak var projectDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        /*      if CLLocationManager.locationServicesEnabled() {
         print("enable")
         }*/
        
         long = (locationManager.location?.coordinate.longitude)!

         lati = (locationManager.location?.coordinate.latitude)!

        
        DataModel.dataModel.CurrentUserRef.observeEventType(FEventType.Value, withBlock:  { (snapshot) in
            
        
            print(snapshot.value)
            
            let currentUser = snapshot.value.objectForKey("username") as! String
                print("Username:\(currentUser)")
                self.currentUsername = currentUser
            
            
        })
        
        
        
    }
    
    
    
    @IBAction func SaveNewProject(sender: AnyObject) {
       
        let latitude:Double = lati
        
        let longitude:Double = long
        
        
        let projectDesc = projectDescription.text
        
        let proTitle = projectTitle.text
        
        let proLink = projectLink.text
        
        let tag = tags.text
        
        let tagArray = tag?.componentsSeparatedByString(",")
        
        
        if projectDesc != "" && proTitle != "" && proLink != "" {
        
            showLoadingNotification("")
            let newProject:Dictionary<String,AnyObject> = ["title":proTitle!,"description":projectDesc!,"author":currentUsername,"link":proLink!,"projectLatitude":latitude,"projectLongitude":longitude,"tags":tagArray!]
            
            DataModel.dataModel.createNewProject(newProject)
            
            hideLoadingNotification()
            self.performSegueWithIdentifier("GoToProjectFeed", sender: nil)
        }
        
    }
    
    
    func showLoadingNotification(message:String){
        
        progress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progress.mode = MBProgressHUDMode.Indeterminate
        progress.labelText = message
        progress.removeFromSuperViewOnHide = true
        progress.show(true)
        
    }
    func hideLoadingNotification(){
        progress.hide(true)
    }
    
    func showShortToast(message:String){
        
        progress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progress.mode = MBProgressHUDMode.Text
        progress.labelText = message
        progress.removeFromSuperViewOnHide = true
        
        progress.hide(true, afterDelay: 1)
    }

    
    
    
    
    
    
    
}
