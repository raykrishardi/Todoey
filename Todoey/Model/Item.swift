//
//  Item.swift
//  Todoey
//
//  Created by Ray Krishardi Layadi on 16/4/19.
//  Copyright © 2019 Ray Krishardi Layadi. All rights reserved.
//

import Foundation

class Item: Codable {
    let title: String
    var isDone: Bool
    
    init(title: String) {
        self.title = title
        self.isDone = false
    }
}
