//
//  CSInfoVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/28.
//

import UIKit
import RxSwift
import RxCocoa

class CSInfoVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSInfoVM()
    
    let header = NaviHeader()
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView()
    let titleMessage = UILabel()
    let titleTextFiled = SPTextField()
    let textFiledCounter = UILabel()
    let textFiledNotice = UILabel()
    
    let totalAmountTitleMessage = UILabel()
    let totalAmountTextFiled = SPTextField()
    let totalAmountTextFiledNotice = UILabel()
    
    let nextButton = NewSPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
        setKeyboardNotification()
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            
        }
        
        header.do {
            $0.applyStyle(.csTitle)
            $0.setBackButtonToRootView(viewController: self)
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
            
            $0.rx.controlEvent(.editingDidBegin)
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.titleTextFiled.becomeFirstResponder()
                })
                .disposed(by: disposeBag)
            
            $0.rx.controlEvent(.editingDidEndOnExit)
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.totalAmountTextFiled.becomeFirstResponder()
                })
                .disposed(by: disposeBag)
        }
        
        textFiledNotice.do {
            $0.text = "ex) 광란의 곱창팟, 집들이 장보기, 노래방"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        textFiledCounter.do {
            $0.font = .KoreanCaption1
        }
        
        totalAmountTitleMessage.do {
            $0.text = "총 얼마를 사용하셨나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        totalAmountTextFiled.do {
            $0.applyStyle(.number)
            $0.font = .KoreanTitle3
            
            $0.rx.controlEvent(.editingDidBegin)
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.totalAmountTextFiled.becomeFirstResponder()
                })
                .disposed(by: disposeBag)
        }
        
        totalAmountTextFiledNotice.do {
            $0.text = "설마, 천만원 이상을 쓰시진 않으셨죠?"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        nextButton.do {
            $0.setTitle("다음으로", for: .normal)
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
        }
    }
    
    func setLayout() {
        [header, scrollView].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(contentView)
        
        [titleMessage, titleTextFiled, textFiledCounter, textFiledNotice, nextButton, totalAmountTitleMessage, totalAmountTextFiled, totalAmountTextFiledNotice].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview()
        }
        
        titleTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        textFiledCounter.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(8)
            $0.trailing.equalTo(titleTextFiled.snp.trailing).inset(6)
        }
        
        textFiledNotice.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(12)
        }
        
        totalAmountTitleMessage.snp.makeConstraints {
            $0.top.equalTo(textFiledNotice.snp.bottom).offset(24)
            $0.leading.equalTo(titleMessage.snp.leading)
        }
        
        totalAmountTextFiled.snp.makeConstraints {
            $0.top.equalTo(totalAmountTitleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        totalAmountTextFiledNotice.snp.makeConstraints {
            $0.top.equalTo(totalAmountTextFiled.snp.bottom).offset(8)
            $0.leading.equalTo(textFiledNotice.snp.leading)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(27)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = CSInfoVM.Input(nextButtonTapped: nextButton.rx.tap,
                                         title: titleTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input)
        
        output.showCSTotalAmountView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vc = CSTotalAmountInputVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        output.titleCount
            .drive(textFiledCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.textFieldIsEmpty
            .drive(nextButton.buttonState)
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

extension CSInfoVC: UITextFieldDelegate {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.scrollView.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight)
            }
        }
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide() {
        self.scrollView.snp.updateConstraints {
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
