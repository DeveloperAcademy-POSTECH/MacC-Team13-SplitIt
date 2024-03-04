//
//  SceneDelegate.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            let navigationController = UINavigationController()
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
            
            let coordinator = AppCoordinator(navigationController: navigationController)
            coordinator.start()
            
            self.window?.makeKeyAndVisible()
        }
    }
}
