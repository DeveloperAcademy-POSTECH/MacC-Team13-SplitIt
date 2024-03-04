//
//  SettingCoordinator.swift
//  SplitIt
//
//  Created by Zerom on 2/28/24.
//

import UIKit
import SafariServices

protocol SettingCoordinatorDelegate {
    func removeSettingCoordinator(_ coordinator: SettingCoordinator)
    func showShareFlowFromHistory(splitIdx: String)
}

class SettingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var delegate: SettingCoordinatorDelegate?
    
    private var navigationController: UINavigationController
    private var memberLogService: MemberLogServiceType!
    private var historyService: HistoryServiceType!
    private var shareService: ShareServiceType!
    
    init(navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    func start() {
        let header = SPNaviBar()
        header.setLeftImageButton(imageName: "BackIcon")
        
        let vc = MyInfoVC(viewModel: MyInfoVM(), header: header)
        vc.router = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension SettingCoordinator: MyInfoVCRouter {
    
    func moveToPrivacyVC() {
        guard let url = URL(string: "https://kori-collab.notion.site/e3407a6ca4724b078775fd13749741b1?pvs=4") else { return }
        let privacyWebView = SFSafariViewController(url: url)
        privacyWebView.modalPresentationStyle = .automatic
        let baseVC = self.navigationController.viewControllers.last!
        baseVC.present(privacyWebView, animated: true)
    }
    
    func moveTofriendListVC() {
        let header = SPNaviBar()
        header.setLeftImageButton(imageName: "BackIcon")
        
        memberLogService = MemberLogService(memberLogRealManager: MemberLogRealmManager())
        let memberLogVC = MemberLogVC(viewModel: MemberLogVM(memberLogService: memberLogService), header: header)
        memberLogVC.router = self
        self.navigationController.pushViewController(memberLogVC, animated: true)
    }
    
    func moveToHistoryListVC() {
        let header = SPNaviBar()
        header.setLeftImageButton(imageName: "BackIcon")
        
        historyService = HistoryService(historyRealmManager: HistoryReamlManager())
        let historyVC = HistoryVC(viewModel: HistoryVM(historyService: historyService), header: header)
        historyVC.router = self
        self.navigationController.pushViewController(historyVC, animated: true)
    }
    
    func moveToMyBackAccountVC() {
        let bankVC = MyBankAccountVC()
        self.navigationController.pushViewController(bankVC, animated: true)
    }
    
    func moveToMadeByWCCT() {
        guard let url = URL(string: "https://github.com/DeveloperAcademy-POSTECH/MacC-Team13-SplitIt") else { return }
        let WCCTWebView: SFSafariViewController = SFSafariViewController(url: url)
        WCCTWebView.modalPresentationStyle = .automatic
        let baseVC = self.navigationController.viewControllers.last!
        baseVC.present(WCCTWebView, animated: true)
    }
    
    func backFromMyInfoVC() {
        self.delegate?.removeSettingCoordinator(self)
        self.navigationController.popViewController(animated: true)
    }
}

extension SettingCoordinator: MemberLogVCRouter {
    
    func moveToBackView() {
        self.navigationController.popViewController(animated: true)
    }
}

extension SettingCoordinator: HistoryVCRouter {
    
    func moveToSplitShareView(splitIdx: String) {
        self.delegate?.showShareFlowFromHistory(splitIdx: splitIdx)
    }
}
