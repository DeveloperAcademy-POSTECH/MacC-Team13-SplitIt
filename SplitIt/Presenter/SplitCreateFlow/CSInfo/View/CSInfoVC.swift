//
//  CSInfoVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/28.
//

import UIKit
import RxSwift
import RxCocoa

class CSInfoVC: UIViewController, SPAlertDelegate {
    
    let inputTextRelay = BehaviorRelay<Int?>(value: 0)
    let customKeyboard = CustomKeyboard()
//    let backAlert = SPAlertController()
    let exitAlert = SPAlertController()
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSInfoVM()

    let header = SPNavigationBar()
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView()
    let titleMessage = UILabel()
    let titleTextFiled = SPTextField()
    let textFiledCounter = UILabel()
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
        setKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        unfocusTitleTF()
        focusTotalAmountTF()
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
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.returnKeyType = .next
            self.titleTextFiled.applyStyle(.editingDidEndNormal)
            $0.placeholder = "ex) 회식, 노래방, 생일파티"
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
            $0.textColor = .TextDeactivate
        }
        
        totalAmountTextFiledNotice.do {
            $0.text = "천만원 이상은 입력할 수 없어요"
            $0.font = .KoreanCaption1
            $0.textColor = .SurfaceWarnRed
            $0.isHidden = true
        }
        
        nextButton.do {
            $0.setTitle("다음으로", for: .normal)
            $0.applyStyle(style: .primaryMushroom, shape: .rounded)
        }
    }
    
    func setLayout() {
        [header, scrollView].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(contentView)
        
        [titleMessage, titleTextFiled, textFiledCounter, nextButton, totalAmountTitleMessage, totalAmountTextFiled, totalAmountTextFiledNotice].forEach {
            contentView.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
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
        
        titleMessage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(8)
        }
        
        titleTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        textFiledCounter.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(4)
            $0.trailing.equalTo(titleTextFiled.snp.trailing).inset(6)
        }
        
        totalAmountTitleMessage.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(24)
            $0.leading.equalTo(titleMessage.snp.leading)
        }
        
        totalAmountTextFiled.snp.makeConstraints {
            $0.top.equalTo(totalAmountTitleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        totalAmountTextFiledNotice.snp.makeConstraints {
            $0.leading.equalTo(totalAmountTitleMessage)
            $0.top.equalTo(totalAmountTextFiled.snp.bottom).offset(8)
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
                                   totalAmountTextFieldControlEvent: totalAmountTFEvent,
                                   exitButtonTapped: header.rightButton.rx.tap,
                                   backButtonTapped: header.leftButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // MARK: Title
        output.initialTitle
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                titleTextFiled.text = $0
                titleTextFiled.sendActions(for: .valueChanged)
            })
            .disposed(by: disposeBag)
        
        output.titleCount
            .drive(textFiledCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.titleTextFieldIsValid
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.textFiledCounter.textColor = isValid
                ? .TextSecondary
                : .AppColorStatusError
            })
            .disposed(by: disposeBag)
        
        output.titleTextFieldIsValid
            .asDriver()
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

        // MARK: TotalAmount
        output.totalAmountTextFieldIsValid
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                UIView.transition(with: self.totalAmountTextFiledNotice, duration: 0.33, options: .transitionCrossDissolve) {
                    self.totalAmountTextFiledNotice.isHidden = isValid
                }
            })
            .disposed(by: disposeBag)
        
        output.totalAmount
            .drive(totalAmountTextFiled.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: Animation
        output.titleTextFieldControlEvent
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .editingDidBegin:
                    focusTitleTF(output: output)
                    unfocusTotalAmountTF()
                case .editingDidEnd:
                    focusTotalAmountTF()
                    unfocusTitleTF()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: BackAlert
//        output.showBackAlert
//            .drive(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                showAlert(view: backAlert,
//                          type: .warnNormal,
//                          title: "정산 방법을 다시 선택하시겠어요?",
//                          descriptions: "지금까지 정산하신 내역이 사라져요",
//                          leftButtonTitle: "취 소",
//                          rightButtonTitle: "다시 선택")
//            })
//            .disposed(by: disposeBag)
        
//        backAlert.rightButtonTapSubject
//            .asDriver(onErrorJustReturn: ())
//            .drive(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                self.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: disposeBag)
        
        // MARK: ExitAlert
        output.showExitAlert
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                showExitAlert(view: exitAlert)
            })
            .disposed(by: disposeBag)
        
        exitAlert.rightButtonTapSubject
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // MARK: NextButton
        output.nextButtonIsEnable
            .drive(nextButton.buttonState)
            .disposed(by: disposeBag)
        
        output.showCSMemberView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vc = NewCSMemberVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: TextField (활성화/비활성화)에 따른 UI 로직
extension CSInfoVC {
    func focusTitleTF(output: CSInfoVM.Output) {
        self.titleTextFiled.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.33) {
            self.titleTextFiled.applyStyle(.editingDidBeginNormal)
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.titleMessage.textColor = .TextPrimary
            self.titleTextFiled.textColor = .TextPrimary
            
            // Title이 focus 될 때는 경고창이 안보여야함
            self.totalAmountTextFiledNotice.isHidden = true
            self.textFiledCounter.textColor = output.titleTextFieldIsValid.value
            ? .TextSecondary
            : .AppColorStatusError
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

extension CSInfoVC {
    func setKeyboardObserver() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let self = self else { return }
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    let keyboardHeight: CGFloat
                    keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom

                    self.scrollView.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight)
                    }
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
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
