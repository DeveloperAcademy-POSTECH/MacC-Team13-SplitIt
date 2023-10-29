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
    
    let header = NaviHeader()

    var viewModel = MyInfoVM()
    var disposeBag = DisposeBag()
    let userDefault = UserDefaults.standard
    var backViewHeightConstraint: Constraint?
    
    let backView = UIView() //emptyView와 accountView 생성되는 뷰
    var backViewHeight: CGFloat = 104
    var tossPos: CGFloat = 10
    var kakaoPos: CGFloat = 100
    var naverPos: CGFloat = 300
    
    
    //>>>backView위에 그려지는 뷰
    //>>>accountView 시작
    let accountView = UIView() //userDefault에 정보있을 때 나타나는 뷰
    
    let userName = UILabel() // 사용자의 이름
    let userNameLabel = UILabel()
    
    let accountEditView = UIView()
    let accountEditLabel = UILabel() //수정하기
    let accountEditChevron = UIImageView()
    
    let userBar = UIView()
    
    let accountInfoLabel = UILabel()
    
    let accountBankLabel = UILabel() //userDefaults에서 받아온 은행 이름
    let accountLabel = UILabel() //userDefault에서 받아온 사용자 계좌
    let accountNameLabel = UILabel()
    
    let socialPayLabel = UILabel()
    
    let tossView = UIView()
    let tossPayBtn = UIImageView()
    let tossPayLabel = UILabel()
    
    let kakaoView = UIView()
    let kakaoPayBtn = UIImageView()
    let kakaoPayLabel = UILabel()
    
    let naverView = UIView()
    let naverPayBtn = UIImageView()
    let naverPayLabel = UILabel()
    
    //>>>accountView 끝
    //>>>emptyView 시작
    //userDafault에 값 없을 때, 나타나는 뷰
    
    let emptyView = UIView()
    let mainLabel = UILabel() //반갑습니다 정산자님
    let subLabel = UILabel() // 정산받을 곳을 ~ 시작해보세요!
    
    let emptyAccountEditView = UIView()
    let emptyAccountEditLabel = UILabel() //시작하기
    let emptyAccountEditChevron = UIImageView()
    
    //>>>emptyView 끝
    
    let notUsedPay = UILabel() //간편페이를 사용하지 않아요
    
    let splitLabel = UILabel()
    
    let friendView = UIView()
    
    let friendListView = UIView()
    let friendListLabel = UILabel()
    let friendImage = UIImageView()
    let friendChevron = UIImageView()
    
   // let friendBar = UIView()
    
//    let exclItemListView = UIView()
//    let exclItemLabel = UILabel()
//    let exclItemImage = UIImageView()
//    let exclItemChevron = UIImageView()
//
    let privacyBtn = UIButton()
    
    let tossValue = UserDefaults.standard.bool(forKey: "tossPay")
    let kakaoValue = UserDefaults.standard.bool(forKey: "kakaoPay")
    let naverValue = UserDefaults.standard.bool(forKey: "naverPay")
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        backView.backgroundColor = .red
        setAddView()
        setAttribute()
        setLayout()
        setBinding()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNewInfo()
        //asapRxData()
    }
    
    func userNewInfo() {
        
        let tossValue = userDefault.bool(forKey: "tossPay")
        let kakaoValue = userDefault.bool(forKey: "kakaoPay")
        let naverValue = userDefault.bool(forKey: "naverPay")
        
        if let tmpuserName = UserDefaults.standard.string(forKey: "userNickName"), !tmpuserName.isEmpty { //userDefaults에 값이 있을 떄
            accountView.isHidden = false
            emptyView.isHidden = true
            backViewHeight = 235
            
            backView.snp.updateConstraints { make in
                make.height.equalTo(backViewHeight)
            }

        } else { //emptyView일 때
            
            print("텅뷰보임 보임")
            accountView.isHidden = true
            emptyView.isHidden = false
            
            backViewHeight = 104
            
//            backView.snp.updateConstraints { make in
//                make.height.equalTo(backViewHeight)
//            }
            
            backView.snp.removeConstraints()
            splitLabel.snp.removeConstraints()
            
            // backView 제약 조건 재설정
            backView.snp.makeConstraints { make in
                make.height.equalTo(backViewHeight)
                make.width.equalTo(330)
                make.top.equalTo(view).offset(118)
                make.centerX.equalTo(view)
            }
//
            splitLabel.snp.makeConstraints { make in
                make.top.equalTo(backView.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(40)
            }
            
            
        }
        
        
        self.userName.text = userDefault.string(forKey: "userNickName")
        self.accountBankLabel.text = userDefault.string(forKey: "userBank")
        self.accountLabel.text = userDefault.string(forKey: "userAccount")
        self.accountNameLabel.text = userDefault.string(forKey: "userName")
        
        
        if let tmpuserName = UserDefaults.standard.string(forKey: "userName"), !tmpuserName.isEmpty { //accountView가 있을 때
            if !tossValue && !kakaoValue && !naverValue  {
                //간편페이류 없을 떄
                print(tossValue, kakaoValue, naverValue)
                notUsedPay.isHidden = false
                tossView.isHidden = true
                kakaoView.isHidden = true
                naverView.isHidden = true
                
                backViewHeight = 175
                

                backView.snp.removeConstraints()
                accountView.snp.removeConstraints()
                splitLabel.snp.removeConstraints()
                
                backView.snp.makeConstraints { make in
                    make.height.equalTo(backViewHeight)
                    make.width.equalTo(330)
                    make.top.equalTo(view).offset(118)
                    make.centerX.equalTo(view)

                }

                splitLabel.snp.makeConstraints { make in
                    make.top.equalTo(backView.snp.bottom).offset(16)
                    make.leading.equalToSuperview().offset(40)
                }
                
                accountView.snp.makeConstraints { make in
                    make.height.equalTo(backViewHeight)
                    make.width.equalTo(330)
                    make.center.equalTo(backView)
                }
                
                
            } else {
                //간편페이류 있음
                backViewHeight = 235
                notUsedPay.isHidden = true
                tossView.isHidden = !tossValue
                kakaoView.isHidden = !kakaoValue
                naverView.isHidden = !naverValue
                
                tossPos = tossValue ? 12 : 0
                
                if tossValue { //토스가 true
                    kakaoPos = 70
                    
                    if kakaoValue { //카카오가 참
                        naverPos = 128
                    } else { //카카오가 거짓
                        naverPos = 70
                    }
                } else { //토스가 false
                    kakaoPos = 12
                    
                    if kakaoValue { //카카오가 참
                        naverPos = 70
                    } else { //카카오가 거짓
                        naverPos = 12
                    }
                }
            
                backView.snp.removeConstraints()
                accountView.snp.removeConstraints()
                tossView.snp.removeConstraints()
                kakaoView.snp.removeConstraints()
                naverView.snp.removeConstraints()
                

                
                backView.snp.makeConstraints { make in
                    make.height.equalTo(backViewHeight)
                    make.width.equalTo(330)
                    make.top.equalTo(view).offset(118)
                    make.centerX.equalTo(view)

                }
                
                accountView.snp.makeConstraints { make in
                    make.height.equalTo(backViewHeight)
                    make.width.equalTo(330)
                    make.center.equalTo(backView)
                }
                
                
                
                tossView.snp.makeConstraints { make in
                    make.width.equalTo(54)
                    make.height.equalTo(73)
                    make.leading.equalTo(accountView.snp.leading).offset(tossPos)
                    make.top.equalTo(socialPayLabel.snp.bottom).offset(4)
                }
                
                kakaoView.snp.makeConstraints { make in
                    make.width.equalTo(54)
                    make.height.equalTo(73)
                    make.leading.equalTo(accountView.snp.leading).offset(kakaoPos)
                    make.top.equalTo(socialPayLabel.snp.bottom).offset(4)
                }
                naverView.snp.makeConstraints { make in
                    make.width.equalTo(54)
                    make.height.equalTo(73)
                    make.leading.equalTo(accountView.snp.leading).offset(naverPos)
                    make.top.equalTo(socialPayLabel.snp.bottom).offset(4)
                }
            }
            
            
            self.view.layoutIfNeeded()
        }
        
        
        
    }
    
    func setBinding() {
        
        let friendListTap = addTapGesture(to: friendListView)
       // let exclItemTap = addTapGesture(to: exclItemListView)
        let editBtnTap = addTapGesture(to: accountEditView)
        let startBtnTap = addTapGesture(to: emptyAccountEditView)
        
        let input = MyInfoVM.Input(privacyBtnTapped: privacyBtn.rx.tap.asDriver(),
                                   friendListViewTapped: friendListTap.rx.event.asObservable().map { _ in () },
                                  // exclItemViewTapped: exclItemTap.rx.event.asObservable().map { _ in () },
                                   editAccountViewTapped: editBtnTap.rx.event.asObservable().map{ _ in () }, emptyEditAccountViewTapped: startBtnTap.rx.event.asObservable().map{ _ in () }
        )
        
        let output = viewModel.transform(input: input)
        
        
        output.moveToPrivacyView
            .drive(onNext:{
                print("개인정보 처리방침 이동dd")
//                let url = NSURL(string: "https://kori-collab.notion.site/e3407a6ca4724b078775fd13749741b1?pvs=4")
//                let privacyWebView: SFSafariViewController = SFSafariViewController(url: url! as URL)
//                self.present(privacyWebView, animated: true, completion: nil)
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                                    UserDefaults.standard.removeObject(forKey: key.description)
                                }
            })
            .disposed(by: disposeBag)
        
        
        output.moveTofriendListView
            .subscribe(onNext: {
                let memberLogVC = MemberLogVC()
                self.navigationController?.pushViewController(memberLogVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        
//        output.moveToExclItemListView
//            .subscribe(onNext: {
//                print("먹지 않은 뷰 이동")
//                //MARK: UserDefaults 초기화 버튼으로 임시 활용
//                for key in UserDefaults.standard.dictionaryRepresentation().keys {
//                    UserDefaults.standard.removeObject(forKey: key.description)
//                }
//            })
//            .disposed(by: disposeBag)
//
        
        output.moveToEditAccountView
            .subscribe(onNext: {
                //정보수정하는 뷰로 이동
                let bankVC = MyBankAccountVC()
                self.navigationController?.pushViewController(bankVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        output.moveToInitAccountView
            .subscribe(onNext: {
                //정보 초기설정하는 뷰로 이동
                let bankVC = MyBankAccountVC()
                self.navigationController?.pushViewController(bankVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
       
    }
    
    func setAddView() {
        
        [header, backView, splitLabel, friendView, privacyBtn].forEach {
            view.addSubview($0)
        }
        
        backView.addSubview(emptyView)
        backView.addSubview(accountView)
        
        [userNameLabel, userName, userBar, accountInfoLabel, accountBankLabel, accountLabel,accountNameLabel, socialPayLabel, tossView, kakaoView, naverView, notUsedPay, accountEditView].forEach {
            accountView.addSubview($0)
        }
        
        [tossPayBtn, tossPayLabel].forEach {
            tossView.addSubview($0)
        }
        
        [kakaoPayBtn, kakaoPayLabel].forEach {
            kakaoView.addSubview($0)
        }
        
        [naverPayBtn, naverPayLabel].forEach {
            naverView.addSubview($0)
        }
        
        [accountEditLabel, accountEditChevron].forEach {
            accountEditView.addSubview($0)
        }
        
        
        friendView.addSubview(friendListView)
        
//        [friendBar,friendListView, exclItemListView].forEach {
//            friendView.addSubview($0)
//        }
//
        [friendImage, friendChevron, friendListLabel].forEach {
            friendListView.addSubview($0)
        }
//        [exclItemImage, exclItemChevron, exclItemLabel].forEach {
//            exclItemListView.addSubview($0)
//        }
//
        
        [mainLabel, subLabel, emptyAccountEditView].forEach{
            emptyView.addSubview($0)
        }
        [emptyAccountEditLabel, emptyAccountEditChevron].forEach {
            emptyAccountEditView.addSubview($0)
        }
        
        
    }
    
    func setAttribute() {
        
        view.backgroundColor = .SurfaceBrandCalmshell
        emptyView.backgroundColor = .clear
        backView.backgroundColor = .clear
        
        
        let privacyBtnString = NSAttributedString(string: "개인정보 처리방침", attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        
        //밑줄 만들어주기 위한 attribute
        let attributedString = NSMutableAttributedString(string: "수정하기")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        
        
        header.do {
            $0.applyStyle(.setting)
            $0.setBackButton(viewController: self)
        }
        
        userName.do {
            $0.font = UIFont.boldSystemFont(ofSize: 24)
        }
        
        userNameLabel.do {
            $0.text = "님"
            $0.font = UIFont.systemFont(ofSize: 18)
        }
        
        userBar.do {
            $0.layer.borderColor = UIColor.BorderDeactivate.cgColor
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
        
        accountNameLabel.do {
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
        
        notUsedPay.do {
            $0.text = "간편페이를 사용하지 않아요"
            $0.font = .KoreanCaption2
        }
        
        
        tossPayBtn.do {
            $0.image = UIImage(named: "TossPayIconDefault")
            
        }
        
        tossPayLabel.do {
            $0.text = "토스뱅크"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textAlignment = .center
        }
        
        
        kakaoPayBtn.do {
            $0.image = UIImage(named: "KakaoPayIconDefault")
        }
        
        kakaoPayLabel.do {
            $0.text = "카카오페이"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textAlignment = .center
        }
        
        
        naverPayBtn.do {
            $0.image = UIImage(named: "NaverPayIconDefault")
            
            
        }
        
        naverPayLabel.do {
            $0.text = "네이버페이"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textAlignment = .center
        }
        
        splitLabel.do {
            $0.text = "정산 기록"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextSecondary
        }
        
        
        friendView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .clear
        }
        
//        friendBar.do {
//            $0.layer.borderColor = UIColor.BorderDeactivate.cgColor
//            $0.layer.borderWidth = 1
//        }
        
        friendListView.backgroundColor = .clear
        
        friendImage.do {
            $0.image = UIImage(named: "MemberIcon")
        }
        
        friendChevron.do {
            $0.image = UIImage(named: "ChevronRightIconDefault")
        }
        
        friendListLabel.do {
            $0.text = "나와 함께한 사람들"
            $0.font = UIFont.KoreanCaption1
        }
        
//        exclItemListView.backgroundColor = .clear
//
//        exclItemImage.do {
//            $0.image = UIImage(named: "SplitIconSmall")
//        }
//        exclItemChevron.do {
//            $0.image = UIImage(named: "ChevronRightIconDefault")
//        }
//
//        exclItemLabel.do {
//            $0.text = "따로 계산한 것들" // 모아나: 일단 userDefault초기화댐 원래는 따로 먹은 것들
//            $0.font = UIFont.KoreanCaption1
//        }
//
        
        privacyBtn.do {
            $0.titleLabel?.font = UIFont.KoreanCaption2
            $0.titleLabel?.textColor = UIColor.TextSecondary
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 0
            $0.setAttributedTitle(privacyBtnString, for: .normal)
        }
        
        
        
        let emptyString = NSMutableAttributedString(string: "시작하기")
        emptyString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: emptyString.length))
        
        
        emptyView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
        }
        
        mainLabel.do {
            $0.text = "정산자님, 반갑습니다 🥳"
            $0.font = UIFont.KoreanSubtitle
        }
        
        subLabel.do {
            $0.text = "정산받을 곳을 입력하여 정산을 준비해보세요"
            $0.font = UIFont.KoreanCaption2
            $0.textColor = UIColor.TextPrimary
        }
        
        emptyAccountEditView.do {
            $0.backgroundColor = .clear
        }
        
        emptyAccountEditLabel.do {
            $0.attributedText = emptyString
            $0.font = UIFont.KoreanCaption2
        }
        
        
        emptyAccountEditChevron.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = UIColor.gray
        }
    }
    
    func setLayout() {
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.height.equalTo(104)
            make.width.equalTo(330)
            make.center.equalTo(backView)
        }
        
        accountView.snp.makeConstraints { make in
            make.height.equalTo(230)
            make.width.equalTo(330)
            make.center.equalTo(backView)
        }
        
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(accountView).offset(16)
            make.leading.equalTo(accountView).offset(16)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountView).offset(20)
            make.leading.equalTo(userName.snp.trailing).offset(5)
        }
        
        accountEditView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(18)
            make.trailing.equalTo(accountView).offset(-16)
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
            make.trailing.equalToSuperview()
        }
        
        userBar.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(298)
            make.top.equalTo(userName.snp.bottom).offset(4)
            make.centerX.equalTo(accountView)
        }
        
        
        accountInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(userBar.snp.top).offset(16)
            make.leading.equalTo(accountView.snp.leading).offset(16)
        }
        
        
        accountBankLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(2)
            make.leading.equalTo(accountView.snp.leading).offset(16)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(2)
            make.leading.equalTo(accountBankLabel.snp.trailing).offset(4)
        }
        
        accountNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(2)
            make.leading.equalTo(accountLabel.snp.trailing).offset(4)
        }
        socialPayLabel.snp.makeConstraints { make in
            make.top.equalTo(accountBankLabel.snp.bottom).offset(12)
            make.leading.equalTo(accountView.snp.leading).offset(16)
        }
        
        //        tossView.snp.makeConstraints { make in
        //            make.width.equalTo(54)
        //            make.height.equalTo(73)
        //            make.leading.equalTo(accountView.snp.leading).offset(tossPos)
        //            make.top.equalTo(socialPayLabel.snp.bottom).offset(4)
        //        }
        
        tossPayBtn.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.equalTo(tossView)
            make.centerX.equalTo(tossView)
        }
        
        tossPayLabel.snp.makeConstraints { make in
            make.bottom.equalTo(tossView)
            make.centerX.equalTo(tossView)
        }
        
        
        //        kakaoView.snp.makeConstraints { make in
        //            make.width.equalTo(54)
        //            make.height.equalTo(73)
        //            make.leading.equalTo(accountView.snp.leading).offset(kakaoPos)
        //            make.top.equalTo(socialPayLabel.snp.bottom).offset(4)
        //        }
        
        kakaoPayBtn.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.equalTo(kakaoView)
            make.centerX.equalTo(kakaoView)
        }
        
        
        kakaoPayLabel.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoView)
            make.centerX.equalTo(kakaoView)
        }
        
        //        naverView.snp.makeConstraints { make in
        //            make.width.equalTo(54)
        //            make.height.equalTo(73)
        //            make.leading.equalTo(accountView.snp.leading).offset(naverPos)
        //            make.top.equalTo(socialPayLabel.snp.bottom).offset(4)
        //        }
        
        naverPayBtn.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.equalTo(naverView)
            make.centerX.equalTo(naverView)
        }
        
        naverPayLabel.snp.makeConstraints { make in
            make.bottom.equalTo(naverView)
            make.centerX.equalTo(naverView)
        }
        
        splitLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(40)
        }
        
        
        friendView.snp.makeConstraints { make in
            //make.height.equalTo(110)
            make.height.equalTo(52)
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
            make.top.equalToSuperview().offset(4)
        }
        
        friendListLabel.snp.makeConstraints { make in
            make.leading.equalTo(friendImage.snp.trailing).offset(20)
            make.centerY.equalTo(friendImage.snp.centerY)
        }
        
        friendChevron.snp.makeConstraints { make in
            make.centerY.equalTo(friendImage.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
//        friendBar.snp.makeConstraints { make in
//            make.height.equalTo(1)
//            make.leading.equalTo(friendImage.snp.leading)
//            make.trailing.equalTo(friendChevron.snp.trailing)
//            make.centerY.equalToSuperview()
//            make.centerX.equalToSuperview()
//        }
        
//        exclItemListView.snp.makeConstraints { make in
//            make.width.equalTo(300)
//            make.height.equalTo(52)
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-10)
//        }
//
//        exclItemImage.snp.makeConstraints { make in
//            make.centerX.equalTo(friendImage)
//            make.bottom.equalToSuperview().offset(-4)
//        }
//
//        exclItemLabel.snp.makeConstraints { make in
//            make.leading.equalTo(friendListLabel.snp.leading)
//            make.centerY.equalTo(exclItemImage.snp.centerY)
//        }
//
//        exclItemChevron.snp.makeConstraints { make in
//            make.centerY.equalTo(exclItemImage.snp.centerY)
//            make.trailing.equalToSuperview()
//        }
        
        privacyBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-54)
            make.centerX.equalToSuperview()
        }
        
        
        mainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        
        subLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
        }
        
        emptyAccountEditView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(18)
            make.trailing.equalToSuperview().offset(-16)
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
            make.trailing.equalToSuperview()
        }
        
        notUsedPay.snp.makeConstraints { make in
            make.leading.equalTo(accountView).offset(16)
            make.top.equalTo(socialPayLabel.snp.bottom).offset(4)
        }
        
    }
    
    func addTapGesture(to view: UIView) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
    


}

