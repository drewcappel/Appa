//
//  Photo.swift
//  Appa
//
//  Created by Drew Cappel on 4/26/19.
//  Copyright © 2019 Drew Cappel. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var documentUUID: String // Universial Unique IDentifier
    
    var dictionary: [String: Any] {
        return ["description": description, "postedBy": postedBy]
    }
    
    init(image: UIImage, description: String, postedBy: String, documentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.documentUUID = documentUUID
    }
    
    convenience init() {
        let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(image: UIImage(), description: "", postedBy: postedBy,  documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let postedBy = dictionary["postedBy"] as! String? ?? ""
        self.init(image: UIImage(), description: description, postedBy: postedBy,  documentUUID: "")
    }
    
    func saveData(site: Site, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        
        let storage = Storage.storage()

        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("*** ERROR: could not convert image to data format")
            return completed(false)
        }
        
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        documentUUID = UUID().uuidString
        let storageRef = storage.reference().child(site.documentID).child(self.documentUUID)
        
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetadata) {metadata, error in
            guard error == nil else {
                print("😡 ERROR during .putData storage upload for reference \(storageRef). Error: \(error!.localizedDescription)")
                return
            }
            print("😎 Upload worked! Metadata is \(metadata!)")
        }
        
        uploadTask.observe(.success) { (snapshot) in
            let dataToSave = self.dictionary
            let ref = db.collection("sites").document(site.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentUUID) in site \(site.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("*** ERROR: upload task for file \(self.documentUUID) failed, in site \(site.documentID), error \(error)")
            }
            return completed(false)
        }
    }
}



