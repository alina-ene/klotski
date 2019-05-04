//
//  DataManager.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

class DataManager {
    
    static let boardWidth = 4
    static let boardHeight = 5
    
    let scenarios: [[(Int, Int)]] = [
        [(1, 0), (1, 2), (0, 0), (3, 2), (0, 2), (3, 0), (0, 4), (1, 3), (2, 3), (3, 4)],
        [(1, 0), (1, 2), (3, 2), (0, 3), (2, 3), (1, 3), (0, 0), (0, 2), (3, 0), (3, 1)],
        [(1, 1), (1, 3), (3, 0), (0, 0), (3, 2), (0, 3), (1, 0), (2, 0), (0, 2), (3, 4)],
        [(0, 0), (0, 2), (3, 0), (2, 0), (1, 3), (0, 3), (2, 2), (3, 2), (2, 3), (3, 3)]
    ]
    static let shared = DataManager()
    private(set) var pieces: [Piece] = [
        Piece(id: 1, size: (w: 2, h: 2)),
        Piece(id: 4, size: (w: 2, h: 1)),
        Piece(id: 0, size: (w: 1, h: 2)),
        Piece(id: 7, size: (w: 1, h: 2)),
        Piece(id: 3, size: (w: 1, h: 2)),
        Piece(id: 2, size: (w: 1, h: 2)),
        Piece(id: 5, size: (w: 1, h: 1)),
        Piece(id: 6, size: (w: 1, h: 1)),
        Piece(id: 8, size: (w: 1, h: 1)),
        Piece(id: 9, size: (w: 1, h: 1))]
    private init() {
    }
    
    var scenario: Int = 1 {
        didSet {
            for index in 0...9 {
                pieces[index].coord = scenarios[scenario-1][index]
            }
        }
    }
    
}
