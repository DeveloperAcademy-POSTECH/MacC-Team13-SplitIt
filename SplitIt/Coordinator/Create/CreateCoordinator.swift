//
//  CreateCoordinator.swift
//  SplitIt
//
//  Created by Zerom on 1/10/24.
//

import UIKit

protocol CreateCoordinatorDelegate {
    func removeCreateCoordinator(_ coordinator: CreateCoordinator)
    func finishCreateFlow(_ coordinator: CreateCoordinator, with splitIdx: String)
}

final class CreateCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var delegate: CreateCoordinatorDelegate?
    
    private var navigationController: UINavigationController
    private var currentSplitIdx: String
    private var baseViewControllerIndex: Int!
    private var createService: CreateServiceType!
    private var memberLogService: MemberLogServiceType!
    private var splitMethodService: SplitMethodServiceType!
    
    init(navigationController: UINavigationController,
         currentSplitIdx: String
    ) {
        self.currentSplitIdx = currentSplitIdx
        self.navigationController = navigationController
    }
    
    func start() {
        self.baseViewControllerIndex = self.navigationController.viewControllers.count - 1
        self.showSplitMethodSelectVC()
    }
    
    private func showSplitMethodSelectVC() {
        let header = SPNaviBar()
        header.setLeftImageButton(imageName: "BackIcon")
        
        splitMethodService = SplitMethodService(currentSplitIdx: currentSplitIdx)
        let vc = SplitMethodSelectVC(viewModel: SplitMethodSelectVM(splitMethodService: splitMethodService),
                                     header: header)
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func finishCreate(_ coordinator: Coordinator) {
        self.createService.saveNewSplit()
        self.delegate?.finishCreateFlow(self, with: createService.split.splitIdx)
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.navigationController.removeFromBaseToPreViewController(baseIndex: baseViewControllerIndex)
    }
    
    private func quitCreate(_ coordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.navigationController.popToBaseViewController(baseIndex: baseViewControllerIndex, animated: true)
    }
}

extension CreateCoordinator: SplitMethodSelectVCRouter {
    
    func showSmartCreateFlow() {
        createService = CreateService(currentSplitIdx: currentSplitIdx, createRealmManager: CreateRealmManager())
        memberLogService = MemberLogService(memberLogRealManager: MemberLogRealmManager())
        let coordinator = SmartCreateCoordinator(createService: createService,
                                                 memberLogService: memberLogService,
                                                 navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func showEqualCreateFlow() {
        createService = CreateService(currentSplitIdx: currentSplitIdx, createRealmManager: CreateRealmManager())
        memberLogService = MemberLogService(memberLogRealManager: MemberLogRealmManager())
        let coordinator = EqualCreateCoordinator(createService: createService,
                                                 memberLogService: memberLogService,
                                                 navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func dismissSplitMethodSelectVC() {
        self.delegate?.removeCreateCoordinator(self)
        self.navigationController.popViewController(animated: true)
    }
}

extension CreateCoordinator: SmartCreateCoordinatorDelegate {
    
    func removeSmartCreateCoordinator(_ coordinator: SmartCreateCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
    
    func requestQuitSmartCreate(_ coordinator: SmartCreateCoordinator) {
        self.quitCreate(coordinator)
    }
    
    func requestFinishSmartCreateFlow(_ coordinator: SmartCreateCoordinator) {
        self.finishCreate(coordinator)
    }
}

extension CreateCoordinator: EqualCreateCoordinatorDelegate {
    
    func removeEqualCreateCoordinator(_ coordinator: EqualCreateCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
    
    func requestQuitEqualCreate(_ coordinator: EqualCreateCoordinator) {
        self.quitCreate(coordinator)
    }
    
    func requestFinishEqualCreateFlow(_ coordinator: EqualCreateCoordinator) {
        self.finishCreate(coordinator)
    }
}
