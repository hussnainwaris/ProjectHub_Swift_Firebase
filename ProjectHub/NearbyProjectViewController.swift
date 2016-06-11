//
//  NearbyProjectViewController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 17/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import MBProgressHUD

class NearbyProjectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var currentUsername = ""
    
    var userProjects = [YourProjects]()
    
    var nearby = YourProjects()

    var singleProject:YourProjects = YourProjects()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.navigationController?.title = "Nearby Projects"
        
        DataModel.dataModel.CurrentUserRef.observeEventType(FEventType.Value, withBlock:  { (snapshot) in
  
            let currentUser = snapshot.value.objectForKey("username") as! String
            
            let userLongitude = snapshot.value.objectForKey("userLongitude") as! Double
            
            let userLatitude = snapshot.value.objectForKey("userLatitude") as! Double
            
            
            
            print("UserLatitude and longitude:\(userLatitude) \(userLongitude)")
   
            print("Username:\(currentUser)")
            self.currentUsername = currentUser
            
            DataModel.dataModel.projectRef.observeEventType(.Value,withBlock:  { (snapshot) in
                
                
                // print(snapshot.value)
                
                self.userProjects = []
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                    
                    for snap in snapshots {
                        
                        if let postDictionary = snap.value as? Dictionary<String,AnyObject>{
                            
                            
                            let key = snap.key
                            
                            self.showLoadingNotification("Loading nearby projects")
                            let project = YourProjects(key:key,dictionary: postDictionary)
                            let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
                            let projectLocation = CLLocation(latitude: project.projectLatitude,longitude:project.projectLongitude)
                            let displace = userLocation.distanceFromLocation(projectLocation)
                            print("Project Latitude and longitude:\(project.projectLatitude) \(project.projectLongitude) \(displace)")
                            project.displacement = displace
                            self.userProjects.insert(project, atIndex: 0)
                            self.hideLoadingNotification()
                            
                        }
                        //using closure
                        self.userProjects =  self.userProjects.sort(self.projectSorter)
                        
                    }
                }
                
                //update table view whenever there is new data
                

                self.tableview.reloadData()
                
            })
            
        })
        
        
        
        
        // Do any additional setup after loading the view.
    }

    func projectSorter(project1:YourProjects , project2:YourProjects)->Bool{
        return (project1.displacement < project2.displacement)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProjects.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let project = userProjects[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("NearbyCell") as? NearbyProjectTableViewCell{
            
            
            cell.configureCell(project)
            
            return cell
            
        }else{
            return NearbyProjectTableViewCell()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let project = self.userProjects[indexPath.row]
        self.singleProject = project
        self.performSegueWithIdentifier("NearbyProject", sender: nil)
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "NearbyProject" {
            
            let controller = segue.destinationViewController as! SingleProjectViewController
            controller.project = self.singleProject
            
            
        }
    }
    var progress = MBProgressHUD()
    
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
