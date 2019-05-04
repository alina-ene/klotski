//
//  Piece.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

enum PieceType: Int {
    case horizontal = 3
    case vertical = 2
    case bigSquare = 4
    case tinySquare = 1
    case none = 0
}

class Piece {
    
    var coord: (x: Int, y: Int) = (-1, -1)
    var size: (w: Int, h: Int) = (0, 0)
    var id: Int
    
    var type: PieceType {
        switch size {
        case (1, 1):
            return .tinySquare
        case (1, 2):
            return .vertical
        case (2, 1):
            return .horizontal
        case (2, 2):
            return .bigSquare
        default:
            return .none
        }
    }
    
    init(id: Int, size: (w: Int, h: Int)) {
        self.size = size
        self.id = id
    }
    
}

