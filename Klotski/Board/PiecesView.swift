//
//  PiecesView.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//
import UIKit

class PiecesView: UIView {
    
    var viewModel: PiecesViewLoadable! {
        didSet {
            pieces = viewModel.pieces
            views = []
            for colour in viewModel.colours {
                let view = UIView()
                view.backgroundColor = colour
                views.append(view)
                addSubview(view)
            }
        }
    }
    
    private var views: [UIView] = []
    private var pieces: [Piece] = []
    
    func updatePieces() {
        for piece in pieces {
            views[piece.id].frame = viewModel.frame(piece: piece)
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
            let dest = viewModel.origin(coord: piece.coord)
            if view.frame.origin != dest {
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                    view.frame = CGRect(origin: dest, size: view.bounds.size)
                }) { (_) in
                }
            }
        }
    }

}
