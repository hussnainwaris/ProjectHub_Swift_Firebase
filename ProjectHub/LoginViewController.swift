//
//  ViewController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 13/04/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

let BASE_URL = "https://projecthubsc.firebaseio.com"

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var progress:MBProgressHUD = MBProgressHUD()
    
    @IBAction func loginButton(sender: UIButton) {
        
        let email = usernameTextField.text
        
        let password = passwordTextField.text
        
        if email != "" && password != "" {
            self.showLoadingNotification("")
            DataModel.dataModel.baseRef.authUser(email, password: password, withCompletionBlock: { (error, authData) in
                
                if error != nil {
                    print(error)
                    self.loginErrorAlert("Oops!", message: "Check your username and password.")
                    self.hideLoadingNotification()

                }else{
                
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    // Enter the app!
                    
                 
                    let ref = DataModel.dataModel.CurrentUserRef
                    
                    ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        
                        //let check = snapshot.valueForKey("checkCompleteness") as! String
                        

                       
                            self.hideLoadingNotification()
                            self.performSegueWithIdentifier("LoginToFeed", sender: nil)
                            
                        
                        
                        
                    })
                    
                
                
                }
            })
            
        }else{
            self.hideLoadingNotification()
            loginErrorAlert("Oops!", message: "Don't forget to enter your email and password.")

        
        }
    
    }
    
    func loginErrorAlert(title: String, message: String) {
        
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //will be called when view is appeared on screen
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If we have the uid stored, the user is already logger in - no need to sign in again!
        //showLoadingNotification("")
    if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataModel.dataModel.CurrentUserRef.authData != nil {
            self.performSegueWithIdentifier("LoginToFeed", sender: nil)
//        hideLoadingNotification()
        }
    }

   
    func textFieldShouldReturn(textfield:UITextField)-> Bool{
        
        textfield.resignFirstResponder()
        return false
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

