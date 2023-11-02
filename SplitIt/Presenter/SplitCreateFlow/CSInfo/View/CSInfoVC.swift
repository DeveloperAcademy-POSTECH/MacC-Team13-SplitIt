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
    
    let inputTextRelay = BehaviorRelay<Int?>(value: 0)
    let customKeyboard = CustomKeyboard()
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSInfoVM()

    let header = SPNavigationBar()
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
        textFieldCustomKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyboardNotification()
        titleTextFiled.becomeFirstResponder()
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.delaysContentTouches = false
        }
        
        header.do {
            $0.applyStyle(style: .csInfoCreate, vc: self)
        }
        
        titleMessage.do {
            $0.text = "어디에 돈을 쓰셨나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextDeactivate
        }
        
        titleTextFiled.do {
            $0.font = .KoreanCaption1
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.returnKeyType = .next
            self.titleTextFiled.applyStyle(.editingDidEndNormal)
            $0.placeholder = "ex) 광란의 곱창팟, 집들이 장보기, 노래방"
        }

        textFiledCounter.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextDeactivate
        }
        
        totalAmountTitleMessage.do {
            $0.text = "총 얼마를 사용하셨나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextDeactivate
        }
        
        totalAmountTextFiled.do {
            $0.applyStyle(.editingDidEndNumber)
            $0.font = .KoreanSubtitle
            $0.textColor = .TextDeactivate
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
        
        [titleMessage, titleTextFiled, textFiledCounter, nextButton, totalAmountTitleMessage, totalAmountTextFiled].forEach {
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
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview()
        }
        
        titleTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        textFiledCounter.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(8)
            $0.trailing.equalTo(titleTextFiled.snp.trailing).inset(6)
        }
        
        totalAmountTitleMessage.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(24)
            $0.leading.equalTo(titleMessage.snp.leading)
        }
        
        totalAmountTextFiled.snp.makeConstraints {
            $0.top.equalTo(totalAmountTitleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
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
        let titleTFEvent = Observable.merge(
            titleTextFiled.rx.controlEvent(.editingDidBegin).map { UIControl.Event.editingDidBegin},
            titleTextFiled.rx.controlEvent(.editingDidEnd).map { UIControl.Event.editingDidEnd },
            titleTextFiled.rx.controlEvent(.editingDidEndOnExit).map { UIControl.Event.editingDidEndOnExit })
        
        let totalAmountTFEvent = Observable.merge(
            totalAmountTextFiled.rx.controlEvent(.editingDidBegin).map { UIControl.Event.editingDidBegin},
            totalAmountTextFiled.rx.controlEvent(.editingDidEnd).map { UIControl.Event.editingDidEnd })
        
        let input = CSInfoVM.Input(nextButtonTapped: nextButton.rx.tap,
                                   title: titleTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""),
                                   totalAmount: totalAmountTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""),
                                   titleTextFieldControlEvent: titleTFEvent,
                                   totalAmountTextFieldControlEvent: totalAmountTFEvent)
        let output = viewModel.transform(input: input)
        
        output.showCSMemberView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vc = CSMemberVC()
                self.navigationController?.pushViewController(vc, animated: true)
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
        
        output.totalAmount
            .drive(totalAmountTextFiled.rx.text)
            .disposed(by: disposeBag)
        
        output.nextButtonIsEnable
            .drive(nextButton.buttonState)
            .disposed(by: disposeBag)
        
        output.titleTextFieldControlEvent
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .editingDidBegin:
                    focusTitleTF()
                    unfocusTotalAmountTF()
                case .editingDidEnd:
                    focusTotalAmountTF()
                    unfocusTitleTF()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: TextField (활성화/비활성화)에 따른 UI 로직
extension CSInfoVC {
    func focusTitleTF() {
        self.titleTextFiled.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.33) {
            self.titleTextFiled.applyStyle(.editingDidBeginNormal)
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.titleMessage.textColor = .TextPrimary
            self.titleTextFiled.textColor = .TextPrimary
            self.textFiledCounter.textColor = .TextSecondary
        }
        
        view.layoutIfNeeded()
    }
    
    func unfocusTitleTF() {
        self.titleTextFiled.applyStyle(.editingDidEndNormal)
        
        self.titleMessage.textColor = .TextDeactivate
        self.titleTextFiled.textColor = .TextDeactivate
        self.textFiledCounter.textColor = .TextDeactivate
    }
    
    func focusTotalAmountTF() {
        self.totalAmountTextFiled.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.33) {
            self.totalAmountTextFiled.applyStyle(.editingDidBeginNumber)
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.totalAmountTitleMessage.textColor = .TextPrimary
            self.totalAmountTextFiled.textColor = .TextPrimary
            self.totalAmountTextFiled.currencyLabel.textColor = .TextPrimary
        }
        
        view.layoutIfNeeded()
    }
    
    func unfocusTotalAmountTF() {
        self.totalAmountTextFiled.applyStyle(.editingDidEndNumber)
        
        self.totalAmountTitleMessage.textColor = .TextDeactivate
        self.totalAmountTextFiled.textColor = .TextDeactivate
        self.totalAmountTextFiled.currencyLabel.textColor = .TextDeactivate
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

extension CSInfoVC: CustomKeyboardDelegate {
    func textFieldCustomKeyboard() {
        totalAmountTextFiled.inputView = customKeyboard.inputView
        customKeyboard.delegate = self
        customKeyboard.setCurrentTextField(totalAmountTextFiled)
        customKeyboard.customKeyObservable
            .subscribe(onNext: { [weak self] value in
                self?.customKeyboard.handleInputValue(value)
                self?.inputTextRelay.accept(Int(self?.totalAmountTextFiled.text ?? ""))
            })
            .disposed(by: disposeBag)
    }
}
