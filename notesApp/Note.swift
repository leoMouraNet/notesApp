//
//  Note.swift
//  notesApp
//
//  Created by user121091 on 7/31/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit

class Note : NSObject, NSCoding, NSCopying{
    private static let notesKey = "notesKey"
    var title: String = ""
    var date: String = ""
    var geolocation: String = ""
    var image: String = ""
    var message: String = ""
    var notesList = [Note]()
   
    /*
        Note(title: "First", date: "07/31/2016 09:00 AM", geolocation: "Ajax", image: "First", message: "Details Note 1 bla bla bla"),
        Note(title: "Second", date: "08/01/2016 10:00 AM", geolocation: "Toronto", image: "Second", message: "Details Note 2 yes yes yes"),
        Note(title: "Third", date: "07/30/2016 10:00 AM", geolocation: "Vaughan", image: "Third", message: "Details Note 3 no no no")
    ]*/
    override init() {
    }
    
    init(title:String, date:String, geolocation:String, image:String, message:String) {
        self.title = title
        self.date = date
        self.geolocation = geolocation
        self.image = image
        self.message = message
    }
    
    required init(coder decoder: NSCoder) {
        title = decoder.decodeObjectForKey("titleKey") as! String
        date = decoder.decodeObjectForKey("dateKey") as! String
        geolocation = decoder.decodeObjectForKey("geolocationKey") as! String
        image = decoder.decodeObjectForKey("imageKey") as! String
        message = decoder.decodeObjectForKey("messageKey") as! String
        
        notesList = (decoder.decodeObjectForKey(Note.notesKey) as? [Note])!
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(title, forKey: "titleKey")
        coder.encodeObject(date, forKey: "dateKey")
        coder.encodeObject(geolocation, forKey: "geolocationKey")
        coder.encodeObject(image, forKey: "imageKey")
        coder.encodeObject(message, forKey: "messageKey")
        coder.encodeObject(notesList, forKey: Note.notesKey)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Note()
        var newNote = Array<Note>()
        for note in notesList {
            newNote.append(note)
        }
        copy.notesList = newNote
        return copy
    }
    
}


