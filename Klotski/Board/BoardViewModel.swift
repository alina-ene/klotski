//
//  BoardViewModel.swift
//  Klotski
//
//  Created by Alina Ene on 05/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

class BoardViewModel: BoardViewLoadable, DataManagerInjector, PuzzleInjector {
    
    var view: BoardViewLoading?
    var playButtonTitle = "Play"
    var scenariosCount = 4
    var currentScenario = 1
    
    func updateBoard(buttonSelection scenario: String?) {
        currentScenario = Int(scenario ?? "1") ?? 1
        resetScenario(currentScenario)
    }
    
    func tapPlayButton() {
        resetScenario(currentScenario)
        view?.startPuzzle()
        DispatchQueue.main.async {
            self.puzzle.search { stateLayout in
                self.puzzle.recursivelyDecode(layout: stateLayout)
                self.view?.displayPermutations()
            }
        }
    }
    
    private func resetScenario(_ scenario: Int) {
        dataManager.scenario = scenario
        view?.updateSelection(scenario: scenario)
    }
    
    var pieces: [Piece] {
        return dataManager.pieces
    }
    
    var colours: [UIColor] {
        return dataManager.colours
    }
}
