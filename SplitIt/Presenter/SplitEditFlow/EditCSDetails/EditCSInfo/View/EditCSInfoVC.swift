//
//  EditCSInfoVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/11/03.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxGesture

class EditCSInfoVC: UIViewController, SPAlertDelegate {
    
    let inputTextRelay = BehaviorRelay<Int?>(value: 0)
    let customKeyboard = CustomKeyboard()
    
    var disposeBag = DisposeBag()
    
    let viewModel = EditCSInfoVM()

    let header = SPNavigationBar()
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView()
    let titleMessage = UILabel()
    let titleTextFiled = SPTextField()
    let textFiledCounter = UILabel()
    let totalAmountTitleMessage = UILabel()
    let totalAmountTextFiled = SPTextField()
    let totalAmountTextFiledNotice = UILabel()
    let backAlert = SPAlertController()
    let backLeftEdgePanGesture = UIScreenEdgePanGestureRecognizer()
    
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
        
        titleTextFiled.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.delaysContentTouches = false
        }
        
        header.do {
            $0.applyStyle(style: .editCSInfo, vc: self)
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
            $0.textColor = .TextDeactivate
        }
        
        totalAmountTextFiledNotice.do {
            $0.text = "천만원 이상은 입력할 수 없어요"
            $0.font = .KoreanCaption1
            $0.textColor = .SurfaceWarnRed
            $0.isHidden = true
        }
        
        backLeftEdgePanGesture.do {
            $0.edges = .left
        }
    }
    
    func setLayout() {
        [header, scrollView].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(contentView)
        
        [titleMessage, titleTextFiled, textFiledCounter, totalAmountTitleMessage, totalAmountTextFiled, totalAmountTextFiledNotice].forEach {
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
    }
    
    func setBinding() {
        // MARK: Alert가 존재할 때 Swipe Back Left Side 감지
        let swipeBackLeftSideObservable = backLeftEdgePanGesture.rx.event
            .when(.recognized)
        
        let titleTFEvent = Observable.merge(
            titleTextFiled.rx.controlEvent(.editingDidBegin).map { UIControl.Event.editingDidBegin},
            titleTextFiled.rx.controlEvent(.editingDidEnd).map { UIControl.Event.editingDidEnd },
            titleTextFiled.rx.controlEvent(.editingDidEndOnExit).map { UIControl.Event.editingDidEndOnExit })
        
        let totalAmountTFEvent = Observable.merge(
            totalAmountTextFiled.rx.controlEvent(.editingDidBegin).map { UIControl.Event.editingDidBegin},
            totalAmountTextFiled.rx.controlEvent(.editingDidEnd).map { UIControl.Event.editingDidEnd })
        
        let input = EditCSInfoVM.Input(confirmButtonTapped: header.rightButton.rx.tap,
                                       title: titleTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""),
                                       totalAmount: totalAmountTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""),
                                       titleTextFieldControlEvent: titleTFEvent,
                                       totalAmountTextFieldControlEvent: totalAmountTFEvent,
                                       backButtonTapped: header.leftButton.rx.tap,
                                       swipeBack: swipeBackLeftSideObservable)
        let output = viewModel.transform(input: input)
        
        output.titleString
            .drive(titleTextFiled.rx.text)
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

        
        
        Driver.combineLatest(output.totalAmountTextFieldIsValid,
                           output.totalAmountTextFieldMinIsValid)
        .drive(onNext: { [weak self] isValid, isMinValid in
            guard let self = self else { return }
            if !isValid {
                UIView.transition(with: self.totalAmountTextFiledNotice, duration: 0.33, options: .transitionCrossDissolve) {
                    self.totalAmountTextFiledNotice.isHidden = false
                    self.totalAmountTextFiledNotice.text = "천만원 이상은 입력할 수 없어요"
                }
            } else if !isMinValid {
                UIView.transition(with: self.totalAmountTextFiledNotice, duration: 0.33, options: .transitionCrossDissolve) {
                    self.totalAmountTextFiledNotice.isHidden = false
                    self.totalAmountTextFiledNotice.text = "총 금액은 제외 항목의 총합보다 커야해요"
                }
            } else {
                UIView.transition(with: self.totalAmountTextFiledNotice, duration: 0.33, options: .transitionCrossDissolve) {
                    self.totalAmountTextFiledNotice.isHidden = true
                }
            }
        })
        .disposed(by: disposeBag)
        
        output.totalAmount
            .drive(totalAmountTextFiled.rx.text)
            .disposed(by: disposeBag)
        
        output.confirmButtonIsEnable
            .drive(header.buttonState)
            .disposed(by: disposeBag)
        
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
        
        output.isEdited
            .asDriver()
            .drive(onNext: { [weak self] isEdited in
                guard let self = self else { return }
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = !isEdited
                
                if isEdited {
                    view.addGestureRecognizer(self.backLeftEdgePanGesture)
                } else {
                    view.removeGestureRecognizer(self.backLeftEdgePanGesture)
                }
            })
            .disposed(by: disposeBag)
        
        output.showBackAlert
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if output.isEdited.value {
                    self.showAlert(view: self.backAlert,
                                   type: .warnNormal,
                                   title: "수정을 중단하시겠어요?",
                                   descriptions: "지금까지 수정하신 내역이 사라져요",
                                   leftButtonTitle: "취 소",
                                   rightButtonTitle: "중단하기")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.saveCSInfo
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.sendConfirmToastMessage()
            })
            .disposed(by: disposeBag)
        
        backAlert.rightButtonTapSubject
            .asDriver(onErrorJustReturn: ())
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: TextField (활성화/비활성화)에 따른 UI 로직
extension EditCSInfoVC {
    func focusTitleTF(output: EditCSInfoVM.Output) {
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

extension EditCSInfoVC {
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

extension EditCSInfoVC: CustomKeyboardDelegate {
    func textFieldCustomKeyboard() {
        totalAmountTextFiled.inputView = customKeyboard.inputView
        customKeyboard.delegate = self
        customKeyboard.setCurrentTextField(totalAmountTextFiled)
        customKeyboard.applyOption(.price)
        customKeyboard.customKeyObservable
            .subscribe(onNext: { [weak self] value in
                self?.customKeyboard.handleInputValue(value)
                self?.inputTextRelay.accept(Int(self?.totalAmountTextFiled.text ?? ""))
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Send ToastMessage
extension EditCSInfoVC {
    func sendConfirmToastMessage() {
        NotificationCenter.default.post(name: Notification.Name("ToeastMessage"), object: nil)
    }
}
