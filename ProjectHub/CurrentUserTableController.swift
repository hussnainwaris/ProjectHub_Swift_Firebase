//
//  CurrentUserTableController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 12/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import Firebase

class CurrentUserTableController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var currentUsername = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    var deleteProject = YourProjects()
    
    var singleProject = YourProjects()
    
    var userProjects = [YourProjects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        navigationItem.leftBarButtonItem = editButtonItem()
        self.navigationController?.title = "My Projects"
        
        DataModel.dataModel.CurrentUserRef.observeEventType(FEventType.Value, withBlock:  { (snapshot) in
            
            let currentUser = snapshot.value.objectForKey("username") as! String
            
            print("Username:\(currentUser)")
            
            self.currentUsername = currentUser
            
            DataModel.dataModel.projectRef
            
            DataModel.dataModel.projectRef.observeEventType(.Value,withBlock:  { (snapshot) in
                
                
                
                
                // print(snapshot.value)
                
                self.userProjects = []
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                    
                    for snap in snapshots {
                        
                        if let postDictionary = snap.value as? Dictionary<String,AnyObject>{
                            
                            
                            let key = snap.key
                            
                            let project = YourProjects(key:key,dictionary: postDictionary)
                            
                            print(project.username + " == " + self.currentUsername)
                            
                            if project.username == self.currentUsername {
                                self.userProjects.insert(project, atIndex: 0)
                            }
                            
                            //print(project.username)
                            
                           // self.userProjects.insert(project, atIndex: 0)
                            
                        }
                        
                    }
                }
                
                //update table view whenever there is new data
                
                self.tableView.reloadData()
                
            })
            
        })
        
        
      
        
        
        
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userProjects.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let project = userProjects[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("CurrentUser") as? CurrentUserTableViewCell{
            
            cell.configureCell(project)
            
            return cell
            
        }else{
            return CurrentUserTableViewCell()
        }
    }
   
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let project = self.userProjects[indexPath.row]
        self.singleProject = project
        self.performSegueWithIdentifier("CurrentProject", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CurrentProject" {
            
            let controller = segue.destinationViewController as! SingleProjectViewController
            controller.project = self.singleProject
            
        }
    }

    
    // Override to support conditional editing of the table view.
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            deleteProject = userProjects.removeAtIndex(indexPath.row)
            
            
            let key = deleteProject.projectKey
            print("project key"+key)
            
            let ref = DataModel.dataModel.projectRef
            
            let deleteRef = Firebase(url: "\(ref)/\(key)")
            
            deleteRef.removeValue()
            
           /* deleteRef.queryOrderedByKey().valueForKey(key)!.observeSingleEventOfType(.Value, withBlock: { snapshot in
                print(snapshot)
            })*/
            
            

            
            
            //print(ref)
            
          //  ref.removeAllObservers()
            //DataModel.dataModel.projectRef.
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
   
    @IBAction func Logout(sender: AnyObject) {
        
        DataModel.dataModel.CurrentUserRef.unauth()
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        self.performSegueWithIdentifier("Logout", sender: nil)
    }
    
    
}
