//
//  Person.swift
//  MissingPersons
//
//  Created by Blake Swaidner on 5/14/16.
//  Copyright © 2016 Blake Swaidner. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    
    var faceId: String?
    var personImg: UIImage?
    var personImgUrl: String?
    
    init(personURL: String){
        self.personImgUrl = personURL
    }
    
    func downloadFaceId() {
        
        if let img = personImg, let imgData = UIImageJPEGRepresentation(img,0.8) {
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                
                if err == nil {
                    var faceId: String?
                    for face in faces {
                        faceId = face.faceId
                        print("Face ID: \(faceId)")
                        break
                    }
                    self.faceId = faceId
                }
            })
        }
    }
}