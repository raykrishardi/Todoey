//
//  Item+CoreDataClass.swift
//  Todoey
//
//  Created by Ray Krishardi Layadi on 17/4/19.
//  Copyright © 2019 Ray Krishardi Layadi. All rights reserved.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.isDone = false
    }
}
