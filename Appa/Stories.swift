//
//  Stories.swift
//  Appa
//
//  Created by Drew Cappel on 4/26/19.
//  Copyright © 2019 Drew Cappel. All rights reserved.
//

import Foundation
import Firebase

class Stories {
    var storiesArray: [Story] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(site: Site, completed: @escaping () -> ())  {
        guard site.documentID != "" else {
            return
        }
        db.collection("sites").document(site.documentID).collection("stories").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.storiesArray = []
            for document in querySnapshot!.documents {
                let story = Story(dictionary: document.data())
                story.documentID = document.documentID
                self.storiesArray.append(story)
            }
            completed()
        }
    }
}
