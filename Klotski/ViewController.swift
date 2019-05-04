//
//  ViewController.swift
//  Klotski
//
//  Created by Alina Ene on 29/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var piecesView: PiecesView!
    @IBOutlet private var buttonsStackView: UIStackView!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        piecesView.load()
        piecesView.delegate = self
        loadControlPanel()
        activityIndicatorView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        activityIndicatorView.stopAnimating()
    }
    
    func loadControlPanel() {
        let playButton = UIButton()
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(playButton)
        setButtons(count: 4)
        buttonsStackView.distribution = .fillProportionally
        if let selectedButton = buttonsStackView.subviews[1] as? UIButton {
            setScenario(button: selectedButton)
        }
    }
    
    private func setButtons(count: Int) {
        for index in 1...count {
            let scenarioButton = UIButton()
            scenarioButton.setTitle(index.description, for: .normal)
            scenarioButton.setTitleColor(.white, for: .normal)
            scenarioButton.backgroundColor = UIColor.blue.withAlphaComponent(0.15)
            scenarioButton.addTarget(self, action: #selector(setScenario(button:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(scenarioButton)
        }
    }
    
    @objc func play() {
        view.bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.startAnimating()
        DispatchQueue.main.async {
            self.piecesView.play()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func setScenario(button: UIButton) {
        let index = Int(button.titleLabel?.text ?? "1") ?? 1
        DataManager.shared.scenario = index
        piecesView.updatePieces()
        
        //update button selection ui
        for view in buttonsStackView.subviews {
            if let button = view as? UIButton {
                button.setTitleColor(.gray, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
            }
        }
        if let button = buttonsStackView.subviews[index] as? UIButton {
            button.setTitleColor(.black, for: .normal)
        }
    }
    
}

extension ViewController: PiecesViewDelegate {
    
    func didFinishAnimation() {
        view.sendSubviewToBack(activityIndicatorView)
        activityIndicatorView.stopAnimating()
    }
    
    func didFindPath(_ path: String) {
        outputLabel.text = path
    }
}
