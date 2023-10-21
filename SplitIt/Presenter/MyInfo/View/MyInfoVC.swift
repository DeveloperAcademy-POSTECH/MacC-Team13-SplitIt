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
import RealmSwift

class MyInfoVC: UIViewController {
    
    var viewModel = MyInfoVM()
    var disposeBag = DisposeBag()
    let userDefault = UserDefaults.standard
    var backViewHeightConstraint: Constraint?
    
    let header = NavigationHeader()
    let userNameLabel = UILabel()
    let userName = UILabel()
    let userBar = UIView()
    
    let backView = UIView()
    var backViewHeight: CGFloat = 104
    
    let accountView = UIView()
    let tmpView = UIView()
    let accountInfoLabel = UILabel()
    
    let accountEditView = UIView()
    let accountEditLabel = UILabel()
    let accountEditChevron = UIImageView()
    
    let accountBankLabel = UILabel()
    let accountLabel = UILabel()
    
    let socialPayLabel = UILabel()
    let tossPayBtn = UIButton()
    let tossPayLabel = UILabel()
    
    let kakaoPayLabel = UILabel()
    let kakaoPayBtn = UIButton()
    
    let naverPayLabel = UILabel()
    let naverPayBtn = UIButton()
    
    let splitLabel = UILabel()
    
    let friendView = UIView()
    
    let friendListView = UIView()
    let friendListLabel = UILabel()
    let friendImage = UIImageView()
    let friendChevron = UIImageView()
    
    let friendBar = UIView()
    
    let exclItemListView = UIView()
    let exclItemLabel = UILabel()
    let exclItemImage = UIImageView()
    let exclItemChevron = UIImageView()
    
    let privacyBtn = UIButton()
    
    
    let mainLabel = UILabel() //반갑습니다 정산자님
    let subLabel = UILabel() // 정산받을 곳을 ~ 시작해보세요!
    
    let emptyAccountEditView = UIView()
    let emptyAccountEditLabel = UILabel() //시작하기
    let emptyAccountEditChevron = UIImageView()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setAddView()
        setAttribute()
        setLayout()
        setBinding()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           userNewInfo()
       }
    
 

    func userNewInfo() {
        
        //userDefault.set("냐냐ㅑㄴ", forKey: "userName")
        if let tmpuserName = UserDefaults.standard.string(forKey: "userName"), !tmpuserName.isEmpty {
               accountView.isHidden = false
               tmpView.isHidden = true
                backViewHeight = 235
            
            backView.snp.removeConstraints()

            // backView 제약 조건 재설정
            backView.snp.makeConstraints { make in
                make.height.equalTo(backViewHeight)
                make.width.equalTo(330)
                make.top.equalTo(view).offset(118)
                make.centerX.equalTo(view)
                
            }
           } else {
               accountView.isHidden = true
               tmpView.isHidden = false
               backViewHeight = 104
               
               backView.snp.removeConstraints()

               // backView 제약 조건 재설정
               backView.snp.makeConstraints { make in
                   make.height.equalTo(backViewHeight)
                   make.width.equalTo(330)
                   make.top.equalTo(view).offset(118)
                   make.centerX.equalTo(view)
               }
           }
        
    
        
        
        self.userName.text = UserDefaults.standard.string(forKey: "userName")
        self.accountBankLabel.text = UserDefaults.standard.string(forKey: "userBank")
        self.accountLabel.text = UserDefaults.standard.string(forKey: "userAccount")
        
        self.tossPayBtn.backgroundColor = userDefault.bool(forKey: "tossPay") ? UIColor.systemBlue : UIColor.gray
        self.kakaoPayBtn.backgroundColor = userDefault.bool(forKey: "kakaoPay") ? UIColor.systemYellow : UIColor.gray
        self.naverPayBtn.backgroundColor = userDefault.bool(forKey: "naverPay") ? UIColor.systemGreen : UIColor.gray
    }
    
    func addTapGesture(to view: UIView) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
    
    func setBinding() {
        
        let friendListTap = addTapGesture(to: friendListView)
        let exclItemTap = addTapGesture(to: exclItemListView)
        let editBtnTap = addTapGesture(to: accountEditView)
        let startBtnTap = addTapGesture(to: emptyAccountEditView)
        
        let input = MyInfoVM.Input(privacyBtnTapped: privacyBtn.rx.tap.asDriver(),
                                   friendListViewTapped: friendListTap.rx.event.asObservable().map { _ in () },
                                   exclItemViewTapped: exclItemTap.rx.event.asObservable().map { _ in () },
                                   editAccountViewTapped: editBtnTap.rx.event.asObservable().map{ _ in () }, emptyEditAccountViewTapped: startBtnTap.rx.event.asObservable().map{ _ in () }
        )
                
        let output = viewModel.transform(input: input)
        
        
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
                let memberLogVC = MemberLogVC()
                self.navigationController?.pushViewController(memberLogVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        output.moveToExclItemListView
            .subscribe(onNext: {
                print("먹지 않은 뷰 이동")
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
            })
            .disposed(by: disposeBag)
        
        
        output.moveToEditAccountView
            .subscribe(onNext: {
                print("계좌수정뷰 이동")
                let bankVC = MyBankAccountVC()
                self.navigationController?.pushViewController(bankVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        output.moveToInitAccountView
            .subscribe(onNext: {
                print("계좌수정뷰 이동")
                let bankVC = MyBankAccountVC()
                self.navigationController?.pushViewController(bankVC, animated: true)
                
            })
            .disposed(by: disposeBag)
    }

    func setAddView() {
        
       // myInfoEmptyVC.tmpView = self.tmpView
        
        [header, backView, splitLabel,friendView, privacyBtn].forEach {
            view.addSubview($0)
        }
        
        backView.addSubview(tmpView)
        backView.addSubview(accountView)
        
        
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
        
        
        [mainLabel, subLabel, emptyAccountEditView].forEach{
            tmpView.addSubview($0)
        }
        [emptyAccountEditLabel, emptyAccountEditChevron].forEach {
            emptyAccountEditView.addSubview($0)
        }
        

    }
    
    func setAttribute() {
        view.backgroundColor = .white
        tmpView.backgroundColor = .white
        backView.backgroundColor = .white
        
        let privacyBtnString = NSAttributedString(string: "개인정보 처리방침", attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])

        //밑줄 만들어주기 위한 attribute
        let attributedString = NSMutableAttributedString(string: "수정하기")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        
        
        header.do {
            $0.configureBackButton(viewController: self)
        }
        
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
            $0.text = "일단 userDefault초기화댐 원래는 따로 먹은 것들"
            $0.font = UIFont.systemFont(ofSize: 9)
        }

        
        privacyBtn.do {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 0
            $0.setAttributedTitle(privacyBtnString, for: .normal)
        }
        
        
        
        let emptyString = NSMutableAttributedString(string: "시작하기")
        emptyString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: emptyString.length))
        
        
        tmpView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray.cgColor
        }
        
        mainLabel.do {
            $0.text = "반갑습니다 정산자님 🥳"
            $0.font = UIFont.systemFont(ofSize: 21)
        }
        
        subLabel.do {
            $0.text = "정산받을 곳을 입력하고 바로 정산을 시작해보세요!"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.gray
        }
        emptyAccountEditView.do {
            $0.backgroundColor = .clear
        }
        
        emptyAccountEditLabel.do {
            $0.attributedText = attributedString
            $0.font = UIFont.systemFont(ofSize: 13)
        }
     
        
        emptyAccountEditChevron.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = UIColor.gray
        }
    }
    
    func setLayout() {
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tmpView.snp.makeConstraints { make in
            make.height.equalTo(104)
            make.width.equalTo(330)
            make.center.equalTo(backView)
        }
       
        accountView.snp.makeConstraints { make in
            make.height.equalTo(230)
            make.width.equalTo(330)
            //make.top.equalTo(backView).offset(118)
            make.center.equalTo(backView)
        }
        
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(accountView).offset(16)
            make.left.equalTo(accountView).offset(16)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountView).offset(20)
            make.left.equalTo(userName.snp.right).offset(5)
        }
        
        accountEditView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(18)
            make.right.equalTo(accountView).offset(-16)
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
            make.top.equalTo(accountView).offset(50)
            make.centerX.equalTo(accountView)
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
            make.top.equalTo(backView.snp.bottom).offset(16) //dddd
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
        
        
        mainLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        
        subLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
        }
        
        emptyAccountEditView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(18)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        emptyAccountEditLabel.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        emptyAccountEditChevron.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(9)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    


    
}

