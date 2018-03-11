//
//  Item.swift
//  ToDo
//
//  Created by Matt Deuschle on 3/10/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import Foundation

class Item {
    let name: String
    var isSelected = false

    init?(name: String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
}
