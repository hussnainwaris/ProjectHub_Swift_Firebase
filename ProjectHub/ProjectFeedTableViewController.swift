//
//  ProjectFeedTableViewController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 10/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase
class ProjectFeedTableViewController: UITableViewController {

    
    var projects = [YourProjects]()
    var singleProject:YourProjects = YourProjects()
    var progress:MBProgressHUD = MBProgressHUD()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = nil
        
        self.navigationController?.title = "Project Feed"
   
        
        // observeEventType is called whenever anything changes in the Firebase - new projects or Votes
        // It's also called here in viewDidLoad().
        // It's always listening.
        
        
        
        self.showLoadingNotification("Loading Projects")
        DataModel.dataModel.projectRef.observeEventType(.Value,withBlock:  { (snapshot) in
       
            //print(snapshot.value)

            self.projects = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
            
                for snap in snapshots {
                
                    if let postDictionary = snap.value as? Dictionary<String,AnyObject>{
                    
                        let key = snap.key
                        let project = YourProjects(key:key,dictionary: postDictionary)
                        
                       
                        self.projects.insert(project, atIndex: 0)
                    }
                    
                }
            }
            
            //update table view whenever there is new data
           
            self.tableView.reloadData()
            self.hideLoadingNotification()
        })
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let project = projects[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("ProjectCellTableViewCell") as? ProjectCellTableViewCell {
        
            cell.configureCell(project)
            
            return cell
        }else{
        
            return ProjectCellTableViewCell()
        }
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let project = self.projects[indexPath.row]
        self.singleProject = project
        self.performSegueWithIdentifier("showSingleProject", sender: nil)
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSingleProject" {
            
            let controller = segue.destinationViewController as! SingleProjectViewController
            controller.project = self.singleProject
        
            
        }
    }
    
    @IBAction func DownloadButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("showWebView", sender: self)
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
