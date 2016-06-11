//
//  SearchViewController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 18/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit

import Firebase

class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        
        tableView.dataSource = self
        
        searchBar.delegate = self
        
    }
    
    var singleProject = YourProjects()
    
    var searchProjects = [YourProjects]()
    let name = "Hussnain"
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
       
        let search = searchBar.text
       
        let searchArray = search?.componentsSeparatedByString(" ")
        
        
        
        DataModel.dataModel.projectRef.observeEventType(.Value,withBlock:  { (snapshot) in
            
            
            
            
            // print(snapshot.value)
            
            self.searchProjects = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                
                for snap in snapshots {
                    
                    if let postDictionary = snap.value as? Dictionary<String,AnyObject>{
                        
                        
                        let key = snap.key
                        
                        let project = YourProjects(key:key,dictionary: postDictionary)
                        
                        let tags = project.tags
                        
                        var found = false
                        
                        var smallTags:[String] = [String]()
                        
                        for tag in tags {
                            smallTags += [tag.lowercaseString]
                        }
                        
                        for searchItem in searchArray!{
                            
                            if smallTags.contains(searchItem.lowercaseString){
                                found = true
                            }
                        }
                        
                        if found {
                           self.searchProjects.insert(project, atIndex: 0)
                        }
                        
                        
                        
                        
                    }
                    
                }
            }
            
            //update table view whenever there is new data
            
            self.tableView.reloadData()
            
        })

        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchProjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let project = searchProjects[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ProjectCellTableViewCell") as? ProjectCellTableViewCell
        cell!.configureCell(project)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let project = self.searchProjects[indexPath.row]
        self.singleProject = project
        self.performSegueWithIdentifier("SearchProjects", sender: nil)
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SearchProjects" {
            
            let controller = segue.destinationViewController as! SingleProjectViewController
            controller.project = self.singleProject
            
            
        }
    }
}
