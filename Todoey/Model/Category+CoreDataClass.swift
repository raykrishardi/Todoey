//
//  Category+CoreDataClass.swift
//  Todoey
//
//  Created by Ray Krishardi Layadi on 19/4/19.
//  Copyright © 2019 Ray Krishardi Layadi. All rights reserved.
//
//

import Foundation
import CoreData


public class Category: NSManagedObject {
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
    }
}
