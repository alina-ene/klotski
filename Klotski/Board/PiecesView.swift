//
//  PiecesView.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//
import UIKit

class PiecesView: UIView {
    
    private let sideMargin = CGFloat(40)
    private var availableWidth: CGFloat {
        return UIScreen.main.bounds.width - 2 * sideMargin
    }
    private var availableHeight: CGFloat = {
        return UIScreen.main.bounds.height - 180
    }()
    private var unit: CGFloat {
        return availableWidth < availableHeight ? availableWidth/CGFloat(DataManager.boardWidth) : availableHeight/CGFloat(DataManager.boardHeight)
    }
    
    private var views: [UIView] = []
    private var pieces: [Piece] = [] 
    
    func load(pieces: [Piece], colours: [UIColor]) {
        self.pieces = pieces
        views = []
        for colour in colours {
            let view = UIView()
            view.backgroundColor = colour
            views.append(view)
            addSubview(view)
        }
    }
    
    private func size(_ size: Size) -> CGSize {
        let w = CGFloat(size.w)
        let h = CGFloat(size.h)
        return CGSize(width: w * unit, height: h * unit)
    }
    
    func frame(piece: Piece) -> CGRect {
        return CGRect(origin: origin(coord: piece.coord), size: size(piece.size))
    }
    
    func updatePieces() {
        for piece in pieces {
            views[piece.id].frame = frame(piece: piece)
        }
    }
    
    var coordinates: [Coordinates]? {
        didSet {
            if let coords = coordinates {
                
                for (i, coord) in coords.enumerated() {
                    pieces[i].coord = coord
                }
                for piece in pieces {
                    print(piece.coord, terminator: ", ")
                }
                displayAnimations()
            }
        }
    }
    
    private func displayAnimations() {
        for (index, view) in views.enumerated() {
            let piece = pieces[index]
            let dest = origin(coord: piece.coord)
            if view.frame.origin != dest {
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                    view.frame = CGRect(origin: dest, size: view.bounds.size)
                }) { (_) in
                }
            }
        }
    }
    
    private func origin(coord: Coordinates) -> CGPoint {
        let y = CGFloat(coord.y)
        let x = CGFloat(coord.x)
        return CGPoint(x: x * unit + sideMargin, y: y * unit + sideMargin)
    }
    
}
