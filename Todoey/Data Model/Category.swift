//
//  Category.swift
//  Todoey
//
//  Created by Matthew Chambers on 28/9/18.
//  Copyright © 2018 Matthew Chambers. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>() // empty list of Item objects (class List is from Realm Framework)
    
}
