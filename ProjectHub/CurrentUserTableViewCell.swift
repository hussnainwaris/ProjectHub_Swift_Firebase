//
//  CurrentUserTableViewCell.swift
//  ProjectHub
//
//  Created by MacBook Pro on 11/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit
import Firebase

class CurrentUserTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var proDesc: UITextView!
    
    var project:YourProjects!
    
    
    
    func configureCell(project:YourProjects){
    
        self.project = project
        
        self.titleText.text = project.projectTitle
        
        self.proDesc.text = project.projectDesc
        
        //self.votes.text = "1"
        
        
    }
}
