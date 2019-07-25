//
//  Transaction.swift
//  GNBTrades
//
//  Created by Rilury on 02/03/2019.
//  Copyright © 2019 Rilury. All rights reserved.
//

import Foundation


class Transaction {
    let productName: String
    let value: Double
    let currency: Currency?
    
    init(productName: String, value: Double, currency: Currency?) {
        self.productName = productName
        self.value = (currency?.value)!
        self.currency = currency
    }
    
}
