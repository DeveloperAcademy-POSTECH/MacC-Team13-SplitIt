//
//  SmartCreateCoordinator.swift
//  SplitIt
//
//  Created by Zerom on 1/10/24.
//

import UIKit

protocol SmartCreateCoordinatorDelegate {
    func removeSmartCreateCoordinator(_ coordinator: SmartCreateCoordinator)
    func requestQuitSmartCreate(_ coordinator: SmartCreateCoordinator)
    func requestFinishSmartCreateFlow(_ coordinator: SmartCreateCoordinator)
}

final class SmartCreateCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var delegate: SmartCreateCoordinatorDelegate?
    
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
        header.setTitleImage(type: .smartFirst)
        header.setLeftImageButton(imageName: "BackIcon")
        header.setRightExitButton()
        
        let vc = CSInfoVC(viewModel: CSInfoVM(createService: createService), header: header)
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension SmartCreateCoordinator: CSInfoVCRouter, CSMemberVCRouter, ExclItemInputVCRouter {
    
    func showCSMemberVC() {
        let header = SPNaviBar()
        header.setTitleImage(type: .smartSecond)
        header.setLeftImageButton(imageName: "BackIcon")
        header.setRightExitButton()
        
        let vc = CSMemberVC(viewModel: CSMemberVM(createService: createService,
                                                  memberLogService: memberLogService), header: header)
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showNextVC() {
        let header = SPNaviBar()
        header.setTitleImage(type: .smartThird)
        header.setLeftImageButton(imageName: "BackIcon")
        header.setRightExitButton()
        
        let vc = ExclItemInputVC(viewModel: ExclItemInputVM(createService: createService), header: header)
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func quitCreateFlow() {
        self.delegate?.requestQuitSmartCreate(self)
    }
    
    func backFromCSInfo() {
        self.delegate?.removeSmartCreateCoordinator(self)
        self.navigationController.popViewController(animated: true)
    }
    
    func backFromCSMember() {
        self.navigationController.popViewController(animated: true)
    }
    
    func backFromExclItem() {
        self.navigationController.popViewController(animated: true)
    }
    
    func finishSmartCreate() {
        self.delegate?.requestFinishSmartCreateFlow(self)
    }
    
    func addExclItem() {
        let vc = ExclItemInfoAddModalVC(viewModel: ExclItemInfoAddModalVM(createService: createService))
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .coverVertical
        
        let baseVC = navigationController.viewControllers.last!
        baseVC.present(vc, animated: true)
    }
    
    func editExclItem(with selectedExclItemIdx: String) {
        let vm = ExclItemInfoEditModalVM(createService: createService,
                                         exclItemIdx: selectedExclItemIdx)
        let vc = ExclItemInfoEditModalVC(viewModel: vm)
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .coverVertical
        
        let baseVC = navigationController.viewControllers.last!
        baseVC.present(vc, animated: true)
    }
}
