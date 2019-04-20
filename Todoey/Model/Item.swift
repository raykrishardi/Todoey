//
//  Item.swift
//  Todoey
//
//  Created by Ray Krishardi Layadi on 19/4/19.
//  Copyright © 2019 Ray Krishardi Layadi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var isDone = false
    @objc dynamic var dateCreated = Date()
    let category = LinkingObjects(fromType: Category.self, property: "items")
    
    convenience init(title: String) {
        self.init()
        
        self.title = title
    }
}
