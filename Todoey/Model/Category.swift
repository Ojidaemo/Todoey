//
//  Category.swift
//  Todoey
//
//  Created by Vitali Martsinovich on 2023-03-29.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
