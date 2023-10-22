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
    
    let header = NaviHeader()
    let titleMessage = UILabel()
    let titleTextFiled = SPTextField()
    let textFiledCounter = UILabel()
    let textFiledNotice = UILabel()
    let nextButton = SPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeyboardNotification()
        self.titleTextFiled.becomeFirstResponder()
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(.csTitle)
            $0.setBackButton(viewController: self)
        }
        
        titleMessage.do {
            $0.text = "어디에 돈을 쓰셨나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        titleTextFiled.do {
            $0.applyStyle(.normal)
            $0.font = .KoreanTitle3
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
        
        textFiledNotice.do {
            $0.text = "여기에 사용을 돕는 문구가 들어가요"
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        textFiledCounter.do {
            $0.font = .KoreanCaption2
        }
        
        nextButton.do {
            $0.setTitle("다음으로", for: .normal)
            $0.applyStyle(.deactivate )
        }
    }
    
    func setLayout() {
        [header,titleMessage,titleTextFiled,textFiledCounter,textFiledNotice,nextButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        titleTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
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
                nextButton.applyStyle(.primaryWatermelonPressed)
                let vc = CSTotalAmountInputVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showCSTotalAmountView
            .delay(.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                nextButton.applyStyle(.primaryWatermelon)
            })
            .disposed(by: disposeBag)
        
        output.titleCount
            .drive(textFiledCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.titleCount
            .distinctUntilChanged()
            .drive(onNext: { str in
                guard let count = str.first else { return }
                self.nextButton.applyStyle(count == "0" ? .deactivate : .primaryWatermelon)
            })
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.textFiledCounter.textColor = isValid
                ? .TextSecondary
                : .AppColorStatusError
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
        }
    }
    
    @objc private func keyboardWillHide() {
        self.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
