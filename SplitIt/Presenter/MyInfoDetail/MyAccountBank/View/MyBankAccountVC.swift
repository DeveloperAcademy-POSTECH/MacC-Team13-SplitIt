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

class MyBankAccountVC: UIViewController {
    
    let clearButton = UIButton()
    
    let viewModel = MyBankAccountVM()
    var disposeBag = DisposeBag()
   // let payData = PayData.shared.payData
    let maxCharacterCount = 8
    let userDefault = UserDefaults.standard
    var isBankSelected: Bool = false
    let header = NavigationHeader()
    
    var nameLabel = UILabel()
    var nameTextField = UITextField()
    var nameCountLabel = UILabel()
    
    let bankView = UIView()
    var bankNameLabel = UILabel()
    let bankArrowImage = UIImageView()
    
    let bankLabel = UILabel()
    
    let accountLabel = UILabel()
    let accountTextField = UITextField()
    
    let payLabel = UILabel()
    
    let payView = UIView()
    let leftBar = UIView()
    let rightBar = UIView()
    
    let tossPayView = UIView()
    let kakaoPayView = UIView()
    let naverPayView = UIView()
    
    let nameClearBtn = UIButton()
    // let accountClearBtn = UIButton()
    
    
    private let editDoneBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservables()
        setAddView()
        setLayout()
        setAttribute()
        setBinding()
        setPay()
        asapRxData()
    }
    
    
    func setupObservables() {
        let nameTextCheck = nameTextField.rx.text.orEmpty
        let accountTextCheck = accountTextField.rx.text.orEmpty
        
        
        Observable.combineLatest(nameTextCheck, accountTextCheck)
            .subscribe(onNext: { text1, text2 in
                
                if self.userDefault.string(forKey: "userName") != nil && // 값이 있다면!
                    self.userDefault.string(forKey: "userBank") != nil &&
                    self.userDefault.string(forKey: "userAccount") != nil {
                    
                    self.editDoneBtn.isEnabled = true
                    self.editDoneBtn.backgroundColor = .black
                } else {
                    
                    if !text1.isEmpty && !text2.isEmpty && self.isBankSelected {
                        self.editDoneBtn.isEnabled = true
                        self.editDoneBtn.backgroundColor = .black
                    } else {
                        self.editDoneBtn.isEnabled = false
                        self.editDoneBtn.backgroundColor = .gray
                        
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeyboardNotification()
        self.nameTextField.becomeFirstResponder()
    }
    
    func setAddView() {
        [header, nameLabel, nameTextField,
         bankLabel, bankView,
         accountLabel,editDoneBtn,
         accountTextField, payLabel,
         payView].forEach {
            view.addSubview($0)
        }
        nameTextField.addSubview(nameCountLabel)
        
        [bankNameLabel, bankArrowImage].forEach {
            bankView.addSubview($0)
        }
        [leftBar, rightBar, tossPayView, kakaoPayView, naverPayView].forEach {
            payView.addSubview($0)
        }
        
        //nameTextField.addSubview(nameClearBtn)
        // accountTextField.addSubview(accountClearBtn)
        
    }
    
    func setLayout() {
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(112)
            make.left.equalToSuperview().offset(36)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(330)
        }
        
        nameCountLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
        
        
        
        bankLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(36)
        }
        
        bankView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(330)
            make.centerX.equalToSuperview()
            make.top.equalTo(bankLabel.snp.bottom).offset(4)
            
        }
        
        bankNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        bankArrowImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(bankView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(36)
        }
        
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(accountLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(330)
        }
        
        //        accountClearBtn.snp.makeConstraints { make in
        //            make.height.width.equalTo(40)
        //            make.right.equalToSuperview().offset(-50)
        //            make.top.equalTo(accountTextField.snp.top).offset(10)
        //        }
        
        payLabel.snp.makeConstraints { make in
            make.top.equalTo(accountTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(36)
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
            make.left.equalToSuperview().offset(110)
        }
        
        rightBar.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-110)
        }
        
        tossPayView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(56)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32)
        }
        
        kakaoPayView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(56)
            make.center.equalToSuperview()
        }
        
        naverPayView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(56)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-32)
        }
        
        
        editDoneBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        
        
    }
    
    
    
    func setAttribute() {
        nameTextField.rx.text.orEmpty
            .map { text -> String in
                let cnt = min(text.count, 8)
                return "(\(cnt)/8)"
            }
            .bind(to: nameCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        nameTextField.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let text = self?.nameTextField.text else { return }
                if text.count > self?.maxCharacterCount ?? 0 {
                    let endIndex = text.index(text.startIndex, offsetBy: self?.maxCharacterCount ?? 0)
                    self?.nameTextField.text = String(text[..<endIndex])
                }
            })
            .disposed(by: disposeBag)
        
        
        view.backgroundColor = .white
        
        
        header.do {
            $0.configureBackButton(viewController: self)
        }
        
        nameLabel.do {
            $0.text = "이름"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.gray
        }
        nameCountLabel.do {
            $0.textColor = .gray
        }
        nameTextField.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray.cgColor
            
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            //$0.rightView = nameClearBtn
            //$0.clearButtonMode = .whileEditing
            
            
            
            //placeholder의 색깔
            if UserDefaults.standard.string(forKey: "userName") == nil {
                $0.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            } else {
                //                $0.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "userName")!,
                //                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                
                $0.placeholder = userDefault.string(forKey: "userName")
            }
            $0.font = UIFont.systemFont(ofSize: 15)
            
            $0.clipsToBounds = true
            
            //textField의 앞부분의 빈공간 구현
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
            $0.leftViewMode = .always
            
        }
        //            clearButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //            clearButton.setTitle("X", for: .normal)
        //            clearButton.setTitleColor(.black, for: .normal)
        //            clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        //
        //
        //            $0.rightView = clearButton
        //            $0.rightViewMode = .whileEditing
        
        nameClearBtn.do {
            $0.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
            $0.frame = CGRect(x: 30, y: 0, width: 50, height: 30)
            $0.setTitleColor(.black, for: .normal)
        }
        
        bankLabel.do {
            $0.text = "은행"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.systemGray
        }
        
        
        bankView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.backgroundColor = .clear
            
        }
        
        bankNameLabel.do {
            if UserDefaults.standard.string(forKey: "userBank") == nil {
                $0.text = "은행을 선택해주세요"
                $0.tintColor = .gray
            } else {
                $0.text = UserDefaults.standard.string(forKey: "userBank")
                $0.tintColor = .black
            }
            $0.font = UIFont.systemFont(ofSize: 15)
            
        }
        
        bankArrowImage.do {
            $0.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
        
        accountLabel.do {
            $0.text = "계좌번호"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.gray
        }
        
        
        
        accountTextField.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.keyboardType = .numberPad
            //  $0.clearButtonMode = .whileEditing
            
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            //
            //            clearButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            //            clearButton.setTitle("X", for: .normal)
            //            clearButton.setTitleColor(.black, for: .normal)
            //            clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
            //
            //
            //            $0.rightView = clearButton
            //            $0.rightViewMode = .whileEditing
            
            
            if UserDefaults.standard.string(forKey: "userAccount") == nil {
                $0.attributedPlaceholder = NSAttributedString(string: "계좌번호를 입력해주세요",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            } else {
                //                $0.attributedPlaceholder = NSAttributedString(string: UserDefaults.standard.string(forKey: "userAccount")!,
                //                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                $0.placeholder = userDefault.string(forKey: "userAccount")
            }
            
            
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.clipsToBounds = true
            
            //textField의 앞부분의 빈공간 구현
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
            $0.leftViewMode = .always
            //
            ////
            //            let clearButton = UIButton(type: .custom)
            //            clearButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            //            clearButton.setTitle("X", for: .normal)
            //            clearButton.setTitleColor(.black, for: .normal)
            //            //clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
            //
            //            // 텍스트 필드 설정
            //            $0.rightView = clearButton
            //            $0.rightViewMode = .whileEditing
            
            
        }
        
        //        accountClearBtn.do {
        //            $0.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        //        }
        //
        payLabel.do {
            $0.text = "간편페이 사용여부"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.gray
        }
        
        
        editDoneBtn.do {
            $0.setTitle("계좌정보 수정완료", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            $0.titleLabel?.textColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .black
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
        
    }
    
    
    func setBinding() {
        
        let selectedBankTap = addTapGesture(to: bankView)
        let tossTap = addTapGesture(to: tossPayView)
        let kakaoTap = addTapGesture(to: kakaoPayView)
        let naverTap = addTapGesture(to: naverPayView)
        
        
        let input = MyBankAccountVM.Input(inputNameText: nameTextField.rx.text.orEmpty.changed,
                                          editDoneBtnTapped: editDoneBtn.rx.tap.asDriver(),
                                          selectBackTapped: selectedBankTap.rx.event.asObservable().map{ _ in () },
                                          inputAccountText: accountTextField.rx.text.orEmpty.asObservable(),
                                          tossTapped: tossTap.rx.event.asObservable().map { _ in () },
                                          kakaoTapeed: kakaoTap.rx.event.asObservable().map { _ in () },
                                          naverTapped: naverTap.rx.event.asObservable().map { _ in () },
                                          nameTextFieldClearTapped: nameClearBtn.rx.tap.asControlEvent()
                                          //                                          nameTextFieldClearTapped: nameClearBtn.rx.tap.asDriver(),
                                          //                                          accountTextFieldClearTapped: accountClearBtn.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.popToMyInfoView
            .drive(onNext:{ [self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        
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
        
        
        
        nameClearBtn.rx.tap
            .bind { [weak self] in
                self?.nameTextField.text = ""
                print("눌림")
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    
    func asapRxData() {
        userDefault.rx
            .observe(Bool.self, "tossPay")
            .subscribe(onNext: { value in
                guard let value = value else { return }
                self.tossPayView.backgroundColor = value ? UIColor.systemBlue : UIColor.gray
            })
            .disposed(by: disposeBag)
        
        userDefault.rx
            .observe(Bool.self, "kakaoPay")
            .subscribe(onNext: { value in
                guard let value = value else { return }
                self.kakaoPayView.backgroundColor = value ? UIColor.systemYellow : UIColor.gray
            })
            .disposed(by: disposeBag)
        
        userDefault.rx
            .observe(Bool.self, "naverPay")
            .subscribe(onNext: { value in
                guard let value = value else { return }
                self.naverPayView.backgroundColor = value ? UIColor.systemGreen : UIColor.gray
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
    func setPay() {
        
        var tossPayBtn = PayButton(labelText: "토스뱅크", btn: UIImage(systemName: "dollarsign.square.fill")!, check: UIImage(systemName: "checkmark.circle.fill")!)
        
        var kakaoPayBtn = PayButton(labelText: "카카오페이", btn: UIImage(systemName: "dollarsign.square.fill")!, check: UIImage(systemName: "checkmark.circle.fill")!)
        
        var naverPayBtn = PayButton(labelText: "네이버페이", btn: UIImage(systemName: "dollarsign.square.fill")!, check: UIImage(systemName: "checkmark.circle.fill")!)
        
        tossPayBtn.setupConstraints(in: tossPayView)
        kakaoPayBtn.setupConstraints(in: kakaoPayView)
        naverPayBtn.setupConstraints(in: naverPayView)
        
    }
}

extension MyBankAccountVC: UITextFieldDelegate {
    
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.editDoneBtn.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight + 26)
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        self.editDoneBtn.snp.updateConstraints {
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
