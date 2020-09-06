//
//  BasketViewController.swift
//  MishiPayCodeTest
//
//  Created by Shyam Bhudia on 06/09/2020.
//  Copyright © 2020 Shyam Bhudia. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    // MARK: Global Variables
    var movingToChild = false
    var viewModel: BasketViewModel?
    var productScanned: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        viewModel = BasketViewModel(delegate: self)
        if let product = productScanned {
            viewModel?.updateProducts(with: product)
        } else {
            productsUpdated()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if movingToChild {
            movingToChild = false
            viewModel?.fetchCurrentBasket()
            productsUpdated()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CheckoutCompletedViewController,
           viewModel?.basket?.items.count ?? 0 > 0 {
            destination.basket = viewModel?.basket
            movingToChild = true
        }
    }
    
}

/**
 ViewModel Delegate for data updates
 */
extension BasketViewController: BasketViewDelegate {
    
    func unableToAddProduct(barcode: String) {
        let alert = UIAlertController(title: "Sorry! We are not able to find this product", message: "Please ask for assistance", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func productsUpdated() {
        tableView.reloadData()
        let total = String(format: "£%.2f", viewModel?.calculateTotal() ?? 0.00)
        totalPrice.text = total
        checkoutButton.setTitle("Pay \(total)", for: .normal)
    }
}

/**
 TableView Datasource delegates
 */
extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath) as? ProductTableViewCell else { return UITableViewCell() }
        guard let data = viewModel?.basket?.items[indexPath.row] else { return cell }
        cell.setup(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.basket?.items.count ?? 0
    }
}
