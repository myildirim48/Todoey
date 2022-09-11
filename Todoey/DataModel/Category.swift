//
//  Category.swift
//  Todoey
//
//  Created by YILDIRIM on 10.09.2022.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
}
