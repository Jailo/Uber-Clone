//
//  DriverViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Jaiela London on 10/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class DriverViewController: UITableViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var requestUsernames = [String]()
    
    var requestLocations = [CLLocationCoordinate2D]()
    
    var userLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "driverLogoutSegue" {
            
            locationManager.stopUpdatingLocation()
            
            PFUser.logOut()
            
            self.navigationController?.isNavigationBarHidden = true
            
        } else if segue.identifier == "showRiderLocationViewController" {
            
        
            if let destination = segue.destination as? RiderLocationViewController {
                
                if let row = tableView.indexPathForSelectedRow?.row {
                    
                    destination.requestLocation = requestLocations[row]
                    
                    destination.requestUsername = requestUsernames[row]
                }
                
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = manager.location?.coordinate {
            
            userLocation = location
            
            let query = PFQuery(className: "RiderRequest")
            
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: location.latitude, longitude: location.longitude))
        
            query.limit = 10
            
            query.findObjectsInBackground(block: { (object, error) in
                
                if let riderRequests = object {
                    
                    self.requestUsernames.removeAll()
                    self.requestLocations.removeAll()
                    
                    for riderRequest in riderRequests {
                        
                        if let username = riderRequest["username"] as? String {
                            
                            if riderRequest["driverResponded"] == nil {
                
                                self.requestUsernames.append(username)
                            
                                self.requestLocations.append(CLLocationCoordinate2D(latitude: (riderRequest["location"] as AnyObject).latitude, longitude: (riderRequest["location"] as AnyObject).longitude))
                            
                            }
                            
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
            })
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return requestUsernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        let driverCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        let riderLocation = CLLocation(latitude: requestLocations[indexPath.row].longitude, longitude: requestLocations[indexPath.row].longitude)
        
        let distance = driverCLLocation.distance(from: riderLocation) // 1000
        
        let roundDistance = round(distance * 100) / 100
        
        cell.textLabel?.text = requestUsernames[indexPath.row] + " - \(distance) km away"

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
