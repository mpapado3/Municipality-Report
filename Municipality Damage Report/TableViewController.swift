//
//  TableViewController.swift
//  Memorable places
//
//  Created by Michael Papadopoulos on 7/10/15.
//  Copyright © 2015 Razzmatazz. All rights reserved.
//

import UIKit
import CoreData

var places = [Dictionary<String,String>()]

var activePlace = -1

var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let context:NSManagedObjectContext = appDel.managedObjectContext
var newIssue = NSEntityDescription.insertNewObjectForEntityForName("IssueData", inManagedObjectContext: context)

let request = NSFetchRequest(entityName: "IssueData")

// Bubble Sort for issue sorting
func sortList() {
    var i:Int = 0, k:Int = 0, n:Int = places.count
    var placeOne:String = "", placeTwo:String = ""
    var temp = Dictionary<String,String>()
    for (i = 0; i<n-1; i++) {
        for (k = 0; k<n-i-1; k++) {
            
            placeOne = places[k]["issue"]! as String
            placeTwo = places[k+1]["issue"]! as String
            if placeOne > placeTwo {
                temp = places[k+1]
                places[k+1] = places[k]
                places[k] = temp
            }
        }
        
    }

    NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
}

class TableViewController: UITableViewController {
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        
        let url = NSURL(string: "http://www.razzmatazz.gr/municipapp/scripts/getIssueList.php")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            
            dispatch_async(dispatch_get_main_queue())
                {

            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            if let urlContent = data {
                do {
                    let place = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    
                    
                    var placeName = ""
                    var placeUserID = ""
                    var placeComment = ""
                    var placeIssue = ""
                    var placeIssueID = ""
                    var placeLat = ""
                    var placeLon = ""
                    var placeIsItOk = ""
                    
                    places.removeAll(keepCapacity: false)
                    
                    let currentUserId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
                    
                    for newplace in place as! [AnyObject] {
                        if let name = newplace["name"] as? String {
                            placeName = name
                        }
                        if let userID = newplace["UserID"] as? String {
                            placeUserID = userID
                            
                        }
                        if let comment = newplace["comment"] as? String {
                            placeComment = comment
                            
                        }
                        if let issue = newplace["issue"] as? String {
                            placeIssue = issue
                            
                        }
                        if let issueId = newplace["issueId"] as? String {
                            placeIssueID = issueId
                            
                        }
                        if let lat = newplace["lat"] as? String {
                            placeLat = lat
                            
                        }
                        if let lon = newplace["lon"] as? String {
                            placeLon = lon
                            
                        }
                        if let IsItOk = newplace["IsItOk"] as? String {
                            placeIsItOk = IsItOk
                            
                        }
                        
                        if  placeUserID == currentUserId {
                        
                            places.append(["issueId":placeIssueID, "name":placeName, "issue":placeIssue, "comment":placeComment, "lat":placeLat, "lon":placeLon, "userID":placeUserID, "isitok":placeIsItOk])
                        }
                        
                    }
                   
                    if places.count == 0 {
                        
                        places.append(["issueId":"0", "name":"Δημαρχείο", "issue":"Δρόμος", "comment":"Εδώ υπάρχουν τα σχόλια", "lat":"38.139127", "lon":"23.863930", "userID":placeUserID, "isitok":"false"])
                        self.tableView.reloadData()
                        
                    } else {
                        
                        places.removeLast()
                        self.tableView.reloadData()
                    }
                    
                    
                } catch {
                    print("Json Serialization error")
                }
            }
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }
        }
        
        task.resume()
        
        places = NSUserDefaults.standardUserDefaults().objectForKey("places") as! [Dictionary]
        
        self.tableView.reloadData()
        
        self.refresher.endRefreshing()

        
    }
    
    @IBAction func leftSideButton(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
       // if NSUserDefaults.standardUserDefaults().objectForKey("places") != nil {
            
           let url = NSURL(string: "http://www.razzmatazz.gr/municipapp/scripts/getIssueList.php")!
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                
                dispatch_async(dispatch_get_main_queue())
                    {

                
                activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                
                let currentUserId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
                
                if let urlContent = data {
                    do {
                        let place = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                        
                        
                        var placeName = ""
                        var placeUserID = ""
                        var placeComment = ""
                        var placeIssue = ""
                        var placeIssueID = ""
                        var placeLat = ""
                        var placeLon = ""
                        var placeIsItOk = ""
                        
                        // places.removeAtIndex(0)
                        
                        places.removeAll(keepCapacity: false)
                        
                        for newplace in place as! [AnyObject] {
                            if let name = newplace["name"] as? String {
                                placeName = name
                            }
                            if let userID = newplace["UserID"] as? String {
                                placeUserID = userID
                                
                            }
                            if let comment = newplace["comment"] as? String {
                                placeComment = comment
                                
                            }
                            if let issue = newplace["issue"] as? String {
                                placeIssue = issue
                                
                            }
                            if let issueId = newplace["issueId"] as? String {
                                placeIssueID = issueId
                                
                            }
                            if let lat = newplace["lat"] as? String {
                                placeLat = lat
                                
                            }
                            if let lon = newplace["lon"] as? String {
                                placeLon = lon
                                
                            }
                            if let IsItOk = newplace["IsItOk"] as? String {
                                placeIsItOk = IsItOk
                                
                            }
                            
                              if  placeUserID == currentUserId {
                            
                            places.append(["issueId":placeIssueID, "name":placeName, "issue":placeIssue, "comment":placeComment, "lat":placeLat, "lon":placeLon, "userID":placeUserID, "isitok":placeIsItOk])
                            }
                                                        
                        }
                        
                        if places.count == 0 {
                        
                            
                            places.append(["issueId":"0", "name":"Δημαρχείο", "issue":"Δρόμος", "comment":"Εδώ υπάρχουν τα σχόλια", "lat":"38.139127", "lon":"23.863930", "userID":placeUserID, "isitok":"false"])
                            self.tableView.reloadData()
                            
                        } else {
                            
                        places.removeLast()
                        self.tableView.reloadData()
                            
                        }
                    } catch {
                        print("Json Serialization error")
                    }
                }
                
                activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
            }
        }
        
            task.resume()
            
           // places = NSUserDefaults.standardUserDefaults().objectForKey("places") as! [Dictionary]
    

      /*  if places.count == 1 {
            
            places.removeAtIndex(0)
            places.append(["issueId":"0", "name":"Δημαρχείο", "issue":"Δρόμος", "comment":"Εδώ υπάρχουν τα σχόλια", "lat":"38.139127", "lon":"23.863930", "userID":"11", "isitok":"false"])
        } */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return places.count
    

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

             let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
                
                cell.textLabel!.text = places[indexPath.row]["name"]
                cell.detailTextLabel?.text = places[indexPath.row]["issue"]
                
                return cell

        
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activePlace = indexPath.row
        
        return indexPath
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "newPlace" {
            
            activePlace = -1
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let myURL = NSURL(string: "http://www.razzmatazz.gr/municipapp/scripts/deleteIssue.php")
            let request = NSMutableURLRequest(URL: myURL!)
            request.HTTPMethod = "POST"
            
            let currentIssueId = places[indexPath.row]["issueId"]!
            
            print(places[indexPath.row]["issueId"]!)
            
            let postString = "id=\(currentIssueId)"
            
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
            
            places.removeAtIndex(indexPath.row)
            
            NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")
            
            tableView.reloadData()
        }
        
    }
    
    


    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
