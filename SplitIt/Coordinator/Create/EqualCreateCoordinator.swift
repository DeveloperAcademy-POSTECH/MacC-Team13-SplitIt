//
//  EqualCreateCoordinator.swift
//  SplitIt
//
//  Created by Zerom on 1/10/24.
//

import UIKit

protocol EqualCreateCoordinatorDelegate {
    func removeEqualCreateCoordinator(_ coordinator: EqualCreateCoordinator)
    func requestQuitEqualCreate(_ coordinator: EqualCreateCoordinator)
    func requestFinishEqualCreateFlow(_ coordinator: EqualCreateCoordinator)
}

final class EqualCreateCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var delegate: EqualCreateCoordinatorDelegate?
    
    private var createService: CreateServiceType
    private var memberLogService: MemberLogServiceType
    private var navigationController: UINavigationController
    
    init(createService: CreateServiceType,
         memberLogService: MemberLogServiceType,
         navigationController: UINavigationController
    ) {
        self.createService = createService
        self.memberLogService = memberLogService
        self.navigationController = navigationController
    }
    
    func start() {
        self.showCSInfoVC()
    }

    private func showCSInfoVC() {
        let header = SPNaviBar()
        header.setTitleImage(type: .equalFirst)
        header.setLeftImageButton(imageName: "BackIcon")
        header.setRightExitButton()
        
        let vc = CSInfoVC(viewModel: CSInfoVM(createService: createService), header: header)
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension EqualCreateCoordinator: CSInfoVCRouter, CSMemberVCRouter {
    
    func showCSMemberVC() {
        let header = SPNaviBar()
        header.setTitleImage(type: .equalSecond)
        header.setLeftImageButton(imageName: "BackIcon")
        header.setRightExitButton()
        
        let vc = CSMemberVC(viewModel: CSMemberVM(createService: createService,
                                                  memberLogService: memberLogService),
                            header: header)
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showNextVC() {
        self.delegate?.requestFinishEqualCreateFlow(self)
    }
    
    func quitCreateFlow() {
        self.delegate?.requestQuitEqualCreate(self)
    }
    
    func backFromCSInfo() {
        self.delegate?.removeEqualCreateCoordinator(self)
        self.navigationController.popViewController(animated: true)
    }
    
    func backFromCSMember() {
        self.navigationController.popViewController(animated: true)
    }
}
