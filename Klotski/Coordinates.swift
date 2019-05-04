//
//  Coordinates.swift
//  Klotski
//
//  Created by Alina Ene on 04/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

struct Coordinates: Equatable {
    var x: Int
    var y: Int
    
    static func == (lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
