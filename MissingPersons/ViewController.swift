//
//  ViewController.swift
//  MissingPersons
//
//  Created by Mark Price on 4/2/16.
//  Copyright © 2016 Mark Price. All rights reserved.
//

import UIKit
import Alamofire
import ProjectOxfordFace

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var selectedImg: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    let baseUrl = "http://code.devslopes.com/img/"
    let imageUrls = [
        "person1.jpg",
        "person2.jpg",
        "person3.jpg",
        "person4.jpg",
        "person5.jpg",
        "person6.png"
    ]
    
    let downloadedImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        imagePicker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        cell.configureCell("\(baseUrl)\(imageUrls[indexPath.row])")
        return cell
    }

    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func checkMatch(sender: AnyObject) {
        
        let client = MPOFaceServiceClient(subscriptionKey: "7558c72e87064b8a831cbd2edb44c206")
        
        func getFaceList() {
            client.getFaceListWithFaceListId("missing-persons-dev1") { (list: MPOFaceList!, err: NSError!) in
                
                if err == nil {
                    
                }
                else {
                    
                    client.createFaceListWithFaceListId("missing-persons-dev1", name: "Missing Persons", userData: nil, completionBlock: { (err: NSError!) in
                        
                        for url in self.imageUrls {
                            client.addFacesToFaceListWithFaceListId("missing-persons-dev1", url: "\(self.baseUrl)\(url)", userData: nil, faceRectangle: nil, completionBlock: { (result: MPOAddPersistedFaceResult?, err: NSError?) in
                                print(err?.debugDescription)
                                print(result?.debugDescription)
                                
                            })
                        }
                        
                    })
                    
                }
            }
        }
        
        getFaceList()
        
        if let img = selectedImg.image, let imgData = UIImageJPEGRepresentation(img, 0.8) {
            
            client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faceData: [MPOFace]!, err: NSError!) in
                
                if let error = err {
                    print(error.debugDescription)
                } else {
                   
                    var faceIds = [String]()
                    for face in faceData {
                        faceIds.append(face.faceId)
                    }
                }
                
            })
            
        }
    }
    
    
}
















