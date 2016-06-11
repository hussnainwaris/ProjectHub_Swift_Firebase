//
//  DropBoxViewController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 13/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//

import UIKit

class DropBoxViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DBRestClientDelegate {

    var dbRestClient:DBRestClient!
    
    var dropboxMetadata:DBMetadata!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var bbiConnect: UIBarButtonItem!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        
        progressBar.hidden = true
        
        if DBSession.sharedSession().isLinked(){
            initDropboxRestClient()
            bbiConnect.title = "Disconnect"
            //performSegueWithIdentifier("showFeed", sender: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DropBoxViewController.handleDidLinkNotification(_:)), name: "didLinkToDropboxAccountNotification", object: nil)
    
    }
    
    func restClient(client: DBRestClient!, loadedMetadata metadata: DBMetadata!) {
    
        dropboxMetadata = metadata
        tableView.reloadData()
    }
    
    func restClient(client: DBRestClient!, loadMetadataFailedWithError error: NSError!) {
        print(error.description)
    }
    
    func initDropboxRestClient(){
        
        dbRestClient = DBRestClient(session: DBSession.sharedSession())
        dbRestClient.delegate = self
        dbRestClient.loadMetadata("/")

    }
  
   
    func handleDidLinkNotification(notification: NSNotification) {
        
        initDropboxRestClient()
        bbiConnect.title = "Disconnect"
        //
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func connectToDropbox(sender: AnyObject) {
        
        if !DBSession.sharedSession().isLinked() {
            DBSession.sharedSession().linkFromController(self)
        }
        else {
            DBSession.sharedSession().unlinkAll()
            bbiConnect.title = "Connect"
            dbRestClient = nil
        }
    }
    
    
    @IBAction func performAction(sender: AnyObject) {
        if !DBSession.sharedSession().isLinked(){
        
        print("Not connected to Dropbox")
        return
        }
        
        let actionSheet = UIAlertController(title: "Upload File", message: "Select a file to upload", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        
        let textAlert = UIAlertAction(title: "Text File", style: UIAlertActionStyle.Default){(action) in
            
            let uploadFilename = "testtext.txt"
        
            let sourcePath = NSBundle.mainBundle().pathForResource("testtext", ofType: "txt")
            let destinationPath = "/"
            
            self.showProgressBar()
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
        }
        
        let imageAlert = UIAlertAction(title:"Image File", style: UIAlertActionStyle.Default){(action) in
            
            let uploadFilename = "nature.jpg"
            let sourcePath = NSBundle.mainBundle().pathForResource("nature", ofType: "jpg")
            let destinationPath = "/"
            self.showProgressBar()
            
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
        }
        
        let pdfAlert = UIAlertAction(title:"PDF File", style: UIAlertActionStyle.Default){(action) in
            
            let uploadFilename = "Husnain-CV.pdf"
            let sourcePath = NSBundle.mainBundle().pathForResource("nature", ofType: "pdf")
            let destinationPath = "/"
            self.showProgressBar()
            
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) in
            
        }
        
        actionSheet.addAction(textAlert)
        actionSheet.addAction(imageAlert)
        actionSheet.addAction(pdfAlert)
        actionSheet.addAction(cancel)
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
        print("The file has been uploaded.")
        print(metadata.path)
        progressBar.hidden = true
        
        dbRestClient.loadMetadata("/")

        
    }
    
    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        print("File upload failed.")
        print(error.description)
        progressBar.hidden = true
    }
    
    @IBAction func reloadFiles(sender: AnyObject) {
        
        dbRestClient.loadMetadata("/")

    }
    
    func restClient(client: DBRestClient!, uploadProgress progress: CGFloat, forFile destPath: String!, from srcPath: String!) {
        progressBar.progress = Float(progress)
    }
    
    func showProgressBar() {
        progressBar.progress = 0.0
        progressBar.hidden = false
    }
    
    // MARK: UITableview method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let metadata = dropboxMetadata {
            return metadata.contents.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedFile: DBMetadata = dropboxMetadata.contents[indexPath.row] as! DBMetadata
        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        showProgressBar()
        
        dbRestClient.loadFile(selectedFile.path, intoPath: documentsDirectoryPath as String)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellFile", forIndexPath: indexPath) as UITableViewCell
        
        let currentFile: DBMetadata = dropboxMetadata.contents[indexPath.row] as! DBMetadata
        cell.textLabel?.text = currentFile.filename
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func restClient(client: DBRestClient!, loadedFile destPath: String!, contentType: String!, metadata: DBMetadata!) {
    print("The file \(metadata.filename) was downloaded. Content type: \(contentType)")
    progressBar.hidden = true
    }

    

    func restClient(client: DBRestClient!, loadProgress progress: CGFloat, forFile destPath: String!) {
        progressBar.progress = Float(progress)
    }
    
    
    
    func restClient(client: DBRestClient!, loadFileFailedWithError error: NSError!) {
        print(error.description)
        progressBar.hidden = true
    }
}
