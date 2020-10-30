//
//  ArrayLiteral.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 23/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation


struct Queue<T>: ExpressibleByArrayLiteral {
    
    private var items:[T] = []
    
    init(arrayLiteral elements: T...) {
        self.items = elements
    }
    
    mutating func enqueue(_ element: T) {
        items.append(element)
    }
    
    mutating func dequeue() -> T? {
        
        if items.isEmpty {
            return nil
        }
        else{
            let tempElement = items.first
            items.remove(at: 0)
            return tempElement
        }
    }
    mutating func removeAll() {
        items.removeAll()
    }
    
    var count: Int {
        return self.items.count
    }
}
