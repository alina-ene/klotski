//
//  DataManager.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

final class DataManager {
    
    let boardWidth = 4
    let boardHeight = 5
    
    static let c10 = Coordinates(x: 1, y: 0)
    static let c12 = Coordinates(x: 1, y: 2)
    static let c00 = Coordinates(x: 0, y: 0)
    static let c32 = Coordinates(x: 3, y: 2)
    static let c11 = Coordinates(x: 1, y: 1)
    static let c02 = Coordinates(x: 0, y: 2)
    static let c30 = Coordinates(x: 3, y: 0)
    static let c04 = Coordinates(x: 0, y: 4)
    static let c13 = Coordinates(x: 1, y: 3)
    static let c23 = Coordinates(x: 2, y: 3)
    static let c34 = Coordinates(x: 3, y: 4)
    static let c33 = Coordinates(x: 3, y: 3)
    static let c22 = Coordinates(x: 2, y: 2)
    static let c20 = Coordinates(x: 2, y: 0)
    static let c03 = Coordinates(x: 0, y: 3)
    static let c31 = Coordinates(x: 3, y: 1)
    static let cNone = Coordinates(x: -1, y: -1)
    
    static let size00 = Size(w: 0, h: 0)
    static let size22 = Size(w: 2, h: 2)
    static let size21 = Size(w: 2, h: 1)
    static let size12 = Size(w: 1, h: 2)
    static let size11 = Size(w: 1, h: 1)
    
    var scenarios: [[Coordinates]] = {
        return [
        [c10, c12, c00, c32, c02, c30, c04, c13, c23, c34],
        [c10, c12, c32, c03, c23, c13, c00, c02, c30, c31],
        [c11, c13, c30, c00, c32, c03, c10, c20, c02, c34],
        [c00, c02, c30, c20, c13, c03, c22, c32, c23, c33]
        ]}()

    private(set) var pieces: [Piece] = [
        Piece(id: 1, size: size22),
        Piece(id: 4, size: size21),
        Piece(id: 0, size: size12),
        Piece(id: 7, size: size12),
        Piece(id: 3, size: size12),
        Piece(id: 2, size: size12),
        Piece(id: 5, size: size11),
        Piece(id: 6, size: size11),
        Piece(id: 8, size: size11),
        Piece(id: 9, size: size11)]
    
    var scenario: Int = 1 {
        didSet {
            for index in 0...9 {
                pieces[index].coord = scenarios[scenario-1][index]
            }
        }
    }
    
    var colours: [UIColor] = [.blue, .red, .yellow, .green, .cyan, .gray, .purple, .magenta, .lightGray, .orange]
    
}
