//
//  WebViewController.swift
//  ProjectHub
//
//  Created by MacBook Pro on 16/05/2016.
//  Copyright © 2016 apphouse. All rights reserved.
//
import MBProgressHUD
import UIKit

class WebViewController: UIViewController , UIWebViewDelegate {

    var progress = MBProgressHUD()
    
    var webProject:YourProjects = YourProjects()
    
    @IBOutlet weak var webView: UIWebView!
    
    var link = "";
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.webView.delegate = self
        link = webProject.link
        print(link)
        let url = NSURL (string: link)
        let requestObj = NSURLRequest(URL: url!);
        showLoadingNotification("Loading Page...")
        self.webView.loadRequest(requestObj)
  
        self.tabBarController?.hidesBottomBarWhenPushed = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.hideLoadingNotification()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
