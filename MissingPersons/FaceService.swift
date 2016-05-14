//
//  FaceService.swift
//  MissingPersons
//
//  Created by Blake Swaidner on 5/14/16.
//  Copyright © 2016 Blake Swaidner. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "4eb46a5b352e4c169dc928304ebedf8d")
    
}