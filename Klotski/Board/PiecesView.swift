//
//  PiecesView.swift
//  Klotski
//
//  Created by Alina Ene on 30/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//
import UIKit

protocol PiecesViewDelegate: class {
    func didFinishAnimation()
}

class PiecesView: UIView {
    
    weak var delegate: PiecesViewDelegate?
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
    
    private lazy var bigPieceView = UIView()
    private lazy var horizontalView = UIView()
    private lazy var vertical2View = UIView()
    private lazy var vertical3View = UIView()
    private lazy var vertical4View = UIView()
    private lazy var vertical1View = UIView()
    private lazy var square1View = UIView()
    private lazy var square2View = UIView()
    private lazy var square3View = UIView()
    private lazy var square4View = UIView()
    
    private var viewsArray: [UIView] = []
    var pieces: [Piece] = [] {
        didSet {
            updatePieces()
        }
    }
    
    func load() {
        bigPieceView.backgroundColor = .blue
        horizontalView.backgroundColor = .yellow
        vertical2View.backgroundColor = .green
        vertical3View.backgroundColor = .cyan
        vertical4View.backgroundColor = .red
        vertical1View.backgroundColor = .purple
        square1View.backgroundColor = .magenta
        square2View.backgroundColor = .orange
        square3View.backgroundColor = .brown
        square4View.backgroundColor = .lightGray
        viewsArray = [vertical1View, bigPieceView, vertical2View, vertical3View, horizontalView, square1View, square2View, vertical4View, square3View, square4View]
        for view in viewsArray {
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
        bigPieceView.frame = frame(piece: pieces[0])
        horizontalView.frame = frame(piece: pieces[1])
        vertical2View.frame = frame(piece: pieces[5])
        vertical3View.frame = frame(piece: pieces[4])
        vertical4View.frame = frame(piece: pieces[3])
        vertical1View.frame = frame(piece: pieces[2])
        square1View.frame = frame(piece: pieces[6])
        square2View.frame = frame(piece: pieces[7])
        square3View.frame = frame(piece: pieces[8])
        square4View.frame = frame(piece: pieces[9])
    }
    
    func performStep(_ index: Int) {
        if index == Puzzle.shared.backtrackCoords.count || Puzzle.shared.backtrackCoords.isEmpty {
            delegate?.didFinishAnimation()
            return
        }
        
        for (i, coord) in Puzzle.shared.backtrackCoords[index].enumerated() {
            pieces[i].coord = coord
        }
        for piece in pieces {
            print(piece.coord, terminator: ", ")
        }
        displayAnimations()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.performStep(index + 1)
        }
    }
    
    private func displayAnimations() {
        for (index, view) in viewsArray.enumerated() {
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
