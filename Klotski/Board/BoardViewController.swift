//
//  BoardViewController.swift
//  Klotski
//
//  Created by Alina Ene on 29/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet private var piecesView: PiecesView!
    @IBOutlet private var buttonsStackView: UIStackView!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var stateLabel: UILabel!
    
    var viewModel: BoardViewLoadable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        piecesView.viewModel = viewModel.piecesViewModel
        loadControlPanel()
        activityIndicatorView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        loadingIsShown = false
    }
    
    private func loadControlPanel() {
        let playButton = UIButton()
        playButton.setTitle(viewModel.playButtonTitle, for: .normal)
        playButton.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(playButton)
        setButtons(count: viewModel.scenariosCount)
        buttonsStackView.distribution = .fillProportionally
        if let selectedButton = buttonsStackView.subviews[viewModel.currentScenario] as? UIButton {
            setScenario(button: selectedButton)
        }
    }
    
    private func setButtons(count: Int) {
        for index in 1...count {
            let scenarioButton = UIButton()
            scenarioButton.setTitle(index.description, for: .normal)
            scenarioButton.backgroundColor = UIColor.blue.withAlphaComponent(0.15)
            scenarioButton.addTarget(self, action: #selector(setScenario(button:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(scenarioButton)
        }
    }
    
    @objc func play() {
        viewModel.tapPlayButton()
    }
    
    private var loadingIsShown = true {
        willSet {
            switch newValue {
            case true:
                view.bringSubviewToFront(activityIndicatorView)
                activityIndicatorView.startAnimating()
            case false:
                view.sendSubviewToBack(activityIndicatorView)
                activityIndicatorView.stopAnimating()
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func setScenario(button: UIButton) {
        viewModel.updateBoard(buttonSelection: button.titleLabel?.text)
    }
    
    private func resetButtonsUI() {
        for view in buttonsStackView.subviews {
            if let button = view as? UIButton {
                button.setTitleColor(.gray, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
            }
        }
    }
    
    private func highlightSelection(scenario: Int) {
        if let button = buttonsStackView.subviews[scenario] as? UIButton {
            button.setTitleColor(.black, for: .normal)
        }
    }
}

extension BoardViewController: BoardViewLoading {
    
    func updateStateLabel() {
        stateLabel.text = viewModel.stateLabelTitle
    }
    
    func animationHasEnded() {
        loadingIsShown = false
    }
    
    func updateBoard(coordinates: [Coordinates]) {
        piecesView.coordinates = coordinates
    }
    
    func updateSelection(scenario: Int) {
        piecesView.updatePieces()
        resetButtonsUI()
        highlightSelection(scenario: scenario)
    }
    
    func startPuzzle() {
        loadingIsShown = true
    }

}
