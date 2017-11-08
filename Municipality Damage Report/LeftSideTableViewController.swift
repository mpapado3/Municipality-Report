//
//  LeftSideTableViewController.swift
//  Municipality Damage Report
//
//  Created by Michael Papadopoulos on 16/12/15.
//  Copyright © 2015 Razzmatazz. All rights reserved.
//

import UIKit

class LeftSideTableViewController: UITableViewController {
    
    var sortedPlaces = [Dictionary<String,String>()]
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var menuItems:[String] = ["All items","Sort Δρόμος","Sort Δέντρο","Sort Φως","Sing out"]
    var menuImages:[String] = ["allitems.png","roads.png","trees.png","lightss.png","logout.png"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "Γειά " + NSUserDefaults.standardUserDefaults().stringForKey("username")!

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return menuItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("leftCell", forIndexPath: indexPath)
        
        myCell.imageView?.image = UIImage(named: menuImages[indexPath.row])
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        return myCell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch(indexPath.row)
        {
        case 0:
            
            for newplace in places {
                if newplace["issue"] == "δρόμος" {
                    
                   // sortedPlaces.append("issueId":newplace["issueId"], "name":newplace["name"], "issue":newplace["issue"], "comment":newplace["comment"], "lat":newplace["lat"], "lon":newplace["lon"], "userID":newplace["userID"], "isitok":newplace["isitok"])
                }
            }
            
            break
        case 1:

            
            break
        case 2:
            
            
            break

        case 3:
            
            
            break
            
        case 4:
            
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let signInPage = mainStoryboard.instantiateViewControllerWithIdentifier("LogInViewController") as UIViewController
            
            let signInNav = UINavigationController(rootViewController: signInPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate
            appDelegate?.window??.rootViewController = signInNav

            break
            
        default:
            print("Not handled")
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
