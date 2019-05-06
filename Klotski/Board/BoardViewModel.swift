//
//  BoardViewModel.swift
//  Klotski
//
//  Created by Alina Ene on 05/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

class BoardViewModel: BoardViewLoadable, DataManagerInjector, PuzzleInjector {
    var boardState: BoardState = .before {
        didSet {
            view?.updateStateLabel()
        }
    }
    
    var stateLabelTitle: String {
        switch boardState {
        case .before:
            return "Press Play to start"
        case .calculating:
            return "Calculating..."
        case .animating:
            return "Applying moves..."
        case .solved:
            return "Solved!"
        }
    }
    
    
    var view: BoardViewLoading?
    var playButtonTitle = "Play"
    var scenariosCount = 4
    var currentScenario = 1
    
    func updateBoard(buttonSelection scenario: String?) {
        boardState = .before
        currentScenario = Int(scenario ?? "1") ?? 1
        resetScenario(currentScenario)
    }
    
    func tapPlayButton() {
        resetScenario(currentScenario)
        boardState = .calculating
        view?.startPuzzle()
        DispatchQueue.main.async {
            self.puzzle.search { stateLayout in
                self.puzzle.recursivelyDecode(layout: stateLayout)
                self.boardState = .animating
                self.performStep(0)
            }
        }
    }
    
    private func performStep(_ index: Int) {
        if index == puzzle.backtrackCoords.count || puzzle.backtrackCoords.isEmpty {
            boardState = .solved
            view?.animationHasEnded()
            return
        }
        view?.updateBoard(coordinates: puzzle.backtrackCoords[index])

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.performStep(index + 1)
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
