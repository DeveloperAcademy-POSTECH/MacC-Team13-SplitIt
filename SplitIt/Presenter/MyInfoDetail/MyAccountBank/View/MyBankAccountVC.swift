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
    
    let viewModel = MyBankAccountVM()
    var disposeBag = DisposeBag()
    let payData = PayData.shared.payData
    let userData = UserData.shared.userData
    let maxCharacterCount = 8
    
    let header = NavigationHeader()
    
    private var nameLabel = UILabel()
    private var nameTextField = UITextField()
    private var nameCountLabel = UILabel()
    
    private let bankView = UIView()
    private let bankNameLabel = UILabel()
    private let bankArrowImage = UIImageView()
    
    private let bankLabel = UILabel()
    
    private let accountLabel = UILabel()
    private let accountTextField = UITextField()
    
    private let payLabel = UILabel()
    
    private let payView = UIView()
    private let leftBar = UIView()
    private let rightBar = UIView()
    
    private let tossPayView = UIView()
    private let kakaoPayView = UIView()
    private let naverPayView = UIView()
    

    private let editDoneBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        setAddView()
        setLayout()
        setAttribute()
        setBinding()
        setPay()
        //payColor()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                // 키보드가 나타날 때 수행할 작업을 여기에 추가하세요.
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        // view.addSubview(tossPayView)
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
            make.right.equalToSuperview().offset(-5)
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
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        
        
    }
    func setPay() {
        
        var tossPayBtn = PayButton(labelText: "토스뱅크", btn: UIImage(systemName: "dollarsign.square.fill")!, check: UIImage(systemName: "checkmark.circle.fill")!)
        
        var kakaoPayBtn = PayButton(labelText: "카카오페이", btn: UIImage(systemName: "dollarsign.square.fill")!, check: UIImage(systemName: "checkmark.circle.fill")!)
        
        var naverPayBtn = PayButton(labelText: "네이버페이", btn: UIImage(systemName: "dollarsign.square.fill")!, check: UIImage(systemName: "checkmark.circle.fill")!)
        
        
        tossPayBtn.setupConstraints(in: tossPayView)
        kakaoPayBtn.setupConstraints(in: kakaoPayView)
        naverPayBtn.setupConstraints(in: naverPayView)
        
        
        
        
    }
    
    
    func addTapGesture(to view: UIView) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
    
    
    func setAttribute() {
        //print(BankListModalVC.selectedBankNameSubject)
        //왜 9글자로 나옴,,,?
        nameTextField.rx.text.orEmpty
            .map { "(\($0.count)/8)" }
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
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "내 정보 수정"
        
        header.do {
            $0.configureBackButton(viewController: self)
        }
        
        nameLabel.do {
            $0.text = "이름"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.gray
        }
        
        nameTextField.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray.cgColor
            //placeholder의 색깔을 정하기 위함
            $0.attributedPlaceholder = NSAttributedString(string: "   이름을 입력해주세요",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            
            $0.font = UIFont.systemFont(ofSize: 15)
            //$0.placeholder = userData.value.name
            $0.clipsToBounds = true
            
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
            $0.text = "은행을 선택해주세요"
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
            $0.attributedPlaceholder = NSAttributedString(string: "   계좌번호를 입력해주세요",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            $0.font = UIFont.systemFont(ofSize: 15)
            //$0.placeholder = userData.value.account
            $0.clipsToBounds = true
            
            
        }
        
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
        
        tossPayView.do {
            $0.backgroundColor = UIColor.systemBlue
        }
        
        kakaoPayView.do {
            $0.backgroundColor = UIColor.systemYellow
        }
        
        naverPayView.do {
            $0.backgroundColor = UIColor.systemGreen
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
                                          naverTapped: naverTap.rx.event.asObservable().map { _ in () }
                                          
                                          
        )
        
        let output = viewModel.transform(input: input)
        
        output.popToMyInfoView
            .drive(onNext:{
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showBankModel
            .subscribe(onNext: { [weak self] in
                let modalVC = BankListModalVC()
                                modalVC.modalPresentationStyle = .formSheet
                                modalVC.modalTransitionStyle = .coverVertical
                modalVC.selectedBankName
                    .bind { [weak self] bankName in
                        self?.bankNameLabel.text = bankName
                        print(bankName)
                    }
                    .disposed(by: modalVC.disposeBag)
                self?.present(modalVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
    }

        
    
    
    //Pay류 isTrue값에 따라 버튼 색상 변경 함수
    //    func payColor() {
    //        PayData.shared.tossPayEnabled
    //            .drive(onNext: { isToggled in
    //                self.tossPayView.backgroundColor = isToggled ? UIColor.blue : UIColor.gray
    //            })
    //            .disposed(by: disposeBag)
    //
    //        PayData.shared.kakaoPayEnabled
    //            .drive(onNext: { isToggled in
    //                self.kakaoPayView.backgroundColor = isToggled ? UIColor.systemYellow : UIColor.gray
    //            })
    //            .disposed(by: disposeBag)
    //
    //        PayData.shared.naverPayEnabled
    //            .drive(onNext: { isToggled in
    //                self.naverPayView.backgroundColor = isToggled ? UIColor.systemGreen : UIColor.gray
    //            })
    //            .disposed(by: disposeBag)
    //    }
}

extension MyBankAccountVC: UITextFieldDelegate {
    
}

