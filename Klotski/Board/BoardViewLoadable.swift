//
//  BoardViewLoadable.swift
//  Klotski
//
//  Created by Alina Ene on 05/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

enum BoardState {
    case before, calculating, animating, solved
}

protocol BoardViewLoadable {
    var playButtonTitle: String { get }
    var scenariosCount: Int { get }
    var currentScenario: Int { get set }
    func updateBoard(buttonSelection scenario: String?)
    func tapPlayButton()
    var view: BoardViewLoading? { get set }
    var stateLabelTitle: String { get }
    var boardState: BoardState { get set }
    var piecesViewModel: PiecesViewLoadable { get set}
}
