//
//  Produtc.swift
//  GNBTrades
//
//  Created by Rilury on 02/03/2019.
//  Copyright © 2019 Rilury. All rights reserved.
//

import Foundation

class Product {
    
    let name: String
    let transactions: [Transaction]
    
    init(name: String, transactions: [Transaction]) {
        self.name = name
        self.transactions = transactions
    }
}
