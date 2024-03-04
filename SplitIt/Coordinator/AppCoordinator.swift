//
//  AppCoordinator.swift
//  SplitIt
//
//  Created by Zerom on 2/12/24.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.showHomeVC()
    }
    
    private func showHomeVC() {
        let vc = HomeVC()
        vc.router = self
        self.navigationController.viewControllers = [vc]
    }
    
    private func showCreateFlow(splitIdx: String) {
        let coordinator = CreateCoordinator(navigationController: self.navigationController,
                                            currentSplitIdx: splitIdx)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func showSettingFlow() {
        let coordinator = SettingCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func showShareFlow(splitIdx: String, shareBaseType: ShareBaseType) {
        let coordinator = ShareCoordinator(navigationController: self.navigationController,
                                           currentSplitIdx: splitIdx,
                                           shareBaseType: shareBaseType)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}

extension AppCoordinator: HomeVCRouter {
    
    func showCreateFlowFromHome() {
        self.showCreateFlow(splitIdx: "")
    }
    
    func showSettingFlowFromHome() {
        self.showSettingFlow()
    }
}

extension AppCoordinator: CreateCoordinatorDelegate {
    
    func removeCreateCoordinator(_ coordinator: CreateCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
    
    func finishCreateFlow(_ coordinator: CreateCoordinator, with splitIdx: String) {
        self.childCoordinators = []
        self.showShareFlow(splitIdx: splitIdx, shareBaseType: .create)
    }
}

extension AppCoordinator: ShareCoordinatorDelegate {
    
    func removeShareCoordinator(_ coordinator: ShareCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
    
    func showCreatFlowFromShare(_ splitIdx: String) {
        self.showCreateFlow(splitIdx: splitIdx)
    }
    
    func showEditFlowFromShare(_ splitIdx: String) {
        let coordinator = EditCoordinator(navigationController: self.navigationController,
                                          currentSplitIdx: splitIdx)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}

extension AppCoordinator: SettingCoordinatorDelegate {
    
    func removeSettingCoordinator(_ coordinator: SettingCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
    
    func showShareFlowFromHistory(splitIdx: String) {
        self.showShareFlow(splitIdx: splitIdx, shareBaseType: .history)
    }
}

extension AppCoordinator: EditCoordinatorDelegate {
    
}
