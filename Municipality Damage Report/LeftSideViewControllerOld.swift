//
//  LeftSideViewController.swift
//  Municipality Damage Report
//
//  Created by Michael Papadopoulos on 7/12/15.
//  Copyright © 2015 Razzmatazz. All rights reserved.
//

import UIKit

class LeftSideViewControllerOld: UIViewController {

    @IBAction func SortButton(sender: AnyObject) {
        
        sortList()
    }
    @IBAction func logoutButton(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signInPage = mainStoryboard.instantiateViewControllerWithIdentifier("LogInViewController") as UIViewController
        
        let signInNav = UINavigationController(rootViewController: signInPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = signInNav 
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
