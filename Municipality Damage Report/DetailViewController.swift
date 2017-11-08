//
//  DetailViewController.swift
//  Municipality Damage Report
//
//  Created by Michael Papadopoulos on 24/10/15.
//  Copyright © 2015 Razzmatazz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage

        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        myImageUploadRequest()
    }
    
    func displayAlert (title:String, message:String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }


    
    @IBOutlet weak var streetLabel: UILabel!
    
    @IBOutlet weak var issueLabel: UILabel!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBAction func saveButton(sender: AnyObject) {
        
        let commentUpdate = commentText.text!
        let myURL = NSURL(string: "http://www.razzmatazz.gr/municipapp/scripts/updateIssue.php")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        
        let currentIssueId = places[activePlace]["issueId"]!
        
        let postString = "id=\(currentIssueId)&comments=\(commentUpdate)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue())
                {
                    if error != nil {
                        //    self.displayAlert("Error", message: (error?.localizedDescription)!)
                        return
                    }
                    
                    do {
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        
                        if let parseJSON = json {
                            var issueId = parseJSON["Id"] as? String
                            
                            
                            if issueId != nil {
                                /* self.dismissViewControllerAnimated(true, completion: nil)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewControllerWithIdentifier("initialStoryBoard") as! UIViewController
                                self.presentViewController(vc, animated: true, completion: nil) */
                            } else {
                                let errorMessage = parseJSON["message"] as? String
                                if errorMessage != nil {
                                    //   self.displayAlert("Succeed", message: (errorMessage!))
                                }
                            }
                        }
                    } catch {
                        
                    }
                    
                    
            }
            
        }
        task.resume()

        
        places[activePlace]["comment"] = commentText.text
        
    }
    
    @IBAction func imageSelectionButton(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.streetLabel.text = places[activePlace]["name"]
        
        self.issueLabel.text = places[activePlace]["issue"]
        
        if self.commentText.text != nil {
            self.commentText.text = places[activePlace]["comment"]
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentIssueID = places[activePlace]["issueId"]!
        
        let userId:String? = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        if (imageView.image == nil) {
            let imageURL = NSURL(string:"http://www.razzmatazz.gr/municipapp/issue-pictures/\(userId!)/issueWithID\(currentIssueID).jpg")
            
            print(imageURL)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let imageData = NSData(contentsOfURL: imageURL!)
                
                if imageData != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageView.image = UIImage(data: imageData!)
                    })
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textfieldShouldReturn(textField: UITextField!) -> Bool {
        
        commentText.resignFirstResponder()
        return true
        
    }
    
    func myImageUploadRequest()
    {
        let myUrl = NSURL(string: "http://www.razzmatazz.gr/municipapp/scripts/imageUpload.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let userId:String? = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        let param = [
            "userId" : userId!
        ]
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue())
                {
                   // MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
            if error != nil {
                // Display an alert message
                return
            }
            
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                dispatch_async(dispatch_get_main_queue())
                    {
                        
                        if let parseJSON = json {
                            // let userId = parseJSON["userId"] as? String
                            
                            // Display an alert message
                            let userMessage = parseJSON["message"] as? String
                            self.displayAlert("Image", message: userMessage!)
                        } else {
                            // Display an alert message
                            let userMessage = "Could not upload image at this time"
                            self.displayAlert("image", message: userMessage)
                        }
                }
            } catch
            {
                print(error)
            }
            
        }).resume()
        
        
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        let currentIssueId = places[activePlace]["issueId"]!
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "issueWithID\(currentIssueId).jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        // Create and return a unique string.
        return "Boundary-\(NSUUID().UUIDString)"
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

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}
