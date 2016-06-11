//
//  DataModel.swift
//  ProjectHub
//
//  Created by MacBook Pro on 04/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import Firebase
import Foundation

class DataModel  {
    
    static let dataModel = DataModel()
    
    private var _baseRef = Firebase(url:"\(BASE_URL)")
    
    private var _userRef = Firebase(url:"\(BASE_URL)/users")
    
    private var _projectRef = Firebase(url: "\(BASE_URL)/projects")

    
    var baseRef: Firebase {
        return _baseRef
    }
    
    var userRef: Firebase {
        return _userRef
    }
    
   
    
    
    var CurrentUserRef: Firebase {
    
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(baseRef)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    var projectRef: Firebase {
        return _projectRef
    }
    
    func createNewAccount(uid: String, user: Dictionary<String,AnyObject>) {
        
        // A User is born.
        
        userRef.childByAppendingPath(uid).setValue(user)
    }
    
    
    func createNewProject(project:Dictionary<String,AnyObject>){
        
        let newProject = projectRef.childByAutoId()
        
        // setValue() saves to Firebase.

        newProject.setValue(project)
        
    }
    
    class func login(username:String , password:String)->Bool{
        return false;
    }
    

}