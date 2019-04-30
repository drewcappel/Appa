//
//  Story.swift
//  Appa
//
//  Created by Drew Cappel on 4/26/19.
//  Copyright © 2019 Drew Cappel. All rights reserved.
//

import Foundation
import Firebase

class Story {
    var title: String
    var story: String
    var reviewerUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["title": title, "story": story, "reviewerUserID": reviewerUserID]
    }
    
    init(title: String, story: String, reviewerUserID: String, documentID: String) {
        self.title = title
        self.story = story
        self.reviewerUserID = reviewerUserID
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let story = dictionary["story"] as! String? ?? ""
        let reviewerUserID = dictionary["reviewerUserID"] as! String? ?? ""
        self.init(title: title, story: story, reviewerUserID: reviewerUserID, documentID: "")
    }
    
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
        self.init(title: "", story: "", reviewerUserID: currentUserID,  documentID: "")
    }
    
    func saveData(site: Site, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        
        // Create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        // if we HAVE saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("sites").document(site.documentID).collection("stories").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) in site \(site.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // Let firestore create the new documentID
            ref = db.collection("sites").document(site.documentID).collection("stories").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating new document in site \(site.documentID) for new review documentID \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                    completed(true)
                }
            }
        }
    }

    func deleteData(site: Site, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("sites").document(site.documentID).collection("stories").document(documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: deleting review documentID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            } else {
                completed(true)
            }
        }
    }
}
