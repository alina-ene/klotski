//
//  BoardLoadable.swift
//  Klotski
//
//  Created by Alina Ene on 05/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

protocol BoardLoadable {
    var playButtonTitle: String { get }
    var scenariosCount: Int { get }
    var defaultScenario: Int { get }
    func updateBoard(buttonSelection scenario: String?)
    func tapPlayButton()
    var view: BoardViewLoading? { get set }
}
