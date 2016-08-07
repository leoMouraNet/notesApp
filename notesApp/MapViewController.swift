//
//  MapViewController.swift
//  notesApp
//
//  Created by user121091 on 7/28/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Vars
    var addressString: String = ""
    var locations = [MKPlacemark]()
    var note = Note()
    let rootKey = "rootKey"
    var globalIndex: Int = 0;
    /*let notesList = [
        Note(title: "First", date: "07/31/2016 09:00 AM", geolocation: "Ajax", image: "First", message: "Details Note 1 bla bla bla"),
        Note(title: "Second", date: "08/01/2016 10:00 AM", geolocation: "Toronto", image: "Second", message: "Details Note 2 yes yes yes"),
        Note(title: "Third", date: "07/30/2016 10:00 AM", geolocation: "Vaughan", image: "Third", message: "Details Note 3 no no no")
    ]*/
    
    @IBOutlet weak var map: MKMapView!
    
    
    func addMap(address: String) {
      
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address,completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                let first: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: first)
                self.locations.append(placemark)
                    
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemark.location?.coordinate)!
                annotation.title = address
                        
                var region: MKCoordinateRegion = self.map.region
                region.center.latitude = (placemark.location?.coordinate.latitude)!
                region.center.longitude = (placemark.location?.coordinate.longitude)!
                        
                region.span = MKCoordinateSpanMake(0.5, 0.5)

                self.map.addAnnotation(annotation)
            }
        })

        
    }
    
    func dataFileURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!.URLByAppendingPathComponent("data.archive")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fileURL = self.dataFileURL()
        if (NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)) {
            let data = NSMutableData(contentsOfURL: fileURL)!
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            note = unarchiver.decodeObjectForKey(rootKey) as! Note
            unarchiver.finishDecoding()
        }
        
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)),
                                                         name: UIApplicationWillResignActiveNotification,
                                                         object: app)

        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString("Toronto",completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                let first: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: first)
                self.locations.append(placemark)
                
                var region: MKCoordinateRegion = self.map.region
                region.center.latitude = (placemark.location?.coordinate.latitude)!
                region.center.longitude = (placemark.location?.coordinate.longitude)!
                
                region.span = MKCoordinateSpanMake(0.5, 0.5)
                
                self.map.setRegion(region, animated: true)
            }
        })
        
        for noteItem in note.notesList {
            addMap(noteItem.geolocation)
        }
    }
    
    func applicationWillResignActive(notification:NSNotification) {
        let fileURL = self.dataFileURL()
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(note, forKey: rootKey)
        archiver.finishEncoding()
        data.writeToURL(fileURL, atomically: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Para mi TABLE VIEW
    
    
    //1
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return note.notesList.count
    }
    
    //2
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //3
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! TableMapViewCell
        
        globalIndex = indexPath.row;
        //cell.tittleNote.text = notesList[indexPath.row].title
        //cell.dateNote.text = notesList[indexPath.row].date
        return cell
    }
    
    //4
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        globalIndex = indexPath.row;
        print("Selected Row: --> \(indexPath.row)");
        
        let alertController = UIAlertController(title: "Note: \(note.notesList[indexPath.row].title)", message: "Prepare Segue Here for row: \(indexPath.row)", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        //Here we need to send the Segue = go2details to NotesDetailViewController to show selected Note
        
    }
    
}
