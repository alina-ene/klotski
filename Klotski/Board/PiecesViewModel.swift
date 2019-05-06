//
//  PiecesViewModel.swift
//  Klotski
//
//  Created by Alina Ene on 06/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

class PiecesViewModel: PiecesViewLoadable {
    var pieces: [Piece]
    var colours: [UIColor]
    var unit: CGFloat
    
    init(dataManager: DataManager) {
        pieces = dataManager.pieces
        colours = dataManager.colours
        sideMargin = CGFloat(40)
        let width = UIScreen.main.bounds.width - 2 * sideMargin
        let height = UIScreen.main.bounds.height - 180
        unit = width < height ? width/CGFloat(dataManager.boardWidth) : height/CGFloat(dataManager.boardHeight)
    }
    
    var sideMargin: CGFloat
    
    func frame(piece: Piece) -> CGRect {
        return CGRect(origin: origin(coord: piece.coord), size: size(piece.size))
    }
    
    func origin(coord: Coordinates) -> CGPoint {
        let y = CGFloat(coord.y)
        let x = CGFloat(coord.x)
        return CGPoint(x: x * unit + sideMargin, y: y * unit + sideMargin)
    }
    
    private func size(_ size: Size) -> CGSize {
        let w = CGFloat(size.w)
        let h = CGFloat(size.h)
        return CGSize(width: w * unit, height: h * unit)
    }
}
