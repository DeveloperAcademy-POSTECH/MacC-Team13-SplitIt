//
//  CSTitleInputVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/15.
//

import UIKit
import RxSwift
import RxCocoa

class CSTitleInputVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSTitleInputVM()
    
    let titleMessage = UILabel()
    let titleTextFiled = UITextField()
    let textFiledCounter = UILabel()
    let textFiledNotice = UILabel()
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
        setKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.titleTextFiled.becomeFirstResponder()
    }

    func setAttribute() {
        view.backgroundColor = .systemBackground
        
        titleMessage.do {
            $0.text = "어디에 돈을 쓰셨나요?"
        }
        
        titleTextFiled.do {
            $0.backgroundColor = UIColor(hex: 0xD9D9D9)
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor(hex: 0xAFB1B6).cgColor
            $0.layer.borderWidth = 1
            $0.textAlignment = .center
        }
        
        textFiledNotice.do {
            $0.text = "여기에 사용을 돕는 문구가 들어가요"
        }
        
        nextButton.do {
            $0.setTitle("다음으로", for: .normal)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = UIColor(hex: 0x19191B)
        }
    }
    
    func setLayout() {
        [titleMessage,titleTextFiled,textFiledCounter,textFiledNotice,nextButton].forEach {
            view.addSubview($0)
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        titleTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(53)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        
        textFiledCounter.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(6)
            $0.trailing.equalTo(titleTextFiled.snp.trailing).inset(5)
        }
        
        textFiledNotice.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = CSTitleInputVM.Input(nextButtonTapped: nextButton.rx.tap,
                                           title: titleTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
        
        let output = viewModel.transform(input: input)
            
        output.showCSTotalAmountView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
//                let vc = CSTotalAmountVC()
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.titleCount
            .drive(textFiledCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.textFiledCounter.textColor = isValid
                ? UIColor(hex: 0xCCCCCC)
                : UIColor(hex: 0xFF3030)
            })
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .map { [weak self] isValid -> String in
                guard let self = self else { return "" }
                if !isValid {
                    return String(self.titleTextFiled.text?.prefix(self.viewModel.maxTextCount) ?? "")
                } else {
                    return self.titleTextFiled.text ?? ""
                }
            }
            .drive(titleTextFiled.rx.text)
            .disposed(by: disposeBag)
    }
}

extension CSTitleInputVC: UITextFieldDelegate {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.nextButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight + 26)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide() {
        self.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        self.view.layoutIfNeeded()
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func setKeyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
