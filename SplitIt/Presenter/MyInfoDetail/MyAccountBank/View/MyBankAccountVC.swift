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

class MyBankAccountVC: UIViewController, AccountCustomKeyboardDelegate, SPAlertDelegate {

    let bankValue = BehaviorRelay<String?>(value: UserDefaults.standard.string(forKey: "userBank"))
    let accountTextRelay = BehaviorRelay<String?>(value: UserDefaults.standard.string(forKey: "userAccount"))
    
//    let nameTextRelay = BehaviorRelay<String?>(value: UserDefaults.standard.string(forKey: "userName"))
//    let bankTextRelay = BehaviorRelay<String?>(value: UserDefaults.standard.string(forKey: "userBank"))
//    let tossRelay = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "tossPay"))
//    let kakaoRelay = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "kakaoPay"))
//    let naverRelay = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: "naverPay"))
//
    
    let isModifiedRelay = BehaviorRelay<Bool>(value: false)
    var isModified = false
    
    let accountCustomKeyboard = AccountCustomKeyboard()
    
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
    var nameTextField = SPTextField() //예금주
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddView()
        setLayout()
        selectedBankViewAttribute()
        setAttribute()
        setBinding()
        asapRxData()
        accountTextFieldCustomKeyboard()
        textFieldTextAttribute()
       
        
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
        
        accountCustomKeyboard.customKeyObservable
            .subscribe(onNext: { [weak self] value in
                self?.accountCustomKeyboard.handleInputValue(value)
                self?.accountTextRelay.accept((self?.accountTextField.text)!)
            })
            .disposed(by: disposeBag)
    }
    
    func setAlert() {
        showAlert(view: alert,
                type: .warnNormal,
                title: "나의 정보를 초기화 하시겠어요?",
                descriptions: "이 작업은 돌이킬 수 없어요",
                leftButtonTitle: "취 소",
                rightButtonTitle: "초기화")
        
        alert.rightButtonTapSubject
              .asDriver(onErrorJustReturn: ())
              .drive(onNext: { [weak self] in
                  self?.deleteAllInfo()
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
        
        if text == "선택 안함" {
            
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
        
        
        
        
//        Observable.combineLatest(accountTextRelay, nameTextRelay, bankTextRelay, tossRelay, kakaoRelay, naverRelay)
//            .subscribe(onNext: { [weak self] (accountText, nameText, bankText, toss, kakao, naver) in
//                print(accountText, nameText, bankText, toss, kakao, naver)
//                let isModified = (accountText != UserDefaults.standard.string(forKey: "userAccount")) ||
//                                 (nameText != UserDefaults.standard.string(forKey: "userName")) ||
//                                 (bankText != UserDefaults.standard.string(forKey: "userBank")) ||
//                                 (toss != UserDefaults.standard.bool(forKey: "tossPay")) ||
//                                 (kakao != UserDefaults.standard.bool(forKey: "kakaoPay")) ||
//                                 (naver != UserDefaults.standard.bool(forKey: "naverPay"))
//                self?.isModifiedRelay.accept(isModified)
//                if isModified {
//                    print("변화가 있었습니다.")
//                    // 다른 뷰를 띄우는 로직을 구현하세요
//                    // 예: self?.present(viewController, animated: true, completion: nil)
//                } else {
//                    print("변화가 없었습니다.")
//                }
//            })
//            .disposed(by: disposeBag)
//
       
        
        
        let nameObservable = nameTextField.rx.text.orEmpty.asDriver()
        let accountObservable = accountTextField.rx.text.orEmpty.asDriver()
        
        let isTextEmptyObservable = Driver.combineLatest(nameObservable, accountObservable, bankValue.asDriver())
            
            .map { text1, text2, bankValue in
                if bankValue != "선택 안함" {
                    return !(text1.count == 0) && !(text2.count == 0)
                } else {
                    return true
                }
            }

        isTextEmptyObservable
            .drive(header.buttonState)
            .disposed(by: disposeBag)
        

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
            UserDefaults.standard.set(false, forKey: "tossPay")
        }
        if UserDefaults.standard.object(forKey: "kakaoPay") == nil {
            UserDefaults.standard.set(false, forKey: "kakaoPay")
        }
        if UserDefaults.standard.object(forKey: "naverPay") == nil {
            UserDefaults.standard.set(false, forKey: "naverPay")
        }
        if UserDefaults.standard.object(forKey: "userAccount") == nil {
            UserDefaults.standard.set("", forKey: "userAccount")
        }
        if UserDefaults.standard.object(forKey: "userName") == nil {
            UserDefaults.standard.set("", forKey: "userName")
        }
        if UserDefaults.standard.object(forKey: "userBank") == nil {
            UserDefaults.standard.set("선택 안함", forKey: "userBank")
        }
    }
    
    
    func setBinding() {
        
        let selectedBankTap = addTapGesture(to: bankTextField)
        let tossTap = addTapGesture(to: tossPayView)
        let kakaoTap = addTapGesture(to: kakaoPayView)
        let naverTap = addTapGesture(to: naverPayView)
        
        let input = MyBankAccountVM.Input(inputRealNameText: nameTextField.rx.text.orEmpty.changed,
                                          editDoneBtnTapped: header.rightButton.rx.tap.asDriver(),
                                          selectBackTapped: selectedBankTap.rx.event.asObservable().map{ _ in () },
                                          inputAccountText: accountTextField.rx.text.orEmpty.changed,
                                          tossTapped: tossTap.rx.event.asObservable().map { _ in () },
                                          kakaoTapeed: kakaoTap.rx.event.asObservable().map { _ in () },
                                          naverTapped: naverTap.rx.event.asObservable().map { _ in () },
                                          deleteBtnTapped: deleteBtn.rx.tap.asDriver(),
                                          cancelBtnTapped: header.leftButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.showBankModel
            .subscribe(onNext: { [weak self] in
                let modalVC = BankListModalVC()
                modalVC.modalPresentationStyle = .formSheet
                modalVC.modalTransitionStyle = .coverVertical
                modalVC.selectedBankName
                    .bind { bankName in
                        self?.bankValue.accept(bankName)
                        self?.bankTextField.text = bankName
                        self?.updateViewLayout(text: bankName)
                        self?.viewModel.inputBankName = bankName
                        self?.viewModel.checkBank = 1
                        print(bankName)
                    }
                    .disposed(by: modalVC.disposeBag)
                self?.present(modalVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.showAlertView
            .drive(onNext: { [weak self] in
                self?.setAlert()
            })
            .disposed(by: disposeBag)
        
        
        output.cancelBackToView
            .drive(onNext: { [weak self] in
                if self?.isModified == true{
                    self?.setBackAlert()
                } else {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func deleteAllInfo() {
        UserDefaults.standard.set(false, forKey: "tossPay")
        UserDefaults.standard.set(false, forKey: "kakaoPay")
        UserDefaults.standard.set(false, forKey: "naverPay")
        UserDefaults.standard.set("", forKey: "userAccount")
        UserDefaults.standard.set("", forKey: "userName")
        UserDefaults.standard.set("선택 안함", forKey: "userBank")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //페이류 변경되는 값에 따라 바로 UI 변경되도록 하는 함수
    func asapRxData() {
        viewModel.isTossPayToggled
            .subscribe(onNext: { [weak self] isToggled in
                let newImage = isToggled ? "TossPayIconChecked" : "TossPayIconUnchecked"
                self?.tossPayBtn.image = UIImage(named: newImage)
            })
            .disposed(by: disposeBag)
        
        viewModel.isKakaoPayToggled
            .subscribe(onNext: { [weak self] isToggled in
                let newImage = isToggled ? "KakaoPayIconChecked" : "KakaoPayIconUnchecked"
                self?.kakaoPayBtn.image = UIImage(named: newImage)
            })
            .disposed(by: disposeBag)
        
        
        viewModel.isNaverPayToggled
            .subscribe(onNext: { [weak self] isToggled in
                let newImage = isToggled ? "NaverPayIconChecked" : "NaverPayIconUnchecked"
                self?.naverPayBtn.image = UIImage(named: newImage)
            })
            .disposed(by: disposeBag)
        
        userDefault.rx
            .observe(String.self, "userBank")
            .subscribe(onNext: { value in
                guard let value = value else { return }
                self.bankTextField.text = value != "" ? value : "선택 안함"
            })
            .disposed(by: disposeBag)
        
    }
    
    func addTapGesture(to view: UIView) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
    
    //textField의 글자수 제한, warn 등 에 대한 함수
    func textFieldTextAttribute() {
        nameTextField.rx.text.orEmpty
            .map { text -> String in
                let cnt = min(text.count, 8)
                return "(\(cnt)/8)"
            }
            .bind(to: nameCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        //이름 글자수 제한
        nameTextField.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let text = self?.nameTextField.text else { return }
                if text.count >= self?.maxCharacterCount ?? 0 {
                    let endIndex = text.index(text.startIndex, offsetBy: self?.maxCharacterCount ?? 0)
                    self?.nameTextField.text = String(text[..<endIndex])
                    self?.nameCountLabel.textColor = .AppColorStatusWarnRed
                } else {
                    self?.nameCountLabel.textColor = .TextSecondary
                }
            })
            .disposed(by: disposeBag)
        
        accountTextField.rx.text.orEmpty
            .map { text -> String in
                let cnt = min(text.count, 17)
                return "(\(cnt)/17)"
            }
            .bind(to: accountCountLabel.rx.text)
            .disposed(by: disposeBag)

        //이름 글자수 제한
        accountTextField.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let text = self?.accountTextField.text else { return }
                if text.count >= self?.maxAccountCount ?? 0 {
                    let endIndex = text.index(text.startIndex, offsetBy: self?.maxAccountCount ?? 0)
                    self?.accountTextField.text = String(text[..<endIndex])
                    self?.accountCountLabel.textColor = .AppColorStatusWarnRed
                } else {
                    self?.accountCountLabel.textColor = .TextSecondary
                }
                
            })
            .disposed(by: disposeBag)
        
        accountTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                let filtered = text.filter { $0.isNumber || $0 == "-" }
                if text != filtered {
                    self?.accountTextField.text = filtered
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func setAttribute() {
        
        view.backgroundColor = .SurfaceBrandCalmshell
        
        scrollView.backgroundColor = .SurfaceBrandCalmshell
        contentView.backgroundColor = .SurfaceBrandCalmshell
        
        scrollView.isScrollEnabled = false
        scrollView.contentSize = contentView.bounds.size
         
        header.do {
            $0.applyStyle(style: .myInfo, vc: self)
            $0.buttonState.accept(true)
            $0.leftButton.removeTarget(nil, action: nil, for: .touchUpInside)
        }
        
        bankLabel.do {
            $0.text = "은행"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextPrimary
        }
        
        
        bankTextField.do {
            $0.placeholder = "선택 안 함"
            $0.applyStyle(.normal)
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            
            if userDefault.string(forKey: "userBank") == nil || userDefault.string(forKey: "userBank") == "" {
                $0.textColor = .TextPrimary
            } else {
                $0.text = userDefault.string(forKey: "userBank")
                $0.textColor = .TextPrimary
            }
        }

        bankArrowImage.do {
            $0.image = UIImage(named: "ArrowTriangleIconDown")
        }
        
        accountLabel.do {
            $0.text = "계좌번호"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextPrimary
        }

        accountTextField.do {
            $0.placeholder = "계좌번호를 입력해주세요"
            $0.applyStyle(.normal)
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            
            if userDefault.string(forKey: "userAccount") == nil || userDefault.string(forKey: "userAccount") == "" {
                $0.textColor = .TextPrimary
            } else {
                $0.text = userDefault.string(forKey: "userAccount")
                $0.textColor = .TextPrimary
            }
            
        }
        
        accountCountLabel.do {
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextSecondary

        }
        
        nameLabel.do {
            $0.text = "예금주 성함"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextPrimary
        }
        
        nameCountLabel.do {
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextSecondary

        }
        
        nameTextField.do {
            $0.placeholder = "성함을 입력해주세요"
            $0.applyStyle(.normal)
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
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
            $0.textColor = UIColor.TextPrimary
        }
        
        
        leftBar.do {
            $0.backgroundColor = .gray
        }
        
        rightBar.do {
            $0.backgroundColor = .gray
        }
        
        payView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray.cgColor
            
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
            $0.top.equalToSuperview().offset(30)
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
        
//        payLabel.snp.makeConstraints {
//            //$0.top.equalTo(bankSelectedView.snp.bottom).offset(24)
//            $0.top.equalTo(bankTextField.snp.bottom).offset(24)
//            $0.leading.equalTo(payView.snp.leading).inset(6)
//        }

        payView.snp.makeConstraints {
            $0.height.equalTo(103)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(payLabel.snp.bottom).offset(4)
        }
        
        leftBar.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(110)
        }
        
        rightBar.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-110)
        }
        
        tossPayView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(56)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(32)
        }
        
        tossPayBtn.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        tossLabel.snp.makeConstraints { make in
            make.top.equalTo(tossPayBtn.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        kakaoPayView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(56)
            make.center.equalToSuperview()
        }
        
        kakaoPayBtn.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        kakaoLabel.snp.makeConstraints { make in
            make.top.equalTo(kakaoPayBtn.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        
        naverPayView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(56)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-32)
        }
        
        naverPayBtn.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        
        naverLabel.snp.makeConstraints { make in
            make.top.equalTo(naverPayBtn.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-53)
            make.centerX.equalToSuperview()
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

