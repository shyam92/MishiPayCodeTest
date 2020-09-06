//
//  BasketViewModel.swift
//  MishiPayCodeTest
//
//  Created by Shyam Bhudia on 06/09/2020.
//  Copyright © 2020 Shyam Bhudia. All rights reserved.
//

import Foundation

protocol BasketViewDelegate: class {
    func productsUpdated()
    func unableToAddProduct(barcode: String)
}

class BasketViewModel {
    
    //MARK: Local dependacies
    private let databaseManager: DatabaseProtocol
    private weak var delegate: BasketViewDelegate?
    
    /// Datasource
    var basket: Basket?
    
    init(databaseManager: DatabaseProtocol = DatabaseManager(), delegate: BasketViewDelegate?) {
        self.databaseManager = databaseManager
        self.delegate = delegate
        fetchCurrentBasket()
    }
    
    /// Updates the basket with the scanned product if found in local database
    /// - Parameter barcode: Barcode number or string
    func updateProducts(with barcode: String) {
        guard let allProducts = databaseManager.fetchObjects(for: Product.self) as? [Product] else {
            delegate?.unableToAddProduct(barcode: barcode)
            return
        }
        guard let product = allProducts.filter({ $0.barcode == barcode }).first else {
            delegate?.unableToAddProduct(barcode: barcode)
            return
        }
        updateBasket(with: product)
   }
    
    
    /// Calculates total of the basket
    /// - Returns: Returns total of all items added
    func calculateTotal() -> Float {
        guard let basket = self.basket else { return 0.00 }
        var total: Float = 0.00
        basket.items.forEach({total += $0.price})
        return total
    }
    
    
    /// Updates basket with valid product
    /// - Parameter product: Product to be added to basket
    func updateBasket(with product: Product) {
        var currentBasket: Basket
        if let basket = databaseManager.fetchObjects(for: Basket.self)?.first as? Basket {
            currentBasket = Basket(value: basket)
            databaseManager.deleteObjects([basket])
        } else {
            currentBasket = Basket()
        }
        if !currentBasket.items.contains(product) {
            currentBasket.items.append(product)
            databaseManager.addObjects(with: [currentBasket])
            self.basket = currentBasket
            delegate?.productsUpdated()
        }
    }
    
    
    /// Gets current basket from database
    func fetchCurrentBasket() {
        guard let basket = databaseManager.fetchObjects(for: Basket.self)?.first as? Basket else {
            self.basket = nil
            return
        }
        self.basket = basket
    }
    
}
