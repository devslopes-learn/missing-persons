//
//  PersonCell.swift
//  MissingPersons
//
//  Created by Mark Price on 4/2/16.
//  Copyright © 2016 Mark Price. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    
    func configureCell(imgUrl: String) {
        downloadImage(NSURL(string: imgUrl)!)
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.personImage.image = UIImage(data: data)
            }
        }
    }
}
