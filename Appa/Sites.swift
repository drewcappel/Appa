//
//  Sites.swift
//  Appa
//
//  Created by Drew Cappel on 4/10/19.
//  Copyright © 2019 Drew Cappel. All rights reserved.
//

import Foundation
import Firebase

class Sites {
    
    var siteArray = [Site]()
    
    // var siteArray = ["Big Creek, KY", "Chavies, KY", "Hazard, KY", "Elizabethtown, KY", "Gloucester County, NJ", "Philadelphia, PA (CSM)", "New York, NY", "Detroit, MI (Motown Mission)", "Detroit, MI (Noah Project)", "Kent County, MI", "Lansing, MI", "Chatham, NC", "Goldsboro, NC", "Greenville, NC", "Charlotte, NC", "Sumter, SC", "Greenwood, SC", "Washington County, VA", "Berkeley County, SC", "Hollywood, SC", "Lincolnville, SC", "Florence, SC", "Wheeling, WV", "Mon Valley, WV", "Huntington, WV", "Exmore, VA", "Weirwood, VA", "SAW, VA", "Oakland UMC, VA", "Kingdom Life, VA", "Ivanhoe, VA", "Joy Ranch, VA", "Rockbridge, VA", "Hurley, VA", "Lucedale, MS", "Beaumont, TX", "Puerto Rico"]
    
    var db: Firestore!

    init() {
        db = Firestore.firestore()
    }

    func loadData(completed: @escaping () -> ())  {
        db.collection("sites").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.siteArray = []
            for document in querySnapshot!.documents {
                let site = Site(dictionary: document.data() as! [String : String])
                site.documentID = document.documentID
                self.siteArray.append(site)
            }
            completed()
        }
    }

}



