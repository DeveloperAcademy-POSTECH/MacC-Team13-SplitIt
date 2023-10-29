//
//  CSTotalAmountEditVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class CSTotalAmountEditVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSTotalAmountEditVM()
    
    let header = NaviHeader()
    let titleMessage = UILabel()
    let totalAmountTextFiled = UITextField()
    let currencyLabel = UILabel()
    let textFiledNotice = UILabel()
    let nextButton = NewSPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeyboardNotification()
        self.totalAmountTextFiled.becomeFirstResponder()
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.applyStyle(.edit)
            $0.setBackButton(viewController: self)
        }
        
        titleMessage.do {
            $0.text = "총 얼마를 사용하셨나요?"
            $0.tintColor = .TextPrimary
            $0.font = .KoreanBody
        }
        
        totalAmountTextFiled.do {
            $0.font = .KoreanTitle3
            $0.keyboardType = .numberPad
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.textAlignment = .center
        }
        
        currencyLabel.do {
            $0.text = "KRW"
            $0.font = .KoreanTitle3
        }
        
        textFiledNotice.do {
            $0.text = "여기에 사용을 돕는 문구가 들어가요"
        }
        
        nextButton.do {
            $0.setTitle("저장하기", for: .normal)
            $0.applyStyle(style: .primaryPear, shape: .rounded)
            $0.buttonState.accept(true)
        }
    }
    
    func setLayout() {
        [header,titleMessage,totalAmountTextFiled,textFiledNotice,nextButton].forEach {
            view.addSubview($0)
        }
        
        totalAmountTextFiled.addSubview(currencyLabel)
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        totalAmountTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(53)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        
        currencyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        textFiledNotice.snp.makeConstraints {
            $0.top.equalTo(totalAmountTextFiled.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = CSTotalAmountEditVM.Input(nextButtonTapped: nextButton.rx.tap.asDriver(),
                                               totalAmount: totalAmountTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input)
        
        output.totalAmount
            .drive(totalAmountTextFiled.rx.text)
            .disposed(by: disposeBag)
        
        output.showCSMemberInputView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
//                self.nextButton.applyStyle(.primaryPearPressed)
                self.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
        
        output.totalAmountString
            .bind(to: totalAmountTextFiled.rx.text)
            .disposed(by: disposeBag)
    }
}

extension CSTotalAmountEditVC: UITextFieldDelegate {
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

