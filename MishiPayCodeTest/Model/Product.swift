//
//  Product.swift
//  MishiPayCodeTest
//
//  Created by Shyam Bhudia on 06/09/2020.
//  Copyright © 2020 Shyam Bhudia. All rights reserved.
//

import Foundation
import RealmSwift

class Product: Object {
    
    @objc dynamic var name: String? = nil
    @objc dynamic var price: Float = 0
    @objc dynamic var barcode: String? = nil
    
    override class func primaryKey() -> String? {
        return "barcode"
    }
    
    convenience init(name: String?, price: Float, barcode: String) {
        self.init()
        self.name = name
        self.price = price
        self.barcode = barcode
    }
}
