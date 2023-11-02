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


protocol MyInfoDeleteAlertVCDelegate: AnyObject {
    func deleteAllInfo()
}

class MyBankAccountVC: UIViewController, AccountCustomKeyboardDelegate, MyInfoDeleteAlertVCDelegate {
    
    
    let accountTextRelay = BehaviorRelay<String?>(value: "")
    let accountCustomKeyboard = AccountCustomKeyboard()

    let viewModel = MyBankAccountVM()
    var disposeBag = DisposeBag()
    let maxCharacterCount = 8
    let userDefault = UserDefaults.standard
    
    var isBankSelected: Bool = false
    var keyboardHeight: CGFloat = 400
    
    let header = SPNavigationBar()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var nickNameLabel = UILabel()
    var nickNameTextField = UITextField() //사용자 이름 받는 곳
    var nickNameCountLabel = UILabel()
    
    let bankView = UIView()
    var bankNameLabel = UILabel()
    let bankArrowImage = UIImageView()
    
    let bankLabel = UILabel()
    
    let accountLabel = UILabel()
    let accountTextField = UITextField()
    
    var nameLabel = UILabel()
    var nameTextField = UITextField() //예금주
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
        
        checkUserInfo()
        setAddView()
        setLayout()
        setAttribute()
        setBinding()
        asapRxData()
        accountTextFieldCustomKeyboard()
        
        
    }
    
    
    func accountTextFieldCustomKeyboard() {
        
        accountTextField.inputView = accountCustomKeyboard.inputView
        accountCustomKeyboard.delegate = self
        accountCustomKeyboard.setCurrentTextField(accountTextField)
        
        accountCustomKeyboard.customKeyObservable
            .subscribe(onNext: { [weak self] value in
                self?.accountCustomKeyboard.handleInputValue(value)
                self?.accountTextRelay.accept(self?.accountTextField.text)
            })
            .disposed(by: disposeBag)
    }
    
    //수정버튼 활성화 비활성화 선택해주는 함수
    func checkUserInfo() {
        let nickNameTextCheck = nickNameTextField.rx.text.orEmpty
        let accountTextCheck = accountTextField.rx.text.orEmpty
        let nameTextCheck = nameTextField.rx.text.orEmpty
        
        Observable.combineLatest(nameTextCheck, accountTextCheck, nickNameTextCheck)
            .subscribe(onNext: { text1, text2, text3 in
                
                if self.userDefault.string(forKey: "userNickName") != nil  // 이미 값이 설정되었던 상태
//                    self.userDefault.string(forKey: "userBank") != nil &&
//                    self.userDefault.string(forKey: "userAccount") != nil &&
//                    self.userDefault.string(forKey: "userNickName") != nil {
                    {
                    self.header.buttonState.accept(true)
                    
                } else { //값이 없는 상태
                    if !text3.isEmpty {
//                    if !text1.isEmpty && !text2.isEmpty && !text3.isEmpty && self.isBankSelected {
                        self.header.buttonState.accept(true)
                        
                    } else {
                        self.header.buttonState.accept(false)
                        
                    }
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nickNameTextField.becomeFirstResponder()
    }
    
    
    func setBinding() {
        
        let selectedBankTap = addTapGesture(to: bankView)
        let tossTap = addTapGesture(to: tossPayView)
        let kakaoTap = addTapGesture(to: kakaoPayView)
        let naverTap = addTapGesture(to: naverPayView)
        
        
        let input = MyBankAccountVM.Input(inputNameText: nickNameTextField.rx.text.orEmpty.changed,
                                          inputRealNameText: nameTextField.rx.text.orEmpty.changed,
                                          editDoneBtnTapped: header.rightButton.rx.tap.asDriver(),
                                          selectBackTapped: selectedBankTap.rx.event.asObservable().map{ _ in () },
                                          inputAccountText: accountTextField.rx.text.orEmpty.changed,
                                          tossTapped: tossTap.rx.event.asObservable().map { _ in () },
                                          kakaoTapeed: kakaoTap.rx.event.asObservable().map { _ in () },
                                          naverTapped: naverTap.rx.event.asObservable().map { _ in () },
                                          deleteBtnTapped: deleteBtn.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.showBankModel
            .subscribe(onNext: { [weak self] in
                let modalVC = BankListModalVC()
                modalVC.modalPresentationStyle = .formSheet
                modalVC.modalTransitionStyle = .coverVertical
                modalVC.selectedBankName
                    .bind { bankName in
                        self?.userDefault.set(bankName, forKey: "userBank")
                        print(bankName)
                    }
                    .disposed(by: modalVC.disposeBag)
                self?.present(modalVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.showAlertView
            .drive(onNext: {
                self.presentMyInfoDeleteAlertVC()
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func deleteAllInfo() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func presentMyInfoDeleteAlertVC() {
        let vc = MyInfoDeleteAlertVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    //UserDefaluts 변경되는 값에 따라 바로 UI 변경되도록 하는 함수
    func asapRxData() {
        userDefault.rx
            .observe(Bool.self, "tossPay")
            .subscribe(onNext: { value in
                guard let value = value else { return }
                let newImage = value ? "TossPayIconChecked" : "TossPayIconUnchecked"
                self.tossPayBtn.image = UIImage(named: newImage)
                
            })
            .disposed(by: disposeBag)
        
        userDefault.rx
            .observe(Bool.self, "kakaoPay")
            .subscribe(onNext: { value in
                guard let value = value else { return }
                let newImage = value ? "KakaoPayIconChecked" : "KakaoPayIconUnchecked"
                self.kakaoPayBtn.image = UIImage(named: newImage)
            })
            .disposed(by: disposeBag)
        
        userDefault.rx
            .observe(Bool.self, "naverPay")
            .subscribe(onNext: { value in
                guard let value = value else { return }
                let newImage = value ? "NaverPayIconChecked" : "NaverPayIconUnchecked"
                self.naverPayBtn.image = UIImage(named: newImage)
            })
            .disposed(by: disposeBag)
        
        userDefault.rx
            .observe(String.self, "userBank")
            .subscribe(onNext: { value in
                guard let value = value else { return }
                self.bankNameLabel.text = value
                self.isBankSelected = true
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func addTapGesture(to view: UIView) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
    
    func setAttribute() {
        //이름 글자수 카운트
        nickNameTextField.rx.text.orEmpty
            .map { text -> String in
                let cnt = min(text.count, 8)
                return "(\(cnt)/8)"
            }
            .bind(to: nickNameCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        //이름 글자수 제한
        nickNameTextField.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let text = self?.nickNameTextField.text else { return }
                if text.count > self?.maxCharacterCount ?? 0 {
                    let endIndex = text.index(text.startIndex, offsetBy: self?.maxCharacterCount ?? 0)
                    self?.nickNameTextField.text = String(text[..<endIndex])
                }
            })
            .disposed(by: disposeBag)
        
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
                if text.count > self?.maxCharacterCount ?? 0 {
                    let endIndex = text.index(text.startIndex, offsetBy: self?.maxCharacterCount ?? 0)
                    self?.nameTextField.text = String(text[..<endIndex])
                }
            })
            .disposed(by: disposeBag)
        
        
        view.backgroundColor = .SurfaceBrandCalmshell
        
        scrollView.backgroundColor = .SurfaceBrandCalmshell
        contentView.backgroundColor = .SurfaceBrandCalmshell
        
        scrollView.isScrollEnabled = true
        
        
        header.do {
            $0.applyStyle(style: .myInfo, vc: self)
            $0.buttonState.accept(true)
        }
        
        nickNameLabel.do {
            $0.text = "정산자 닉네임"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = .TextPrimary
        }
        
        nickNameCountLabel.do {
            $0.textColor = .TextSecondary
            $0.font = UIFont.KoreanCaption2
        }
        
        nickNameTextField.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            //$0.clearButtonMode = .whileEditing
            
            //placeholder의 색깔
            if UserDefaults.standard.string(forKey: "userNickName") == nil {
                $0.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextDeactivate])
            } else {
                
                $0.attributedPlaceholder = NSAttributedString(string: userDefault.string(forKey: "userNickName")!,
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextPrimary])
                
            }
            $0.font = .KoreanCaption1
            $0.clipsToBounds = true
            
            //textField의 앞부분의 빈공간 구현
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: $0.frame.height))
            $0.leftViewMode = .always
            
        }
        
        bankLabel.do {
            $0.text = "은행"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextPrimary
        }
        
        bankView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            $0.backgroundColor = .clear
            
        }
        
        bankNameLabel.do {
            if UserDefaults.standard.string(forKey: "userBank") == nil {
                $0.text = "은행을 선택해주세요"
                $0.tintColor = .TextPrimary
            } else {
                $0.text = UserDefaults.standard.string(forKey: "userBank")
                $0.tintColor = .TextPrimary
            }
            $0.font = UIFont.KoreanCaption1
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
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            //$0.keyboardType = .numberPad
            //$0.clearButtonMode = .whileEditing
            
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            
            //MARK: 토마토, 수정뷰로 넘어왔을 때, 검은색 글자면은 이미 입력되어있는 것처럼 보여서 회색으로 처리해두었어요
            if UserDefaults.standard.string(forKey: "userAccount") == nil {
                $0.attributedPlaceholder = NSAttributedString(string: "계좌번호를 입력해주세요",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextDeactivate])
            } else {
                $0.attributedPlaceholder = NSAttributedString(string: userDefault.string(forKey: "userAccount")!,
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextPrimary])
            }
            
            $0.font = UIFont.KoreanCaption1
            $0.clipsToBounds = true
            
            //textField의 앞부분의 빈공간 구현
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: $0.frame.height))
            $0.leftViewMode = .always
            
            
        }
        
        nameLabel.do {
            $0.text = "예금주 성함"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextPrimary
        }
        
        nameCountLabel.do {
            $0.textColor = .TextSecondary
            $0.font = UIFont.KoreanCaption2
        }
        
        
        nameTextField.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            //$0.clearButtonMode = .whileEditing
            
            //placeholder의 색깔
            if UserDefaults.standard.string(forKey: "userName") == nil {
                $0.attributedPlaceholder = NSAttributedString(string: "성함을 입력해주세요",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextDeactivate])
                //$0.textColor = .TextDeactivate
            } else {
                $0.attributedPlaceholder = NSAttributedString(string: userDefault.string(forKey: "userName")!,
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextPrimary])
            }
            $0.font = .KoreanCaption1
            
            $0.clipsToBounds = true
            
            //textField의 앞부분의 빈공간 구현
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: $0.frame.height))
            $0.leftViewMode = .always
            
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
            $0.text = "토스뱅크"
            $0.font = .KoreanCaption2
            $0.textAlignment = .center
        }
        
        kakaoLabel.do {
            $0.text = "카카오페이"
            $0.font = .KoreanCaption2
            $0.textAlignment = .center
            
        }
        
        naverLabel.do {
            $0.text = "네이버페이"
            $0.font = .KoreanCaption2
            $0.textAlignment = .center
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
    
    func setAddView() {
        
        [header, scrollView, deleteBtn].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [nickNameLabel, nickNameTextField,
         bankLabel, bankView,
         accountLabel,
         accountTextField, nameLabel, nameTextField,payLabel,
         payView].forEach {
            contentView.addSubview($0)
        }
        nickNameTextField.addSubview(nickNameCountLabel)
        nameTextField.addSubview(nameCountLabel)
        [bankNameLabel, bankArrowImage].forEach {
            bankView.addSubview($0)
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
    
    func setLayout() {
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.equalTo(500)
            make.bottom.equalToSuperview()
        }
        
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(36)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(330)
        }
        
        nickNameCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
        
        
        bankLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(36)
        }
        
        bankView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(330)
            make.centerX.equalToSuperview()
            make.top.equalTo(bankLabel.snp.bottom).offset(4)
            
        }
        
        bankNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        bankArrowImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(bankView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(36)
        }
        
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(accountLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(330)
        }
        
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(36)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(330)
        }
        
        nameCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
        
        payLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(36)
        }
        
        payView.snp.makeConstraints { make in
            make.height.equalTo(103)
            make.width.equalTo(330)
            make.centerX.equalToSuperview()
            make.top.equalTo(payLabel.snp.bottom).offset(4)
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
            make.width.equalTo(60)
            make.height.equalTo(17)
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
            make.width.equalTo(60)
            make.height.equalTo(17)
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
            make.width.equalTo(60)
            make.height.equalTo(17)
            make.top.equalTo(naverPayBtn.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-53)
            make.centerX.equalToSuperview()
        }
        
    }
}

