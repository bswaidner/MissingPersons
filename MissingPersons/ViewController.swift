//
//  ViewController.swift
//  MissingPersons
//
//  Created by Blake Swaidner on 5/11/16.
//  Copyright © 2016 Blake Swaidner. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localHost:6069/img/"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedImage: UIImageView!
    
    var selectedPerson: Person?
    var hasSelectedImage: Bool = false
    
    let imagePicker = UIImagePickerController()

    let missingPersons = [
        Person(personURL: "person1.jpg"),
        Person(personURL: "person2.jpg"),
        Person(personURL: "person3.jpg"),
        Person(personURL: "person4.jpg"),
        Person(personURL: "person5.jpg"),
        Person(personURL: "person6.png"),
     
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImage.addGestureRecognizer(tap)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedPerson = missingPersons[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        cell.setSelected()
        
    }

    @IBAction func checkForMatch(sender: AnyObject) {
        if selectedPerson == nil || hasSelectedImage != true {
            showErrorAlert()
        } else {
            if let myImage = selectedImage.image, let imgData = UIImageJPEGRepresentation(myImage, 0.8) {
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                    if err == nil {
                        var faceID: String?
                        
                        for face in faces {
                            faceID = face.faceId
                            break
                        }
                        
                        if faceID != nil {
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceId, faceId2: faceID, completionBlock: { (result: MPOVerifyResult!, err: NSError!) in
                                
                                if result.isIdentical == true || Double(result.confidence) >= 0.60 {
                                    self.showMatchAlert(Double(result.confidence))
                                }
                                else {
                                    self.showNotMatchAlert(Double(result.confidence))
                                }
                            })
                        } else {
                            print(err.debugDescription)
                        }
                    }
                })
            }
        }
    }
    
    func showMatchAlert(confidence: Double) {
        let alert = UIAlertController(title: "It's a match!", message: "According to our resources, these two people are the same at a \(100 * confidence)% confidence level", preferredStyle: UIAlertControllerStyle.Alert)
        let okay = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(okay)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showNotMatchAlert(confidence: Double) {
        let alert = UIAlertController(title: "Not a Match", message: "According to our resources, the match confidence level is \(100 * confidence)% ", preferredStyle: UIAlertControllerStyle.Alert)
        let okay = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(okay)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Select Person & Image", message: "Please select a missing person and an image from your photo album to check match", preferredStyle: UIAlertControllerStyle.Alert)
        let okay = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(okay)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPersons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        
        let person = missingPersons[indexPath.row]
        cell.configureCell(person)
        
        return cell
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.image = pickedImage
            selectedImage.clipsToBounds = true
        }
        dismissViewControllerAnimated(true, completion: nil)
        hasSelectedImage = true
    }
    
    func loadPicker(gesture: UIGestureRecognizer) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

}

