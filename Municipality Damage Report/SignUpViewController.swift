//
//  SignUpViewController.swift
//  Municipality Damage Report
//
//  Created by Michael Papadopoulos on 3/11/15.
//  Copyright © 2015 Razzmatazz. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    func displayAlert (title:String, message:String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }


    @IBAction func LogInButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        
        let username = usernameText.text
        let password = passwordText.text
        
        if (username == "" || password == "")  {
            // display an allert
            displayAlert("Error Details", message: "Please enter username and password")

        }
        
        // Send HTTP POST
        
        let myURL = NSURL(string: "http://www.razzmatazz.gr/municipapp/scripts/registerUser.php")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        
        let postString = "username=\(username!)&password=\(password!)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue())
                {
                    if error != nil {
                        self.displayAlert("Error", message: (error?.localizedDescription)!)
                        return
                    }
                    
                    do {
                        
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                    if let parseJSON = json {
                        var userId = parseJSON["userId"] as? String

                        print(userId)
                        
                        if userId != nil {
                            
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["username"], forKey: "username")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["userId"], forKey: "userId")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            /*
                            self.dismissViewControllerAnimated(true, completion: nil)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewControllerWithIdentifier("initialStoryBoard") as! UIViewController
                            self.presentViewController(vc, animated: true, completion: nil)
                            */
                            
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            
                            appDelegate.buildNavigationDrawer()
                            
                        } else {
                            let errorMessage = parseJSON["message"] as? String
                            if errorMessage != nil {
                                self.displayAlert("Error", message: (errorMessage!))
                            }
                        }
                    }
                    } catch {
                        print(error)
                    }
                    
                    
            }
            
        }
            task.resume()
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
