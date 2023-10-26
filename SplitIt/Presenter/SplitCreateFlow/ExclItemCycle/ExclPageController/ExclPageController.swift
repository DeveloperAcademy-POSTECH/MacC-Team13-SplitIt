//
//  CSMemberPageController.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/22.
//

import UIKit
import Then
import SnapKit

class ExclPageController: UIViewController, ExclItemNamePageChangeDelegate, ExclItemPricePageChangeDelegate {
    let header = NaviHeader()
    let exclItemNameInputVC = ExclItemNameInputVC()
    let exclItemPriceInputVC = ExclItemPriceInputVC()
    let exclMemberVC = ExclMemberVC()
    let exclMemberSectionHeaderVC = ExclMemberSectionHeader()
    
    var controllCheck = 0
    
    lazy var vcArr: [UIViewController] = [exclItemNameInputVC, exclItemPriceInputVC, exclMemberVC]
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
        exclItemNameInputVC.nameTextFiled.becomeFirstResponder()
        
        header.do {
            $0.applyStyle(.csExcl)
            $0.setBackButton(viewController: self)
        }
    }
    
    
    private func setPageControll() {
        exclItemNameInputVC.pageChangeDelegate = self
        exclItemPriceInputVC.pageChangeDelegate = self
        pageViewController.didMove(toParent: self)
        
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
    
    func changePageToThirdView() {
        controllCheck = 2
        self.pageViewController.setViewControllers([self.vcArr[2]], direction: .forward, animated: true, completion: nil)
        
        setExclMemberHeader()
    }
    
    func changePageToSecondViewReverse() {
        controllCheck = 1
        self.pageViewController.setViewControllers([self.vcArr[1]], direction: .reverse, animated: true, completion: nil)
        let action = UIAction { _ in self.changePageToFirstView() }
        header.setBackButton(action: action)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.exclItemPriceInputVC.priceTextField.becomeFirstResponder()
        }
    }
    
    func changePageToSecondView() {
        self.pageViewController.setViewControllers([self.vcArr[1]], direction: .forward, animated: true, completion: nil)
        let action = UIAction { _ in self.changePageToFirstView() }
        header.setBackButton(action: action)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.exclItemPriceInputVC.priceTextField.becomeFirstResponder()
        }
    }
    
    func changePageToFirstView() {
        self.pageViewController.setViewControllers([self.vcArr[0]], direction: .reverse, animated: true, completion: nil)
        header.setBackButton(viewController: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.exclItemNameInputVC.nameTextFiled.becomeFirstResponder()
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
    
    func setExclMemberHeader() {
        // NaviHeader의 backButton을 없애고 naviImage를 중앙정렬하는 Animation
        UIView.animate(withDuration: 0.3, animations: {
            self.header.backButton.alpha = 0.0

            self.header.backButton.snp.remakeConstraints {
                $0.leading.equalToSuperview()
            }
            
            let viewHalfWidth = self.view.bounds.width / 2.0
            let headerHalfWidth = 264.0 / 2.0
            self.header.naviImage.snp.remakeConstraints {
                $0.trailing.equalToSuperview().inset(viewHalfWidth - headerHalfWidth)
            }
            self.header.layoutIfNeeded()
        }, completion: { _ in
            self.header.backButton.removeFromSuperview()
        })
    }
}

extension ExclPageController: UITextFieldDelegate {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            if controllCheck == 0 || controllCheck == 1 {
                self.pageViewController.view.snp.updateConstraints {
                    $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight + 16)
                }
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        if controllCheck == 2 {
            self.pageViewController.view.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
            }
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
