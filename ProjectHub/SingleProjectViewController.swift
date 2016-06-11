//
//  SingleProjectViewController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 17/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit

import Firebase

class SingleProjectViewController: UIViewController {

    var project:YourProjects = YourProjects()
    

    
    @IBOutlet weak var tagField: UILabel!
    
    
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var projectTitle: UILabel!
    
    @IBOutlet weak var userText: UILabel!
    
    @IBOutlet weak var projectDesc: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tags = project.tags
        
        var temp = ""
        
        for tag in tags{
        
            temp += tag
            temp += ", "
            
        }
        
        self.tagField.text = temp
        self.projectTitle.text = project.projectTitle
        self.userText.text = project.username
        self.emailField.text = project.username + "@live.com"
        self.projectDesc.text = project.projectDesc
        // Do any additional setup after loading the view.
    }

    
    @IBAction func downloadProject(sender: AnyObject) {
        
        performSegueWithIdentifier("showWebView", sender:nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWebView"{
            
            let controller = segue.destinationViewController as! WebViewController
            
            controller.webProject = project
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
