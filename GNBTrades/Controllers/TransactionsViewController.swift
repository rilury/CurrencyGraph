//
//  TransactionsViewController.swift
//  GNBTrades
//
//  Created by Rilury on 02/03/2019.
//  Copyright © 2019 Rilury. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    //MARK: Variables
    
    var productTransactions: [Transaction] = []
    var currencyArray: [Currency] = []
    var totalAmount: Double = 0.0
    
    //MARK: Outlets
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var transactionsNumberLabel: UILabel!
    @IBOutlet weak var transactionsTableView: UITableView!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateTotalAmount()
        transactionsNumberLabel.text = "(\(productTransactions.count) transactions)"
        transactionsTableView.dataSource = self
 
    }
    
    //MARK: Helpers
    
    
    func shortestPath(source: Currency, destination: Currency) -> Path? {
        var frontier: [Path] = [] {
            didSet {
                frontier.sort {$0.cumulativeWeight < $1.cumulativeWeight}
            }
        }
        
        let sources = currencyArray.filter({$0.name == source.name})
        for source in sources {
            frontier.append(Path(to: source))
        }
        
        while !frontier.isEmpty {
            let cheapestPathInFrontier = frontier.removeFirst()
            
            guard !cheapestPathInFrontier.node.visited else {
                continue
            }
            
            if cheapestPathInFrontier.node.name == destination.name {
                return cheapestPathInFrontier
            }
            
            cheapestPathInFrontier.node.visited = true
            
            for connection in cheapestPathInFrontier.node.connections where !connection.to.visited { //
                let newSources = currencyArray.filter({ $0.name == connection.to.name })
                for newSource in newSources {
                    frontier.append(Path(to: newSource, via: connection, previousPath: cheapestPathInFrontier))
                }
                
            }
        }
        return nil
    }
    
    func findShortestPath(source: Currency, destination: Currency) -> [Currency]? {
        
        for element in currencyArray {
            element.visited = false
//            if let toCurrency = element.toCurrency, let rate = Double(element.rate!){
//                element.connections.append(Connection(to: toCurrency, weight: rate))
//            }
        }
        let path = shortestPath(source: source as Currency, destination: destination as Currency)
        if let succession: [Currency] = path?.array.reversed().compactMap({ $0 }).map({$0 }) {
            return succession
        } else {
            return nil
        }
    }
    
    func calculateConvertedResult(at row: Int) -> Double {
       
        var roundedResult = 0.0
        if let cellCurrency = productTransactions[row].currency {
            
            let x = findShortestPath(source: cellCurrency, destination: Currency(name: "EUR", rate: nil, toCurrency: nil))
            print("🏁 Quickest path: \(x.map({$0.map({$0.name})})!) ")
            var rates = x
            rates?.removeLast()
            let euroValue = (x.map({$0.map({$0.rate!})})!)
            print(euroValue)
            var euroequivalent = 1.0
            for element in euroValue {
                if let doubleValue = Double(element) {
                    euroequivalent *= doubleValue
                }
            }
            
            if let currency = (productTransactions[row].currency)?.name {
                if currency != "EUR" {
                roundedResult = (productTransactions[row].value * euroequivalent).roundToDecimal(2)
                }
                
            }
            
            
            }
        return roundedResult
            
        }
    
    func calculateTotalAmount() {
        for (index, transaction) in productTransactions.enumerated() {
            if transaction.currency?.name == "EUR" {
                totalAmount += transaction.value
            } else {
                totalAmount += calculateConvertedResult(at: index)
            }
        }
        totalAmountLabel.text = "TOTAL AMOUNT: \(String(totalAmount.roundToDecimal(2))) EUR"
    }
    
    }
    
    


extension TransactionsViewController: UITableViewDataSource {
    
    //MARK: TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        if let currency = (productTransactions[indexPath.row].currency)?.name {
        if currency != "EUR" {
            cell.amountLabel.text = "\(String(format: "%02d", indexPath.row+1)).  " + String(productTransactions[indexPath.row].value) + " " + currency + " <=> " + "\(calculateConvertedResult(at: indexPath.row)) EUR"
        } else {
            cell.amountLabel.text = "\(String(format: "%02d", indexPath.row+1)).  " + String(productTransactions[indexPath.row].value) + " " + currency
        }
        }
       
        return cell
    }
    
    
}


