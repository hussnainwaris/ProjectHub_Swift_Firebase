//
//  NearbyProjectTableViewCell.swift
//  ProjectHub
//
//  Created by MacBook Pro on 17/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit

class NearbyProjectTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var proDesc: UITextView!
    
    @IBOutlet weak var userText: UILabel!
    
    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var displacementText: UILabel!
    
    var project:YourProjects!
    
    
    func configureCell(project:YourProjects ){
        
        self.project = project
        
        self.titleText.text = project.projectTitle
        
        self.proDesc.text = project.projectDesc
        
        self.emailText.text = project.username+"@live.com"
        
        self.userText.text = project.username
        
        let displace = project.displacement
       
        
        let disp:Int = Int(displace/1000)
        
        self.displacementText.text = ("\(disp) KM")
        //self.votes.text = "1"
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
