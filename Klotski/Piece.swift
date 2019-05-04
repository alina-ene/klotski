//
//  Piece.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

class Piece {
    
    var coord: Coordinates = DataManager.cNone
    var size: Size = DataManager.size00
    var id: Int
    
    var type: PieceType {
        switch (size.w, size.h) {
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
    
    init(id: Int, size: Size) {
        self.size = size
        self.id = id
    }
    
}

