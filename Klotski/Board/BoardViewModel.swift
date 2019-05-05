//
//  BoardViewModel.swift
//  Klotski
//
//  Created by Alina Ene on 05/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

class BoardViewModel: BoardViewLoadable {
    
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
            Puzzle.shared.search { stateLayout in
                Puzzle.shared.recursivelyDecode(layout: stateLayout)
                self.view?.displayPermutations()
            }
        }
    }
    
    private func resetScenario(_ scenario: Int) {
        DataManager.shared.scenario = scenario
        view?.updateSelection(scenario: scenario)
    }
}
