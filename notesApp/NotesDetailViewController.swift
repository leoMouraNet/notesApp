//
//  NoteViewController.swift
//  notesApp
//
//  Created by user121091 on 7/31/16.
//  Copyright © 2016 skl. All rights reserved.
//

import UIKit
import MobileCoreServices

class NotesDetailViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    //Vars
    var localDate: String = ""
    var localTittle: String = ""
    var localDescription: String = ""
    
    
    //------ Vars for camera
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var pickMyPicture: UIButton!

    @IBOutlet weak var lblDate: UILabel!

    
    
    @IBOutlet weak var txtTittle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    
    @IBAction func btnAddPicture(sender: UIButton) {

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            //var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func selectPicture(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            //var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = false
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func btnSave(sender: UIButton) {

        var imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
        var compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
//        let alert = UIAlertView(title: "\(txtTittle)",
//                                message: "Your Note was saved!",
//                                delegate: nil,
//                                cancelButtonTitle: "Ok")
//        alert.show()
        
        
        
        
        let alertController = UIAlertController(title: txtTittle.text, message: "Your note was saved!", preferredStyle: .Alert)
        
        let actionYes = UIAlertAction(title: "Ok", style: .Default) { (action:UIAlertAction) in
            print("---After OK is Pressed---");
        }
        
//        let actionNo = UIAlertAction(title: "No", style: .Default) { (action:UIAlertAction) in
//            print("You've pressed No button");
//        }
        
        alertController.addAction(actionYes)
//        alertController.addAction(actionNo)
        self.presentViewController(alertController, animated: true, completion:nil)
        
//Here we must save the parameter of the picture (location,Date, Time, Etc) + Note: Tittle and Details
        
        print("----TITTLE + DESCRIPTION-----")
        print("Tittle: \(txtTittle.text)")
        print("Description: \(txtDescription.text) \n")
        
        print("----IMAGEN-----")
        print(compressedJPGImage)
        print(imageView.image!)
        
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Fields for New or Edit Note
        txtTittle.text = localTittle
        txtDescription.text = localDescription
        lblDate.text = localDate
        
        
        // Check if my device has camera or not
        if !UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            //takePictureButton.hidden = true
            takePictureButton.enabled = false
        }

    }

    

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion:nil)
        imageView.image = image
        
    }



}
