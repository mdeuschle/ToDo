//
//  Category.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/18/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexColor: String = ""
    let items = List<Item>()
}
