//
//  Currency.swift
//  GNBTrades
//
//  Created by Rilury on 02/03/2019.
//  Copyright © 2019 Rilury. All rights reserved.
//

import Foundation

class Currency {
    let name: String
    let value: Double
    let rate : String?
    let toCurrency: Currency?
    var visited = false
    var connections: [Connection] = []
    
    init(name: String, value: Double = 1, rate: String?, toCurrency: Currency?) {
        self.name = name
        self.value = value
        self.rate = rate
        self.toCurrency = toCurrency
    }
    
}
