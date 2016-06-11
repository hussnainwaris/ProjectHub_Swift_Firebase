//
//  Signup.swift
//  ProjectHub
//
//  Created by MacBook Pro on 27/04/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import MapKit



class SignupViewController: UIViewController,UITextViewDelegate,CLLocationManagerDelegate {

    var progress = MBProgressHUD()

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var locationManager = CLLocationManager()
    
    var long:Double = Double()
    
    var lati:Double = Double()

    
    
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

    }

    
    @IBAction func signUpButton(sender: AnyObject) {
       
        let username = nameTextField.text
        
        let password = passwordTextField.text
        
        let email = emailTextField.text
        
        let confirmPass = ConfirmPassword.text
        
        long = (locationManager.location?.coordinate.longitude)!
        
        lati = (locationManager.location?.coordinate.latitude)!
        
        
        if username != "" && email != "" && password != "" && confirmPass != "" {
            
            
            if password == confirmPass {
                
                self.showLoadingNotification("Signing up user")


            //setup email and password for new user
            
            DataModel.dataModel.baseRef.createUser(email, password: password, withValueCompletionBlock: { (error, result) in
                
                if error != nil {
                    
                    // There was a problem.
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                    self.hideLoadingNotification()
                } else {
                    
                    let latitude = self.lati
                    let longitude = self.long
                    
                    //login user with auth user
                    DataModel.dataModel.baseRef.authUser(email, password: password, withCompletionBlock: { (error, authData) in
                        
                        
                        let user:NSDictionary = ["provider" : authData.provider,"email":email!,"username":username!,"userLatitude":latitude,"userLongitude":longitude]
                        
                    
                        
                        DataModel.dataModel.createNewAccount(authData.uid, user: user as! Dictionary<String, AnyObject>)
                        self.hideLoadingNotification()
                        
                    })
                    
                    
                    //storing uid for future use
                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    
                    self.performSegueWithIdentifier("ShowLogin", sender: self)
                    
                    
                    
                }

            })

            }else {
            
                signupErrorAlert("Oopd!", message: "Entered Password not matched")
                hideLoadingNotification()
                
            }
        }else{
            
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and a username.")

            
            //let activity = MBProgressHUD.showHUDAddedTo(self.view, animated:true)
            
           // activity.labelText = "password not matching"
        
        }
        
       
    }
    
    
    
    
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textfield:UITextField!)-> Bool{
        
        textfield.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
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
