//
//  ProjectCellTableViewCell.swift
//  ProjectHub
//
//  Created by MacBook Pro on 10/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import Firebase

class ProjectCellTableViewCell: UITableViewCell {


    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var userText: UILabel!
    
    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var proDescription: UITextView!
    
    
    
    var project:YourProjects!
    
    var voteRef: Firebase!

    func configureCell(project:YourProjects){
    
        self.project = project
        
        self.titleText.text = project.projectTitle
        
        self.emailText.text = (project.username+"@live.com")
        
        self.proDescription.text = project.projectDesc
        
        self.userText.text = project.username
        
        
        
       // self.voteLabel.text = "Total Votes:\(project.projectVotes)"
        
        voteRef = DataModel.dataModel.CurrentUserRef.childByAppendingPath("votes").childByAppendingPath(project.projectKey)
        
        
    }
}
