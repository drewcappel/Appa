//
//  Site.swift
//  Appa
//
//  Created by Drew Cappel on 4/7/19.
//  Copyright © 2019 Drew Cappel. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit


class Site: NSObject {
    
    var name: String
    var documentID: String

    var dictionary: [String: Any] {
        return ["name": name]
    }

    init(name: String, documentID: String) {
        self.name = name
        self.documentID = documentID
    }

    convenience override init() {
        self.init(name: "", documentID: "")
    }

    convenience init(dictionary: [String: String]) {
        let name = dictionary["name"] ?? ""

        self.init(name: name, documentID: "")
    }

    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()

        // Create the dictionary for the data  to save
        let dataToSave = self.dictionary

        if self.documentID != "" {
            let ref = db.collection("sites").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("Document completed with refID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // let firstore create new doc ID
            ref = db.collection("sites").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("New doc created with refID \(ref?.documentID ?? "")")
                    completed(true)
                }
            }
        }
    }
}
