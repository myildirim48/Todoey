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
    
    let items = List<Item>()
    
}
