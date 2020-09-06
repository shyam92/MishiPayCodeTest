//
//  CheckoutCompletedViewController.swift
//  MishiPayCodeTest
//
//  Created by Shyam Bhudia on 06/09/2020.
//  Copyright © 2020 Shyam Bhudia. All rights reserved.
//

import UIKit

class CheckoutCompletedViewController: UIViewController {

    var basket: Basket?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        calculateTotal()
    }
    
    func calculateTotal() {
        var total: Float = 0.00
        basket?.items.forEach({total += $0.price})
        totalPrice.text = "£\(total)"
    }

    @IBAction func startAgainTapped(_ sender: Any) {
        DatabaseManager().deleteObjects(for: Basket.self)

        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}
extension CheckoutCompletedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath) as? ProductTableViewCell else { return UITableViewCell() }
        guard let data = basket?.items[indexPath.row] else { return cell }
        cell.setup(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basket?.items.count ?? 0
    }
}
