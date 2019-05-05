//
//  AppDelegate.swift
//  Klotski
//
//  Created by Alina Ene on 29/04/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let boardViewModel = BoardViewModel()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let boardViewController = storyboard.instantiateViewController(withIdentifier: String(describing: BoardViewController.self)) as! BoardViewController
        boardViewController.viewModel = boardViewModel
        boardViewModel.view = boardViewController
        window!.rootViewController = boardViewController
        window!.makeKeyAndVisible()
        
        return true
    }


}

