//
//  ProjectFeedTableViewController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 10/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import Firebase
class ProjectFeedTableViewController: UITableViewController {

    var projects = [YourProjects]()
    var link = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "Project Feed"
        //self.navigationItem.rightBarButtonItem ;
        // observeEventType is called whenever anything changes in the Firebase - new projects or Votes
        // It's also called here in viewDidLoad().
        // It's always listening.
        
        
        
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
        
        let row = indexPath.row
        let project = projects[row]
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWebView" {
            var webController = segue.destinationViewController as! WebViewController
            
            webController.link =
        }
    }
    
    @IBAction func DownloadButtonPressed(sender: AnyObject) {
        
    }
    

}
