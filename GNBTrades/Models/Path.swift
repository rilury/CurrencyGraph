//
//  Graph.swift
//  GNBTrades
//
//  Created by Rilury on 03/03/2019.
//  Copyright © 2019 Rilury. All rights reserved.
//

import Foundation
class Path {
    public let cumulativeWeight: Double
    public let node: Currency
    public let previousPath: Path?
    
    init(to node: Currency, via connection: Connection? = nil, previousPath path: Path? = nil) {
        if
            let previousPath = path,
            let viaConnection = connection {
            self.cumulativeWeight = viaConnection.weight + previousPath.cumulativeWeight
        } else {
            self.cumulativeWeight = 0.0
        }
        
        self.node = node
        self.previousPath = path
    }
}

extension Path {
    var array: [Currency] {
        var array: [Currency] = [self.node]
        
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.node)
            
            iterativePath = path
        }
        
        return array
    }
}
