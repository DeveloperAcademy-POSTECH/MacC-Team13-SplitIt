//
//  ShareCoordinator.swift
//  SplitIt
//
//  Created by Zerom on 3/1/24.
//

import UIKit

enum ShareBaseType {
    case create
    case history
}

protocol ShareCoordinatorDelegate {
    func removeShareCoordinator(_ coordinator: ShareCoordinator)
    func showCreatFlowFromShare(_ splitIdx: String)
    func showEditFlowFromShare(_ splitIdx: String)
}

class ShareCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var delegate: ShareCoordinatorDelegate?
    
    private var navigationController: UINavigationController
    private var currentSplitIdx: String
    private var shareBaseType: ShareBaseType
    private var shareService: ShareServiceType!
    
    init(navigationController: UINavigationController,
         currentSplitIdx: String,
         shareBaseType: ShareBaseType
    ) {
        self.currentSplitIdx = currentSplitIdx
        self.navigationController = navigationController
        self.shareBaseType = shareBaseType
    }
    
    func start() {
        let header = SPNaviBar()
        
        switch shareBaseType {
        case .create:
            header.setRightExitButton()
        case .history:
            header.setLeftImageButton(imageName: "BackIcon")
        }
        
        shareService = ShareService(currentSplitIdx: currentSplitIdx, shareRealmManager: ShareRealmManager())
        let vc = SplitShareVC(viewModel: SplitShareVM(service: shareService),
                              header: header)
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension ShareCoordinator: SplitShareVCRouter {
    
    func addNewCS() {
        self.delegate?.showCreatFlowFromShare(currentSplitIdx)
    }
    
    func editSplit() {
        self.delegate?.showEditFlowFromShare(currentSplitIdx)
    }
    
    func showBackView() {
        self.delegate?.removeShareCoordinator(self)
        self.navigationController.popViewController(animated: true)
        
    }
    
    func showRootView() {
        self.delegate?.removeShareCoordinator(self)
        self.navigationController.popToRootViewController(animated: true)
    }
    
    func showMyBankAccountView() {
        let popView = MyBankAccountVC()
        popView.modalPresentationStyle = .fullScreen
        let baseVC = self.navigationController.viewControllers.last!
        baseVC.present(popView, animated: true)
    }
}
