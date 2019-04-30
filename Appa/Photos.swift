//
//  Photos.swift
//  Appa
//
//  Created by Drew Cappel on 4/26/19.
//  Copyright © 2019 Drew Cappel. All rights reserved.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = [] 
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(site: Site, completed: @escaping () -> ())  {
        guard site.documentID != "" else {
            return
        }
        let storage = Storage.storage()
        db.collection("sites").document(site.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.photoArray = []
            var loadAttempts = 0
            let storageRef = storage.reference().child(site.documentID)
            // there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let photo = Photo(dictionary: document.data())
                photo.documentUUID = document.documentID
                self.photoArray.append(photo)
                
                // Loading in Firebase Storage images
                let photoRef = storageRef.child(photo.documentUUID)
                photoRef.getData(maxSize: 25 * 1025 * 1025) { data, error in
                    if let error = error {
                        print("*** ERROR: An error occurred while reading data from file ref: \(photoRef) \(error.localizedDescription)")
                        loadAttempts += 1
                        if loadAttempts >= (querySnapshot!.count) {
                            return completed()
                        }
                    } else {
                        let image = UIImage(data: data!)
                        photo.image = image!
                        loadAttempts += 1
                        if loadAttempts >= (querySnapshot!.count) {
                            return completed()
                        }
                    }
                }
            }
        }
    }
}
