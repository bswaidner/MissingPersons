//
//  PersonCell.swift
//  MissingPersons
//
//  Created by Blake Swaidner on 5/11/16.
//  Copyright © 2016 Blake Swaidner. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    
    var person: Person!
    
    func configureCell(person: Person) {
        self.person = person
        personImage.clipsToBounds = true
        if let url = NSURL(string: "\(baseURL)\(person.personImgUrl!)") {
            downloadImg(url)
        }
    }
    
    func downloadImg(url: NSURL) {
        getDataFromUrl(url) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.personImage.image = UIImage(data: data)
                self.person.personImg = self.personImage.image
            }
        }
    }
    
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError!) -> Void)) {
    
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
        }.resume()
        
    }
    
    func setSelected() {
        
        personImage.layer.borderWidth = 6.0
        personImage.layer.borderColor = UIColor(red: CGFloat(0.996), green: CGFloat(0.862), blue: CGFloat(0.196), alpha: CGFloat(1.0)).CGColor
        
        self.person.downloadFaceId()
    }
    
}
