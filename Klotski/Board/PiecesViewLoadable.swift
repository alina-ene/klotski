//
//  PiecesViewLoadable.swift
//  Klotski
//
//  Created by Alina Ene on 06/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

protocol PiecesViewLoadable {
    var unit: CGFloat { get set }
    var sideMargin: CGFloat { get }
    func frame(piece: Piece) -> CGRect
    func origin(coord: Coordinates) -> CGPoint
    var pieces: [Piece] { get }
    var colours: [UIColor] { get }
}
