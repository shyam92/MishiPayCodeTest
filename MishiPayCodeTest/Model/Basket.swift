//
//  Basket.swift
//  MishiPayCodeTest
//
//  Created by Shyam Bhudia on 06/09/2020.
//  Copyright © 2020 Shyam Bhudia. All rights reserved.
//

import Foundation
import RealmSwift

class Basket: Object {
    @objc dynamic var id: String = UUID().uuidString
    var items = List<Product>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
