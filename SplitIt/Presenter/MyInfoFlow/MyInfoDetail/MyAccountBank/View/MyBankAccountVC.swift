//
//  MyAccountBankVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class MyBankAccountVC: UIViewController, SPAlertDelegate, CustomKeyboardDelegate {

    let bankValue = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: "userBank")!)
    let accountTextRelay = BehaviorRelay<String?>(value: UserDefaults.standard.string(forKey: "userAccount"))
    //let isChanged = BehaviorRelay<Bool>(value: false)
    var changedToss = false
    var changedKakao = false
    var changedNaver = false
    
    let accountCustomKeyboard = CustomKeyboard()
    
    let alert = SPAlertController()
    let backAlert = SPAlertController()
    
    let viewModel = MyBankAccountVM()
    var disposeBag = DisposeBag()
    let maxCharacterCount = 8
    let maxAccountCount = 17
    let userDefault = UserDefaults.standard
    
    let header = SPNavigationBar()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let bankSelectedView = UIView()

    let bankTextField = SPTextField()
    let bankArrowImage = UIImageView()
    let bankLabel = UILabel()
    
    let accountLabel = UILabel()
    let accountTextField = SPTextField()
    let accountCountLabel = UILabel()
    
    var nameLabel = UILabel()
    var nameTextField = SPTextField()
    var nameCountLabel = UILabel()
    
    let payLabel = UILabel()
    
    let payView = UIView()
    let leftBar = UIView()
    let rightBar = UIView()
    
    let tossPayBtn = UIImageView()
    let kakaoPayBtn = UIImageView()
    let naverPayBtn = UIImageView()
    
    let tossLabel = UILabel()
    let kakaoLabel = UILabel()
    let naverLabel = UILabel()
    
    let tossPayView = UIView()
    let kakaoPayView = UIView()
    let naverPayView = UIView()
    
    let deleteBtn = UIButton()
    
    let backLeftEdgePanGesture = UIScreenEdgePanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddView()
        setLayout()
        setAttribute()
        selectedBankViewAttribute()
        setBinding()
        accountTextFieldCustomKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    func accountTextFieldCustomKeyboard() {
        accountTextField.inputView = accountCustomKeyboard.inputView
        accountCustomKeyboard.delegate = self
        accountCustomKeyboard.setCurrentTextField(accountTextField)
        accountCustomKeyboard.applyOption(.account)
        
        accountCustomKeyboard.customKeyObservable
            .subscribe(onNext: { [weak self] value in
                self?.accountCustomKeyboard.handleInputValue(value)
                self?.accountTextRelay.accept((self?.accountTextField.text)!)
            })
            .disposed(by: disposeBag)
    }
    
    func setBackAlert() {
        showAlert(view: backAlert,
                type: .warnNormal,
                title: "입력을 중단하시겠어요?",
                descriptions: "지금까지 작성하신 내역이 사라져요",
                leftButtonTitle: "취 소",
                rightButtonTitle: "중단하기")

        backAlert.rightButtonTapSubject
              .asDriver(onErrorJustReturn: ())
              .drive(onNext: { [weak self] in
                  self?.navigationController?.popViewController(animated: true)
              })
              .disposed(by: disposeBag)
    }
  
    func updateViewLayout(text: String) {
        if text == "선택 안함" || text == "" {
            self.bankSelectedView.isHidden = true
            payLabel.snp.removeConstraints()
            payLabel.snp.makeConstraints {
                $0.top.equalTo(bankTextField.snp.bottom).offset(24)
                $0.leading.equalTo(payView.snp.leading).inset(6)
            }
        } else {
            self.bankSelectedView.isHidden = false
            payLabel.snp.removeConstraints()
            bankSelectedView.snp.updateConstraints { make in
                make.height.equalTo(178)
            }
            payLabel.snp.makeConstraints {
                $0.top.equalTo(bankSelectedView.snp.bottom).offset(24)
                $0.leading.equalTo(payView.snp.leading).inset(6)
            }
        }
    }
    
    func selectedBankViewAttribute() {
        if UserDefaults.standard.string(forKey: "userBank") == "" ||  UserDefaults.standard.string(forKey: "userBank") == "선택 안함" {
            bankSelectedView.isHidden = true
            payLabel.snp.makeConstraints {
                $0.top.equalTo(bankTextField.snp.bottom).offset(24)
                $0.leading.equalTo(payView.snp.leading).inset(6)
            }
        } else {
            bankSelectedView.isHidden = false
            payLabel.snp.makeConstraints {
                $0.top.equalTo(bankSelectedView.snp.bottom).offset(24)
                $0.leading.equalTo(payView.snp.leading).inset(6)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "tossPay") == nil {
            UserDefaults.standard.set(false, forKey: "tossPay")}
        if UserDefaults.standard.object(forKey: "kakaoPay") == nil {
            UserDefaults.standard.set(false, forKey: "kakaoPay")}
        if UserDefaults.standard.object(forKey: "naverPay") == nil {
            UserDefaults.standard.set(false, forKey: "naverPay")}
        if UserDefaults.standard.object(forKey: "userAccount") == nil {
            UserDefaults.standard.set("", forKey: "userAccount")}
        if UserDefaults.standard.object(forKey: "userName") == nil {
            UserDefaults.standard.set("", forKey: "userName")}
        if UserDefaults.standard.object(forKey: "userBank") == nil {
            UserDefaults.standard.set("", forKey: "userBank")}
    }

    func setBinding() {
        
        let swipeBackLeftSideObservable = backLeftEdgePanGesture.rx.event
            .when(.recognized)
        
       
        let selectedBankTap = addTapGesture(to: bankTextField)
        let tossTap = addTapGesture(to: tossPayView)
        let kakaoTap = addTapGesture(to: kakaoPayView)
        let naverTap = addTapGesture(to: naverPayView)
        
        let input = MyBankAccountVM.Input(inputRealNameText: nameTextField.rx.text.orEmpty.asDriver(),
                                          editDoneBtnTapped: header.rightButton.rx.tap.asDriver(),
                                          selectBackTapped:
                                            selectedBankTap.rx.event.asObservable().map{ _ in () },
                                          inputAccountText: accountTextField.rx.text.orEmpty.asDriver(),
                                          tossTapped: tossTap.rx.event.asObservable().map { _ in () },
                                          kakaoTapeed: kakaoTap.rx.event.asObservable().map { _ in () },
                                          naverTapped: naverTap.rx.event.asObservable().map { _ in () },
                                          deleteBtnTapped: deleteBtn.rx.tap.asObservable(),
                                          cancelBtnTapped: header.leftButton.rx.tap.asObservable(),
                                          inputUserBankName: bankValue,
                                          swipeBack: swipeBackLeftSideObservable)
        let output = viewModel.transform(input: input)

        output.isChangedRelay
            .asDriver()
            .drive(onNext: { [weak self] shouldPop in
                guard let self = self else { return }
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = !shouldPop
                if shouldPop {
                    view.addGestureRecognizer(self.backLeftEdgePanGesture)
                } else {
                    view.removeGestureRecognizer(self.backLeftEdgePanGesture)
                }
            })
            .disposed(by: disposeBag)
        
        deleteBtn.rx.controlEvent([.touchDown])
            .subscribe(onNext: {
                self.deleteBtn.backgroundColor = UIColor(hex: 0xF8F0ED)
            })
            .disposed(by: disposeBag)
        
        deleteBtn.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                self.deleteBtn.backgroundColor = .clear
            })
            .disposed(by: disposeBag)
        
        UserDefaults.standard.rx.observe(String.self, "userBank")
            .subscribe(onNext: { [weak self] userBank in
                guard let self = self else { return }
                let isHidden = userBank == nil || userBank?.isEmpty == true
                self.deleteBtn.isHidden = isHidden
            })
            .disposed(by: disposeBag)
        
        output.showBankModel
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let modalVC = BankListModalVC()
                modalVC.modalPresentationStyle = .formSheet
                modalVC.modalTransitionStyle = .coverVertical
                modalVC.selectedBankName
                    .bind { bankName in
                        self.bankValue.accept(bankName)
                        self.accountTextField.text = ""
                        self.nameTextField.text = ""
                        self.bankTextField.text = bankName != "" ? bankName : "은행을 선택해주세요"
                        self.updateViewLayout(text: bankName)
                    }
                    .disposed(by: modalVC.disposeBag)
                self.present(modalVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.toggleTossPay
            .subscribe(onNext: { [weak self] isToggled in
                guard let self = self else { return }
                let newImage = isToggled ? "TossPayIconChecked" : "TossPayIconUnchecked"
                self.changedToss = isToggled
                self.tossPayBtn.image = UIImage(named: newImage)
            })
            .disposed(by: disposeBag)
        
        output.toggleKakaoPay
            .subscribe(onNext: { [weak self] isToggled in
                guard let self = self else { return }
                let newImage = isToggled ? "KakaoPayIconChecked" : "KakaoPayIconUnchecked"
                self.changedKakao = isToggled
                self.kakaoPayBtn.image = UIImage(named: newImage)
            })
            .disposed(by: disposeBag)
        
        output.toggleNaverPay
            .subscribe(onNext: { [weak self] isToggled in
                guard let self = self else { return }
                let newImage = isToggled ? "NaverPayIconChecked" : "NaverPayIconUnchecked"
                self.changedNaver = isToggled
                self.naverPayBtn.image = UIImage(named: newImage)
            })
            .disposed(by: disposeBag)
        
        output.isSaveButtonEnable
            .asDriver()
            .drive(header.rightButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.cancelBackToView
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if output.isChangedRelay.value {
                    self.setBackAlert()
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.deleteButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.showAlert(view: alert,
                               type: .warnNormal,
                               title: "나의 정보를 초기화 하시겠어요?",
                               descriptions: "이 작업은 돌이킬 수 없어요",
                               leftButtonTitle: "취 소",
                               rightButtonTitle: "초기화")
            })
            .disposed(by: disposeBag)
        
        alert.rightButtonTapSubject
              .asDriver(onErrorJustReturn: ())
              .drive(onNext: {
                  UserDefaults.standard.set(false, forKey: "tossPay")
                  UserDefaults.standard.set(false, forKey: "kakaoPay")
                  UserDefaults.standard.set(false, forKey: "naverPay")
                  UserDefaults.standard.set("", forKey: "userAccount")
                  UserDefaults.standard.set("", forKey: "userName")
                  UserDefaults.standard.set("", forKey: "userBank")
                  
                  self.navigationController?.popViewController(animated: true)
              })
              .disposed(by: disposeBag)
        
        output.nameTextCount
            .asDriver()
            .drive(nameCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.inputRealNameText
            .asDriver()
            .drive(nameTextField.rx.value)
            .disposed(by: disposeBag)
        
        output.inputRealNameTextColor
            .asDriver()
            .drive(nameCountLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.accountTextCount
            .asDriver()
            .drive(accountCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.inputAccountTextColor
            .asDriver()
            .drive(accountCountLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.inputAccountText
            .asDriver()
            .drive(accountTextField.rx.value)
            .disposed(by: disposeBag)
    }
    
    func addTapGesture(to view: UIView) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
    
    func setAttribute() {
        
        view.backgroundColor = .SurfaceBrandCalmshell
        contentView.backgroundColor = .SurfaceBrandCalmshell
        
        scrollView.do {
            $0.isScrollEnabled = false
            $0.contentSize = $0.bounds.size
            $0.backgroundColor = .SurfaceBrandCalmshell
        }
         
        header.do {
            if UserDefaults.standard.string(forKey: "MyInfoFlow") == "Setting" {
                $0.applyStyle(style: .settingToMyInfo, vc: self)
                $0.leftButton.removeTarget(nil, action: nil, for: .touchUpInside)
            } else {
                $0.applyStyle(style: .popUpToMyInfo, vc: self)
            }
        }
        
        bankLabel.do {
            $0.text = "은행"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        bankTextField.do {
            $0.placeholder = "은행을 선택해주세요"
            $0.applyStyle(.normal)
            $0.textColor = .TextPrimary
            if userDefault.string(forKey: "userBank") != nil || userDefault.string(forKey: "userBank") != "" {
                $0.text = userDefault.string(forKey: "userBank")
            }
        }

        bankArrowImage.do {
            $0.image = UIImage(named: "ArrowTriangleIconDown")
        }
        
        accountLabel.do {
            $0.text = "계좌번호"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = .TextSecondary
        }

        accountTextField.do {
            $0.placeholder = "계좌번호를 입력해주세요"
            $0.applyStyle(.normal)
            
            if userDefault.string(forKey: "userAccount") == nil || userDefault.string(forKey: "userAccount") == "" {
                $0.textColor = .TextPrimary
            } else {
                $0.text = userDefault.string(forKey: "userAccount")
                $0.textColor = .TextPrimary
            }
        }
        
        accountCountLabel.do {
            $0.font = UIFont.KoreanCaption1
            $0.textColor = UIColor.TextSecondary
        }
        
        nameLabel.do {
            $0.text = "예금주 성함"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        nameCountLabel.do {
            $0.font = UIFont.KoreanCaption1
            $0.textColor = UIColor.TextSecondary
        }
        
        nameTextField.do {
            $0.placeholder = "성함을 입력해주세요"
            $0.applyStyle(.normal)
            $0.clearButtonMode = .whileEditing
            
            if userDefault.string(forKey: "userName") == nil || userDefault.string(forKey: "userName") == "" {
                $0.textColor = .TextPrimary
            } else {
                $0.text = userDefault.string(forKey: "userName")
                $0.textColor = .TextPrimary
            }
        }
        
        payLabel.do {
            $0.text = "간편페이 사용여부"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextSecondary
        }
        
        leftBar.do {
            $0.backgroundColor = .BorderDeactivate
        }
        
        rightBar.do {
            $0.backgroundColor = .BorderDeactivate
        }
        
        payView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
        }
        
        tossPayBtn.do {
            $0.image = UIImage(named: "TossPayIconUnchecked")
        }
        
        kakaoPayBtn.do {
            $0.image = UIImage(named: "KakaoPayIconUnchecked")
        }
        
        naverPayBtn.do {
            $0.image = UIImage(named: "NaverPayIconUnchecked")
        }
        
        tossLabel.do {
            $0.text = "토스"
            $0.font = .KoreanCaption2
            $0.textAlignment = .center
            $0.textColor = .TextPrimary
        }
        
        kakaoLabel.do {
            $0.text = "카카오페이"
            $0.font = .KoreanCaption2
            $0.textAlignment = .center
            $0.textColor = .TextPrimary
        }
        
        naverLabel.do {
            $0.text = "네이버페이"
            $0.font = .KoreanCaption2
            $0.textAlignment = .center
            $0.textColor = .TextPrimary
        }
        
        let deleteString = NSAttributedString(string: "초기화하기", attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        
        deleteBtn.do {
            $0.titleLabel?.font = UIFont.KoreanButtonText
            $0.titleLabel?.textColor = UIColor.AppColorStatusWarnRed
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 0
            $0.setAttributedTitle(deleteString, for: .normal)
        }
        
        backLeftEdgePanGesture.do {
            $0.edges = .left
        }
    }
    
    func setLayout() {
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(scrollView)
            $0.bottom.equalToSuperview()
        }
                        
        bankSelectedView.snp.makeConstraints {
            $0.top.equalTo(bankTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(178)
        }
        
        bankLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(bankTextField.snp.leading).inset(6)
        }
        
        bankTextField.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(bankLabel.snp.bottom).offset(4)
        }

        bankArrowImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(bankTextField.snp.bottom).offset(24)
            $0.leading.equalTo(accountTextField.snp.leading).inset(6)
        }
        
        accountTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(accountLabel.snp.bottom).offset(4)
            $0.height.equalTo(46)
        }
        
        accountCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(accountTextField.snp.trailing).offset(-8)
            $0.top.equalTo(accountTextField.snp.bottom).offset(4.5)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(accountTextField.snp.bottom).offset(24)
            $0.leading.equalTo(nameTextField.snp.leading).inset(6)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(46)
        }
        
        nameCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(nameTextField.snp.trailing).inset(8)
            $0.top.equalTo(nameTextField.snp.bottom).offset(4.5)
        }

        payView.snp.makeConstraints {
            $0.height.equalTo(103)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(payLabel.snp.bottom).offset(4)
        }
        
        leftBar.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(tossPayView.snp.trailing)
        }
        
        rightBar.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(kakaoPayView.snp.trailing)
        }
        
        tossPayView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(payView).multipliedBy(1.0 / 3.0)
        }
        
        tossPayBtn.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        tossLabel.snp.makeConstraints {
            $0.top.equalTo(tossPayBtn.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        kakaoPayView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(payView).multipliedBy(1.0 / 3.0)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(tossPayView.snp.trailing)
        }
        
        kakaoPayBtn.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        kakaoLabel.snp.makeConstraints {
            $0.top.equalTo(kakaoPayBtn.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        naverPayView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(payView).multipliedBy(1.0 / 3.0)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        naverPayBtn.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        naverLabel.snp.makeConstraints {
            $0.top.equalTo(naverPayBtn.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        deleteBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-53)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setAddView() {
        
        [header, scrollView].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        [accountLabel,accountTextField, nameLabel, nameTextField, nameCountLabel, accountCountLabel].forEach {
            bankSelectedView.addSubview($0)
        }
        [bankLabel, bankTextField,bankSelectedView, deleteBtn, payLabel,
         payView].forEach {
            contentView.addSubview($0)
        }
        
        [bankArrowImage].forEach {
            bankTextField.addSubview($0)
        }
        [leftBar, rightBar, tossPayView, kakaoPayView, naverPayView].forEach {
            payView.addSubview($0)
        }
        [tossLabel, tossPayBtn].forEach {
            tossPayView.addSubview($0)
        }
        [kakaoLabel, kakaoPayBtn].forEach {
            kakaoPayView.addSubview($0)
        }
        [naverLabel, naverPayBtn].forEach {
            naverPayView.addSubview($0)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        scrollView.isScrollEnabled = true
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
        scrollView.isScrollEnabled = false
    }
}

