//
//  File.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/23.
//

import UIKit
import Then
import SnapKit

class ExclEditPageController: UIViewController, ExclItemNamePageChangeDelegate, ExclItemPricePageChangeDelegate {
    let header = NaviHeader()
    
    var exclItemNameInputVC: ExclItemNameEditVC {
        return ExclItemNameEditVC(viewModel: ExclItemNameEditVM())
    }
    var exclItemPriceInputVC: ExclItemPriceEditVC {
        return ExclItemPriceEditVC(viewModel: ExclItemPriceEditVM())
    }
    var exclMemberVC: ExclMemberEditVC {
        return ExclMemberEditVC(viewModel: ExclMemberEditVM())
    }
    
    let indexPath: IndexPath = []
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
        let action = UIAction { _ in self.changePageToSecondViewReverse() }
//        header.setBackButton(action: action)
    }
    
    func changePageToSecondViewReverse() {
        controllCheck = 1
        self.pageViewController.setViewControllers([self.vcArr[1]], direction: .reverse, animated: true, completion: nil)
        let action = UIAction { _ in self.changePageToFirstView() }
//        header.setBackButton(action: action)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.exclItemPriceInputVC.priceTextField.becomeFirstResponder()
        }
    }
    
    func changePageToSecondView() {
        self.pageViewController.setViewControllers([self.vcArr[1]], direction: .forward, animated: true, completion: nil)
        let action = UIAction { _ in self.changePageToFirstView() }
//        header.setBackButton(action: action)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.exclItemPriceInputVC.priceTextField.becomeFirstResponder()
        }
    }
    
    func changePageToFirstView() {
        self.pageViewController.setViewControllers([self.vcArr[0]], direction: .reverse, animated: true, completion: nil)
//        header.setBackButton(viewController: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.exclItemNameInputVC.nameTextFiled.becomeFirstResponder()
        }
    }
    
    private func setLayout() {
        addChild(pageViewController)
        
        header.isHidden = true
        
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

extension ExclEditPageController: UITextFieldDelegate {
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
