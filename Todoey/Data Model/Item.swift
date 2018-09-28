//
//  Item.swift
//  Todoey
//
//  Created by Matthew Chambers on 28/9/18.
//  Copyright © 2018 Matthew Chambers. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var ParentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
