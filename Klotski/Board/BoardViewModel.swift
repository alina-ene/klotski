//
//  BoardViewModel.swift
//  Klotski
//
//  Created by Alina Ene on 05/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

class BoardViewModel: BoardLoadable {
    
    var view: BoardViewLoading?
    var defaultScenario = 1
    var playButtonTitle = "Play"
    var scenariosCount = 4
    
    func updateBoard(buttonSelection scenario: String?) {
        let index = Int(scenario ?? "1") ?? 1
        DataManager.shared.scenario = index
        view?.updateSelection(scenario: index)
    }
    
    func tapPlayButton() {
        view?.startPuzzle()
        DispatchQueue.main.async {
            Puzzle.shared.search { stateLayout in
                Puzzle.shared.recursivelyDecode(layout: stateLayout)
                self.view?.displayPermutations()
            }
        }
    }
}
