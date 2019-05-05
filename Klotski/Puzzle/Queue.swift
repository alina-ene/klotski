//
//  Queue.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation
public struct Queue<T> {
    
    fileprivate var list = LinkedList<T>()
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    @discardableResult
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        
        list.remove(element)
        
        return element.value
    }
    
    public func peek() -> T? {
        return list.first?.value
    }
}

extension Queue: CustomStringConvertible {
    
    public var description: String {
        return list.description
    }
}
