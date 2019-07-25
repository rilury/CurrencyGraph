//
//  APIRequests.swift
//  GNBTrades
//
//  Created by Rilury on 02/03/2019.
//  Copyright © 2019 Rilury. All rights reserved.
//

import Foundation
import Alamofire

class APIRequests {
    
    static func getCurrencyRates(url: URL, callback: @escaping(_ currency: [Currency]?, _ error: String?) -> ()){
        let headers: HTTPHeaders = ["Accept": "application/json"]
        Alamofire.request(url, headers: headers)
            .responseJSON{
                response in
                switch response.result{
                case .failure(let error):
                    callback(nil, error.localizedDescription)
                case .success:
                    var currency : [Currency] = []
                    if let array = response.result.value as? [[String: Any]] {
                        for element in array {
                            guard let name = element["from"] as? String, let rate = element["rate"] as? String, let to = element["to"] as? String else {return}
                            currency.append(Currency(name: name, rate: rate, toCurrency: Currency(name: to, rate: nil, toCurrency: nil)))
                        }
                        callback(currency, nil)
                    }
                }
        }
    }
    
    static func getTransactions(url: URL, callback: @escaping(_ transactions: [Transaction]?, _ error: String?) -> ()){
        let headers: HTTPHeaders = ["Accept": "application/json"]
        Alamofire.request(url, headers: headers)
            .responseJSON{
                response in
                switch response.result{
                case .failure(let error):
                    callback(nil, error.localizedDescription)
                case .success:
                    var transactions : [Transaction] = []
                    if let array = response.result.value as? [[String: Any]] {
                        for element in array {
                            guard let productName = element["sku"] as? String, let amount = element["amount"] as? String, let currency = element["currency"] as? String, let value = Double(amount) else {return}
                            transactions.append(Transaction(productName: productName, value: value, currency: Currency(name: currency, value:  value, rate: nil, toCurrency: nil)))
                        }
                        callback(transactions, nil)
                    }
                }
        }
    }
    
}
