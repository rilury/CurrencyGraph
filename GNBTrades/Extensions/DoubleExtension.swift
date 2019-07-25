//
//  DoubleExtension.swift
//  GNBTrades
//
//  Created by Rilury on 03/03/2019.
//  Copyright © 2019 Rilury. All rights reserved.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
