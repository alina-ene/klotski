//
//  BoardViewModel.swift
//  Klotski
//
//  Created by Alina Ene on 05/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

protocol BoardViewLoading {
    func updateSelection(scenario: Int)
    func startPuzzle()
}

protocol BoardLoadable {
    var playButtonTitle: String { get }
    var scenariosCount: Int { get }
    var defaultScenario: Int { get }
    func updateBoard(buttonSelection scenario: String?)
    func tapPlayButton()
    var view: BoardViewLoading? { get set }
}

class BoardViewModel: BoardLoadable {
    var view: BoardViewLoading?
    
    var defaultScenario: Int = 1
    var playButtonTitle: String = "Play"
    var scenariosCount: Int = 4
    
    func updateBoard(buttonSelection scenario: String?) {
        let index = Int(scenario ?? "1") ?? 1
        DataManager.shared.scenario = index
        view?.updateSelection(scenario: index)
    }
    
    func tapPlayButton() {
        view?.startPuzzle()
    }
}
