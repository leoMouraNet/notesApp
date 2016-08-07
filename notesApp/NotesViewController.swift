//
//  NotesViewController.swift
//  notesApp
//
//  Created by user121091 on 7/28/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Vars
    var miFlag: Bool = true
    var globalIndex: Int = 0
    var note = Note()
    let rootKey = "rootKey"

    
    var TableArray: [String] = []
    @IBOutlet weak var MyTableVC: UITableView!
    
    
    @IBAction func btnAdd(sender: UIBarButtonItem) {
        miFlag = true
        self.performSegueWithIdentifier("go2details", sender: self)
        
    }
    
    func dataFileURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!.URLByAppendingPathComponent("data.archive")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("NotesVC")
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
        
        if (note.notesList.count==0) {
            let Note1 = Note(title: "First", date: "07/31/2016 09:00 AM", geolocation: "Ajax", image: "First", message: "Details Note 1 bla bla bla")
            let Note2 = Note(title: "Second", date: "08/01/2016 10:00 AM", geolocation: "Toronto", image: "Second", message: "Details Note 2 yes yes yes")
            let Note3 = Note(title: "Third", date: "07/30/2016 10:00 AM", geolocation: "Vaughan", image: "Third", message: "Details Note 3 no no no")
            note.notesList.append(Note1)
            note.notesList.append(Note2)
            note.notesList.append(Note3)
        }
        
        //My Custom TableView
        MyTableVC.delegate = self;
        MyTableVC.dataSource = self;
        
        //Var miFlag to check Segue if is NewNote or EditExistingOne
        miFlag = true
        
        // Do any additional setup after loading the view.
    }
    
    func applicationWillResignActive(notification:NSNotification) {
        let fileURL = self.dataFileURL()
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(note, forKey: rootKey)
        archiver.finishEncoding()
        data.writeToURL(fileURL, atomically: true)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "go2details"{
            let DetailsVC = segue.destinationViewController as! NotesDetailViewController
            
            if (miFlag){
                // User Want to ADD a NEW NOTE
                let NewTittle = "My Note Tittle"
                let newDescription = "Write here your note description:"
                DetailsVC.localTittle = NewTittle
                DetailsVC.localDescription = newDescription
            }else {
                // User Want to EDIT a NEW NOTE
                DetailsVC.localTittle = note.notesList[globalIndex].title
                DetailsVC.localDescription = note.notesList[globalIndex].message
                DetailsVC.localDate = note.notesList[globalIndex].date
                
            }
        }
    }//end prepareForSegue
 
    
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! TableViewCell
        
        globalIndex = indexPath.row;
        cell.tittleNote.text = note.notesList[indexPath.row].title
        cell.dateNote.text = note.notesList[indexPath.row].date
        return cell
    }
    
    //4
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        globalIndex = indexPath.row;
        print("Selected Row: --> \(globalIndex)");
        
        //Here we need to send the Segue = go2details to NotesDetailViewController to show selected Note
        miFlag = false
        self.performSegueWithIdentifier("go2details", sender: self)
        
    }
}
