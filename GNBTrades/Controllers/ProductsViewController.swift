//
//  ViewController.swift
//  GNBTrades
//
//  Created by Rilury on 02/03/2019.
//  Copyright © 2019 Rilury. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    
    // MARK: Variables
    
    var currencyArray: [Currency] = []
    var transactionsArray: [Transaction] = []
    var productsArray: [Product] = []
    
    //MARK: Outlets
    
    @IBOutlet weak var productsTableView: UITableView!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableDelegates()
        getCurrencyData()
        getTransactionsData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }  
    
    //MARK: Helpers
    
    func setTableDelegates () {
        productsTableView.dataSource = self
        productsTableView.delegate = self
    }
    
    func getCurrencyData () {
        if let url = URL(string: "http://gnb.dev.airtouchmedia.com/rates.json") {
            APIRequests.getCurrencyRates(url: url, callback: {[weak self] (currency: [Currency]?, error: String?) in
                if let error = error {
                    print(error)
                } else if let currency = currency {
                    for element in currency {
                        if let toCurrency = element.toCurrency, let rate = element.rate, let rateValue = Double(rate){
                            element.connections.append(Connection(to: toCurrency, weight: rateValue))
                        }
                    }
                    self?.currencyArray = currency
                    
                }
            })
        }
    }
    
    func getTransactionsData() {
        if let url = URL(string: "http://gnb.dev.airtouchmedia.com/transactions.json") {
            APIRequests.getTransactions(url: url, callback: {[weak self] (transactions: [Transaction]?, error: String?) -> Void in
                if let error = error {
                    print(error)
                } else if let transactions = transactions {
                    for element in transactions {
                        guard let array = self?.productsArray else {return}
                        if (array.filter{$0.name == element.productName}).isEmpty {
                            self?.productsArray.append(Product(name: element.productName, transactions: transactions.filter{$0.productName == element.productName}))
                        }
                    }
                    self?.productsArray.sort(by: {($0.name < $1.name)})
                }
                self?.productsTableView.reloadData()
            })
        }
    }
    
}

extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        cell.productNameLabel.text = " \(String(format: "%02d", indexPath.row+1)).  \(productsArray[indexPath.row].name)"
        return cell
    }
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionsViewController") as? TransactionsViewController else {return}
        viewController.productTransactions = self.productsArray[indexPath.row].transactions
        viewController.currencyArray = self.currencyArray
        viewController.title = self.productsArray[indexPath.row].name
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

