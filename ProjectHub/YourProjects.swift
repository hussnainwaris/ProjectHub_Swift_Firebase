//
//  ProjectData.swift
//  ProjectHub
//
//  Created by MacBook Pro on 09/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import Foundation
import Firebase

class YourProjects{
    

    private var _projectref:Firebase!
    
    private var _projectKey:String!
    
    private var _projectTitle:String!
    
    private var _projectDesc:String!
    
    //private var _projectVotes:Int!
    
    private var _username:String!
    
    private var _link:String!
    
    //private  var _votingPerson:Int!
    
    private var _projectLatitude:Double!
    
    private var _projectLongitude:Double!
    
    private var _tags:[String]!
    
    
   // private var _displacement:Double!
    
    var displacement:Double = 0;
    
    //var link = "http://dropbox.com";
    
    //Getter methods
    
   /* var displacement:Double{
    
        return _displacement
    }*/
    
    var tags:[String]{
    return _tags
    }
    
    var projectLongitude:Double{
    return _projectLongitude
    }
    
    var projectLatitude:Double{
        return _projectLatitude
    }
    
   /* var votingPerson:Int{
        return _votingPerson
    }*/
    
    var projectKey:String{
    
        return _projectKey
    }
    
    var projectDesc:String{
    
        return _projectDesc
    }
    
   /* var projectVotes:Int{
    
        return _projectVotes
    }*/
    
    var username:String{
    
        return _username
    }
    
    var link:String{
    
        return _link
    }
    
    var projectTitle:String{
    
        return _projectTitle
    }
    
    
    
    init (key:String,dictionary:Dictionary<String,AnyObject>){
    
        self._projectKey = key
        
        //for rating
      /*  if let votes = dictionary["votes"] as? Int{
        self._projectVotes = votes
        }
        */
        /*if let displace = dictionary["displacement"] as? Double{
        
            self._displacement = displace
        }*/
        
        
        if let tag = dictionary["tags"] as? [String]{
            self._tags = tag
        }
        
        
        if let description = dictionary["description"] as? String{
        self._projectDesc = description
        }
        
        if let user = dictionary["author"] as? String{
        self._username = user
        }
        
        if let title = dictionary["title"] as? String{
        self._projectTitle = title
        }
        
        if let link = dictionary["link"] as? String{
        self._link = link
        }
        
        /*if let votperson = dictionary["votingperson"] as? Int{
        self._votingPerson = votperson
        }*/
        
        if let prolati = dictionary["projectLatitude"] as? Double{
        self._projectLatitude = prolati
        }
        
        if let prolong = dictionary["projectLongitude"] as? Double{
            self._projectLongitude = prolong
        }
        
        self._projectref = DataModel.dataModel.projectRef.childByAppendingPath(self._projectKey)

        
        
    }
    init(){}
    
    
}