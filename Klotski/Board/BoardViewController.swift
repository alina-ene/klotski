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
        
        piecesView.load(pieces: viewModel.pieces, colours: viewModel.colours)
        loadControlPanel()
        activityIndicatorView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        showLoading(false)
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
    
    private func showLoading(_ show: Bool = true) {
        if show {
            view.bringSubviewToFront(activityIndicatorView)
            activityIndicatorView.startAnimating()
        } else {
            view.sendSubviewToBack(activityIndicatorView)
            activityIndicatorView.stopAnimating()
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
}

extension BoardViewController: BoardViewLoading {
    
    func updateStateLabel() {
        stateLabel.text = viewModel.stateLabelTitle
    }
    
    func animationHasEnded() {
        showLoading(false)
    }
    
    func updateBoard(coordinates: [Coordinates]) {
        piecesView.coordinates = coordinates
    }
    
    func updateSelection(scenario: Int) {
        piecesView.updatePieces()
        resetButtonsUI()
        if let button = buttonsStackView.subviews[scenario] as? UIButton {
            button.setTitleColor(.black, for: .normal)
        }
    }
    
    func startPuzzle() {
        showLoading(true)
    }

}
