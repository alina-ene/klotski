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
    func didFindPath(_ path: String)
}

class PiecesView: UIView {
    
    weak var delegate: PiecesViewDelegate?
    private let sideMargin = CGFloat(40)
    private var availableWidth: CGFloat {
        return UIScreen.main.bounds.width - 2 * sideMargin
    }
    private let availableHeight = UIScreen.main.bounds.height - 130
    private var unit: CGFloat {
        return availableWidth < availableHeight ? availableWidth/4 : availableHeight/4
    }
    
    private lazy var bigPieceView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var horizontalView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private lazy var vertical2View: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    private lazy var vertical3View: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()
    
    private lazy var vertical4View: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var vertical1View: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        return view
    }()
    
    private lazy var square1View: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        return view
    }()
    
    private lazy var square2View: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    private lazy var square3View: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        return view
    }()
    
    private lazy var square4View: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var viewsArray: [UIView] = []
    
    var stepIndex = 0
    
    var timer: Timer?
    
    func load() {
        viewsArray = [vertical1View, bigPieceView, vertical2View, vertical3View, horizontalView, square1View, square2View, vertical4View, square3View, square4View]
        for view in viewsArray {
            addSubview(view)
        }
        AI.shared.delegate = self
    }
    
    private let pieces: [Piece] = DataManager.shared.pieces
    
    
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
    
    @objc func play() {
        stepIndex = 0
        
        AI.shared.search { stateLayout in
            delegate?.didFindPath(stateLayout)
            AI.shared.recursivelyDecode(layout: stateLayout)
            performStep(index: 0)
        }
    }
    
    func performStep(index: Int) {
        if index == AI.shared.backtrackCoords.count || AI.shared.backtrackCoords.isEmpty {
            delegate?.didFinishAnimation()
            return
        }
        
        for (i, coord) in AI.shared.backtrackCoords[index].enumerated() {
            pieces[i].coord = coord
        }
        for piece in pieces {
            print(piece.coord, terminator: ", ")
        }
        displayAnimations()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.performStep(index: index + 1)
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

extension PiecesView: AIDelegate {
    func didProgress(board: String) {
        delegate?.didFindPath(board)
    }
}
