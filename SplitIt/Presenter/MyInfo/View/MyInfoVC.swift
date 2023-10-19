//
//  MyInfoVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices
import SnapKit
import Then

class MyInfoVC: UIViewController {
    
    var viewModel = MyInfoVM()
    var disposeBag = DisposeBag()
    let userData = UserData.shared.userData
    
    private let userNameLabel = UILabel()
    private let userName = UILabel()
    private let userBar = UIView()
    
    private let accountView = UIView()
    private let accountInfoLabel = UILabel()

    
    private let accountEditView = UIView()
    private let accountEditLabel = UILabel()
    private let accountEditChevron = UIImageView()
    
    private let accountBankLabel = UILabel()
    private let accountLabel = UILabel()
    
    private let socialPayLabel = UILabel()
    private let tossPayBtn = UIButton()
    private let tossPayLabel = UILabel()
    
    private let kakaoPayLabel = UILabel()
    private let kakaoPayBtn = UIButton()
    
    private let naverPayLabel = UILabel()
    private let naverPayBtn = UIButton()
    
    private let splitLabel = UILabel()
    
    private let friendView = UIView()
    
    private let friendListView = UIView()
    private let friendListLabel = UILabel()
    private let friendImage = UIImageView()
    private let friendChevron = UIImageView()
    
    private let friendBar = UIView()
    
    private let exclItemListView = UIView()
    private let exclItemLabel = UILabel()
    private let exclItemImage = UIImageView()
    private let exclItemChevron = UIImageView()
    
    
    private let privacyBtn = UIButton()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setAddView()
        setAttribute()
        setLayout()
        setBinding()
        payColor()
        
    }
    
    func setBinding() {
        
        let friendListTap = UITapGestureRecognizer()
        friendListView.addGestureRecognizer(friendListTap)
        
        let exclItemTap = UITapGestureRecognizer()
        exclItemListView.addGestureRecognizer(exclItemTap)
        
        let editBtnTap = UITapGestureRecognizer()
        accountEditView.addGestureRecognizer(editBtnTap)
        
        let input = MyInfoVM.Input(privacyBtnTapped: privacyBtn.rx.tap.asDriver(),
                                   friendListViewTapped: friendListTap.rx.event.asObservable().map { _ in () },
                                   exclItemViewTapped: exclItemTap.rx.event.asObservable().map { _ in () },
                                   editAccountViewTapped: editBtnTap.rx.event.asObservable().map{ _ in () }
                                   
                                   
        )
        
        let output = viewModel.transform(input: input)
        
 
                //                let bankVC = BankAccountVC()
                //                self.navigationController?.pushViewController(bankVC, animated: true)
           
        
        output.moveToPrivacyView
            .drive(onNext:{
                print("개인정보 처리방침 이동dd")
                let url = NSURL(string: "https://www.naver.com")
                let privacyWebView: SFSafariViewController = SFSafariViewController(url: url! as URL)
                self.present(privacyWebView, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        
        output.moveTofriendListView
            .subscribe(onNext: {
                print("친구뷰 이동")
                
            })
            .disposed(by: disposeBag)
        
        output.moveToExclItemListView
            .subscribe(onNext: {
                print("먹지 않은 뷰 이동")
                
            })
            .disposed(by: disposeBag)
        
        output.moveToEditAccountView
            .subscribe(onNext: {
                print("계좌수정뷰 이동")
                //                let bankVC = BankAccountVC()
                //                self.navigationController?.pushViewController(bankVC, animated: true)
           
            })
            .disposed(by: disposeBag)
        
        
        UserData.shared.userData
            .subscribe(onNext: { user in
                self.userName.text = user.name
                self.accountBankLabel.text = user.bank
                self.accountLabel.text = user.account
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    
    func setAddView() {
        [accountView, splitLabel,friendView, privacyBtn].forEach {
            view.addSubview($0)
        }
        [userNameLabel, userName, userBar, accountInfoLabel, accountBankLabel, accountLabel,socialPayLabel, tossPayBtn, tossPayLabel, kakaoPayBtn, kakaoPayLabel, naverPayBtn, naverPayLabel, accountEditView].forEach {
            accountView.addSubview($0)
        }
        [accountEditLabel, accountEditChevron].forEach {
            accountEditView.addSubview($0)
        }
        [friendBar,friendListView, exclItemListView].forEach {
            friendView.addSubview($0)
        }
        
        [friendImage, friendChevron, friendListLabel].forEach {
            friendListView.addSubview($0)
        }
        [exclItemImage, exclItemChevron, exclItemLabel].forEach {
            exclItemListView.addSubview($0)
        }
        

    }
    
    
    func setAttribute() {
        view.backgroundColor = .white
//
//        self.navigationController?.navigationBar.topItem?.title = ""
//        self.navigationItem.title = "나의 정보"
//
        
        let privacyBtnString = NSAttributedString(string: "개인정보 처리방침", attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        
//        let accountEditBtnString = NSAttributedString(string: "수정하기", attributes: [
//            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
//        ])
        
        
        let attributedString = NSMutableAttributedString(string: "수정하기")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        
        userName.do {
            $0.font = UIFont.boldSystemFont(ofSize: 24)
        }

        userNameLabel.do {
            $0.text = "님"
            $0.font = UIFont.systemFont(ofSize: 18)
        }
        
        userBar.do{
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
        }
       
        accountView.do {
            $0.layer.cornerRadius = 16
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .clear
        }
        
        accountInfoLabel.do {
            $0.text = "정산 받을 계좌"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.gray
        }
        
        accountBankLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18)
        }
            
        accountLabel.do {
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        

        
        accountEditView.do {
            $0.backgroundColor = .clear
        }
        
        accountEditLabel.do {
            $0.attributedText = attributedString
            $0.font = UIFont.systemFont(ofSize: 13)
        }
        
        accountEditChevron.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = UIColor.gray
        }
        
        socialPayLabel.do {
            $0.text = "사용하는 간편페이"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.gray
        }
        
        
        tossPayBtn.do {
            $0.setTitle("토스", for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.titleLabel?.font = .systemFont(ofSize: 13)
        }
        
        tossPayLabel.do {
            $0.text = "토스뱅크"
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        
        
        kakaoPayBtn.do {
            $0.setTitle("카카오", for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.titleLabel?.font = .systemFont(ofSize: 13)
        }
        
            kakaoPayLabel.do {
                $0.text = "카카오페이"
                $0.font = UIFont.systemFont(ofSize: 12)
            }
        
            
        naverPayBtn.do {
            $0.setTitle("네이버", for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.titleLabel?.font = .systemFont(ofSize: 13)
        }
        
        naverPayLabel.do {
            $0.text = "네이버페이"
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        
        splitLabel.do {
            $0.text = "정산 기록"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.gray
        }
        
        
        friendView.do {
            $0.layer.cornerRadius = 16
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .clear
        }
        
        friendBar.do {
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
        }
        
        friendListView.backgroundColor = .clear
        
        friendImage.do {
            $0.image = UIImage(systemName: "person.2.fill")
            $0.tintColor = UIColor.gray
        }
        
        friendChevron.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = UIColor.gray
        }
        
        friendListLabel.do {
            $0.text = "나와 함께한 사람들"
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        
        exclItemListView.backgroundColor = .clear
        
        exclItemImage.do {
            $0.image = UIImage(systemName: "star.fill")
            $0.tintColor = UIColor.gray
        }
        exclItemChevron.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = UIColor.gray
        }
        
        exclItemLabel.do {
            $0.text = "따로 계산한 것들"
            $0.font = UIFont.systemFont(ofSize: 15)
        }

        
        privacyBtn.do {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 0
            $0.setAttributedTitle(privacyBtnString, for: .normal)
        }
        
    }
    
    func setLayout() {
        accountView.snp.makeConstraints { make in
            make.height.equalTo(230)
            make.width.equalTo(330)
            make.top.equalToSuperview().offset(118)
            make.centerX.equalToSuperview()
        }
        
        userName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(userName.snp.right).offset(5)
        }
        
        accountEditView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(18)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(userBar.snp.bottom).offset(-8)
        }
        
        accountEditLabel.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        accountEditChevron.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(9)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        userBar.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(298)
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        
        accountInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(userBar.snp.top).offset(16)
            make.left.equalTo(accountView.snp.left).offset(16)
        }
        
        accountBankLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(2)
            make.left.equalTo(accountView.snp.left).offset(16)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(2)
            make.left.equalTo(accountBankLabel.snp.right).offset(4)
        }
        
        socialPayLabel.snp.makeConstraints { make in
            make.top.equalTo(accountBankLabel.snp.bottom).offset(12)
            make.left.equalTo(accountView.snp.left).offset(16)
        }
        
        
        tossPayBtn.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.equalTo(socialPayLabel.snp.bottom).offset(2)
            make.left.equalTo(accountView.snp.left).offset(16)
        }
        
        tossPayLabel.snp.makeConstraints { make in
            //make.width.equalTo(50)
            make.top.equalTo(tossPayBtn.snp.bottom).offset(6)
            make.left.equalTo(accountView.snp.left).offset(18)
        }
        
        
        kakaoPayBtn.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.equalTo(socialPayLabel.snp.bottom).offset(2)
            make.left.equalTo(tossPayBtn.snp.right).offset(8)
        }
        
        
        kakaoPayLabel.snp.makeConstraints { make in
            //make.width.equalTo(50)
            make.top.equalTo(kakaoPayBtn.snp.bottom).offset(6)
            make.left.equalTo(tossPayLabel.snp.right).offset(14)
        }
        
        naverPayBtn.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.equalTo(socialPayLabel.snp.bottom).offset(2)
            make.left.equalTo(kakaoPayBtn.snp.right).offset(14)
        }
        
        naverPayLabel.snp.makeConstraints { make in
            //make.width.equalTo(50)
            make.top.equalTo(naverPayBtn.snp.bottom).offset(6)
            make.left.equalTo(kakaoPayLabel.snp.right).offset(14)
        }
        
        splitLabel.snp.makeConstraints { make in
            make.top.equalTo(accountView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(40)
        }
        
        
        friendView.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.width.equalTo(330)
            make.top.equalTo(splitLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        friendListView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        friendImage.snp.makeConstraints { make in
            //            make.height.equalTo(24)
            //            make.width.equalTo(37.5)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        friendListLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(16)
        }
        
        friendChevron.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.width.equalTo(12)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        
        friendBar.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(298)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        exclItemListView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        exclItemImage.snp.makeConstraints { make in
            //            make.height.equalTo(24)
            //            make.width.equalTo(22)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        exclItemLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(16)
        }
        
        exclItemChevron.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.width.equalTo(12)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-16)
        }
        

        
        privacyBtn.snp.makeConstraints { make in
            
            make.bottom.equalToSuperview().offset(-54)
            make.centerX.equalToSuperview()
        }
    }
    

    func payColor() {
        PayData.shared.tossPayEnabled
            .drive(onNext: { isToggled in
                self.tossPayBtn.backgroundColor = isToggled ? UIColor.blue : UIColor.gray
            })
            .disposed(by: disposeBag)
        
        PayData.shared.kakaoPayEnabled
            .drive(onNext: { isToggled in
                self.kakaoPayBtn.backgroundColor = isToggled ? UIColor.systemYellow : UIColor.gray
            })
            .disposed(by: disposeBag)
        
        PayData.shared.naverPayEnabled
            .drive(onNext: { isToggled in
                self.naverPayBtn.backgroundColor = isToggled ? UIColor.systemGreen : UIColor.gray
            })
            .disposed(by: disposeBag)
    }
    
    
}

