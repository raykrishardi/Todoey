//
//  Category.swift
//  Todoey
//
//  Created by Ray Krishardi Layadi on 19/4/19.
//  Copyright © 2019 Ray Krishardi Layadi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var hexColor = ""
    let items = List<Item>()
    
    convenience init(name: String) {
        self.init()
        
        self.name = name
    }
    
    convenience init(name: String, hexColor: String) {
        self.init()
        
        self.name = name
        self.hexColor = hexColor
    }
}
