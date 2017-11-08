//
//  ViewController-test.swift
//  Municipality Damage Report
//
//  Created by Michael Papadopoulos on 4/11/15.
//  Copyright © 2015 Razzmatazz. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // all fields form here
    
    @IBOutlet weak var userEmailAddressTextFiel: UITextField!
    
    @IBOutlet weak var userPasswordTextFiel: UITextField!
    
    @IBOutlet weak var userPasswordRepeatTextFiel: UITextField!
    
    @IBOutlet weak var userFirstNameTextFiel: UITextField!
    
    @IBOutlet weak var userLastNameTextFiel: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func cancelButtontapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        // action all request
        
        let userEmail = userEmailAddressTextFiel.text
        
        let userPassword = userPasswordTextFiel.text
        
        let userPasswordRepeat = userPasswordRepeatTextFiel.text
        
        let userFirstName = userFirstNameTextFiel.text
        
        let userLastName = userLastNameTextFiel.text
        
        if( userPassword != userPasswordRepeat)
            
        {
            
            // Display alert message
            
            displayAlertMessage("Passwords do not match")
            
            return
            
        }
        
        if(userEmail!.isEmpty || userPassword!.isEmpty || userFirstName!.isEmpty || userLastName!.isEmpty)
            
        {
            
            // Display an alert message
            
            displayAlertMessage("All fields are required to fill in")
            
            return
            
        }
        
        // Send HTTP POST
        
        let myUrl = NSURL(string: "http://ios:8888/scripts/registerUser.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        
        request.HTTPMethod = "POST";
        
        let postString = "userEmail=\(userEmail)&userFirstName=\(userFirstName!)&userLastName=\(userLastName!)&userPassword=\(userPassword!)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        //Execute transmission
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue())
                
                {
                    
                    // spinningActivity.hide(true)
                    
                    if error != nil {
                        
                        self.displayAlertMessage(error!.localizedDescription)
                        
                        return
                        
                    }
                    
                    do {
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                        if let parseJSON = json {
                            
                            let userId = parseJSON["userId"] as? String
                            
                            if( userId != nil)
                                
                            {
                                
                                let myAlert = UIAlertController(title: "Alert", message: "Registration successful", preferredStyle: UIAlertControllerStyle.Alert);
                                
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(action) in
                                    
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                    
                                }
                                
                                myAlert.addAction(okAction);
                                
                                self.presentViewController(myAlert, animated: true, completion: nil)
                                
                            } else {
                                
                                let errorMessage = parseJSON["message"] as? String
                                
                                if(errorMessage != nil)
                                    
                                {
                                    
                                    self.displayAlertMessage(errorMessage!)
                                    
                                }
                                
                            }
                            
                        }
                        
                    } catch{
                        
                        print(error)
                        
                    }
                    
            }
            
        }).resume()
        
    }
    
    func displayAlertMessage(userMessage:String)
        
    {
        
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
}