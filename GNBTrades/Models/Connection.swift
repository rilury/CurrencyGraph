//
//  Connection.swift
//  GNBTrades
//
//  Created by Rilury on 03/03/2019.
//  Copyright © 2019 Rilury. All rights reserved.
//

import Foundation

class Connection {
    public let to: Currency
    public let weight: Double
    
    public init(to node: Currency, weight: Double) {
        assert(weight >= 0.0, "weight has to be equal or greater than zero")
        self.to = node
        self.weight = weight
    }
}
