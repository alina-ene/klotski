//
//  BoardViewLoadable.swift
//  Klotski
//
//  Created by Alina Ene on 05/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

protocol BoardViewLoadable {
    var playButtonTitle: String { get }
    var scenariosCount: Int { get }
    var currentScenario: Int { get set }
    func updateBoard(buttonSelection scenario: String?)
    func tapPlayButton()
    var view: BoardViewLoading? { get set }
    var pieces: [Piece] { get }
}
