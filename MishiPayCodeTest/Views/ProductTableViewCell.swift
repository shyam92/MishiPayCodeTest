//
//  ProductTableViewCell.swift
//  MishiPayCodeTest
//
//  Created by Shyam Bhudia on 06/09/2020.
//  Copyright © 2020 Shyam Bhudia. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    func setup(with product: Product) {
        productImageView.image = UIImage(named: product.name ?? "")
        titleLabel.text = product.name
        priceLabel.text = "£\(product.price)"
    }
    
    
}
