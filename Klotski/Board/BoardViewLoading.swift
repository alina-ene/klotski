//
//  BoardViewLoading.swift
//  Klotski
//
//  Created by Alina Ene on 05/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

protocol BoardViewLoading {
    func updateSelection(scenario: Int)
    func startPuzzle()
    func animationHasEnded()
    func updateBoard(coordinates: [Coordinates])
    func updateStateLabel()
}
