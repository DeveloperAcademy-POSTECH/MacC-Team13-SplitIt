//
//  CSMemberPageController.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/22.
//

import UIKit
import Then
import SnapKit

class CSMemberPageController: UIViewController, CSMemberPageChangeDelegate {
    let header = NaviHeader()
    let csMemberInputVC = CSMemberInputVC()
    let csMemberConfirmVC = CSMemberConfirmVC()
    
    lazy var vcArr: [UIViewController] = [csMemberInputVC, csMemberConfirmVC]
    lazy var pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setPageControll()
        setKeyboardNotification()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        csMemberInputVC.searchBar.becomeFirstResponder()
        
        header.do {
            $0.applyStyle(.csMember)
            $0.setBackButton(viewController: self)
        }
    }
    
    private func setPageControll() {
        csMemberInputVC.pageChangeDelegate = self
        
        guard let firstVC = vcArr.first else { return }
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        
        // gesture pageControll 끄기
        for view in pageViewController.view.subviews {
            if let gestureRecognizers = view.gestureRecognizers {
                for gestureRecognizer in gestureRecognizers {
                    if gestureRecognizer is UIPanGestureRecognizer {
                        view.removeGestureRecognizer(gestureRecognizer)
                    }
                }
            }
        }
    }
    
    func changePageToSecondView() {
        self.pageViewController.setViewControllers([self.vcArr[1]], direction: .forward, animated: true, completion: nil)
        let action = UIAction { _ in self.changePageToFirstView() }
        header.setBackButton(action: action)
    }
    
    func changePageToFirstView() {
        self.pageViewController.setViewControllers([self.vcArr[0]], direction: .reverse, animated: true, completion: nil)
        header.setBackButton(viewController: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.csMemberInputVC.searchBar.becomeFirstResponder()
        }
    }
    
    private func setLayout() {
        addChild(pageViewController)
        
        [header,pageViewController.view].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CSMemberPageController: UITextFieldDelegate {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.pageViewController.view.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight + 16)
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        self.pageViewController.view.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setKeyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self)
    }
}
