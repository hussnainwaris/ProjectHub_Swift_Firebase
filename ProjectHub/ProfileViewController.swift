//
//  ProfileViewController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 28/04/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

  

   
    @IBAction func LogOut(sender: AnyObject) {
   
        DataModel.dataModel.baseRef.unauth()
        
        
        performSegueWithIdentifier("Logout", sender: self)

    }
    
    
   

}
