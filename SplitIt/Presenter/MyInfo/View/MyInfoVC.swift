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
    
    let header = SPNavigationBar()

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
    
    let myInfoLabel = UILabel()
    
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
    
    let tossPayBtn = UIImageView()
    let kakaoPayBtn = UIImageView()
    let naverPayBtn = UIImageView()
    
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
    let notUsedAccount = UILabel() //계좌 정보가 없어요
    
   // let splitLabel = UILabel()
    
    let friendView = UIView()
    
    let friendListView = UIView()
    let friendListLabel = UILabel()
    let friendImage = UIImageView()
    let friendChevron = UIImageView()
    
    let privacyBtn = UIButton()
    let madeByWCCTBtn = UIButton()
    
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
    }

    
    func userNewInfo() {
            
            let tossValue = userDefault.bool(forKey: "tossPay")
            let kakaoValue = userDefault.bool(forKey: "kakaoPay")
            let naverValue = userDefault.bool(forKey: "naverPay")
            
            if let tmpuserName = UserDefaults.standard.string(forKey: "userNickName"), !tmpuserName.isEmpty { //userDefaults NickName에 값이 있을 떄
                accountView.isHidden = false
                emptyView.isHidden = true
                backViewHeight = 235
                
                backView.snp.updateConstraints { make in
                    make.height.equalTo(backViewHeight)
                }

            } else { //emptyView일 때
                
                accountView.isHidden = true
                emptyView.isHidden = false
                
                backViewHeight = 104
                
                backView.snp.removeConstraints()
                
                // backView 제약 조건 재설정
                backView.snp.makeConstraints { make in
                    make.height.equalTo(backViewHeight)
                    make.width.equalTo(330)
                    make.top.equalTo(view).offset(138)
                    make.centerX.equalTo(view)
                }
            
            }
            
            
            self.userName.text = userDefault.string(forKey: "userNickName")
            self.accountBankLabel.text = userDefault.string(forKey: "userBank")
            self.accountLabel.text = userDefault.string(forKey: "userAccount")
            self.accountNameLabel.text = userDefault.string(forKey: "userName")
            
            
            if let tmpuserName = UserDefaults.standard.string(forKey: "userName"), !tmpuserName.isEmpty { //accountView가 있을 때
                if let tmpAccount = userDefault.string(forKey: "userAccount"), tmpAccount.isEmpty { //userAccount가 비었을 때.
                    
                    notUsedAccount.isHidden = false
                    notUsedPay.isHidden = false
                    tossPayBtn.isHidden = true
                    kakaoPayBtn.isHidden = true
                    naverPayBtn.isHidden = true
                    backViewHeight = 175
                    
                    backView.snp.removeConstraints()
                    accountView.snp.removeConstraints()
                    
                    backView.snp.makeConstraints { make in
                        make.height.equalTo(backViewHeight)
                        make.width.equalTo(330)
                        make.top.equalTo(view).offset(138)
                        make.centerX.equalTo(view)
                        
                    }
                  
                    
                    accountView.snp.makeConstraints { make in
                        make.height.equalTo(backViewHeight)
                        make.width.equalTo(330)
                        make.center.equalTo(backView)
                    }
                    
                } else { //userAccount가 있을 때
                    if !tossValue && !kakaoValue && !naverValue  {
                        //간편페이류 없을 떄
                        notUsedAccount.isHidden = true
                        notUsedPay.isHidden = false
                        tossPayBtn.isHidden = true
                        kakaoPayBtn.isHidden = true
                        naverPayBtn.isHidden = true
                        
                        backViewHeight = 175
                        
                        backView.snp.removeConstraints()
                        accountView.snp.removeConstraints()
                        
                        backView.snp.makeConstraints { make in
                            make.height.equalTo(backViewHeight)
                            make.width.equalTo(330)
                            make.top.equalTo(view).offset(138)
                            make.centerX.equalTo(view)
                            
                        }
                        
                        accountView.snp.makeConstraints { make in
                            make.height.equalTo(backViewHeight)
                            make.width.equalTo(330)
                            make.center.equalTo(backView)
                        }
                        
                        
                    } else {
                        //간편페이류 있음
                        backViewHeight = 210
                        notUsedAccount.isHidden = true
                        notUsedPay.isHidden = true
                        tossPayBtn.isHidden = !tossValue
                        kakaoPayBtn.isHidden = !kakaoValue
                        naverPayBtn.isHidden = !naverValue
                        
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
                        tossPayBtn.snp.removeConstraints()
                        kakaoPayBtn.snp.removeConstraints()
                        naverPayBtn.snp.removeConstraints()
                        
                        
                        backView.snp.makeConstraints { make in
                            make.height.equalTo(backViewHeight)
                            make.width.equalTo(330)
                            make.top.equalTo(view).offset(138)
                            make.centerX.equalTo(view)
                            
                        }
                        
                        accountView.snp.makeConstraints { make in
                            make.height.equalTo(backViewHeight)
                            make.width.equalTo(330)
                            make.center.equalTo(backView)
                        }
                        
                        tossPayBtn.snp.makeConstraints { make in
                            make.width.height.equalTo(50)
                            make.leading.equalTo(accountView.snp.leading).offset(tossPos)
                            make.top.equalTo(socialPayLabel.snp.bottom).offset(8)
                        }
                        
                        kakaoPayBtn.snp.makeConstraints { make in
                            make.width.height.equalTo(50)
                            make.leading.equalTo(accountView.snp.leading).offset(kakaoPos)
                            make.top.equalTo(socialPayLabel.snp.bottom).offset(8)
                        }
                        
                        naverPayBtn.snp.makeConstraints { make in
                            make.width.height.equalTo(50)
                            make.leading.equalTo(accountView.snp.leading).offset(naverPos)
                            make.top.equalTo(socialPayLabel.snp.bottom).offset(8)
                        }
                        
                    }
                    
                    
                    self.view.layoutIfNeeded()
                }
                
            }
            
        }

 
    
    func setBinding() {
        
        let friendListTap = addTapGesture(to: friendListView)
        let editBtnTap = addTapGesture(to: accountEditView)
        let startBtnTap = addTapGesture(to: emptyAccountEditView)
        
        let input = MyInfoVM.Input(privacyBtnTapped: privacyBtn.rx.tap.asDriver(),
                                   friendListViewTapped: friendListTap.rx.event.asObservable().map { _ in () },
                                   editAccountViewTapped: editBtnTap.rx.event.asObservable().map{ _ in () },
                                   emptyEditAccountViewTapped: startBtnTap.rx.event.asObservable().map{ _ in () },
                                   madeByWCCTBtnTapped: madeByWCCTBtn.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        
        output.moveToPrivacyView
            .drive(onNext:{
//                print("개인정보 처리방침 이동dd")
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
        
        output.moveToMadeByWCCT
            .drive(onNext:{
                let url = NSURL(string: "https://github.com/DeveloperAcademy-POSTECH/MacC-Team13-SplitIt")
                let WCCTWebView: SFSafariViewController = SFSafariViewController(url: url! as URL)
                self.present(WCCTWebView, animated: true, completion: nil)
                
            })
            .disposed(by: disposeBag)
       
    }
    
    func setAddView() {
        
        [header, backView, friendView, privacyBtn, madeByWCCTBtn, myInfoLabel].forEach {
            view.addSubview($0)
        }
        
        backView.addSubview(emptyView)
        backView.addSubview(accountView)
        
        [userNameLabel, userName, userBar, accountInfoLabel, accountBankLabel, accountLabel,accountNameLabel, socialPayLabel,
         tossPayBtn, kakaoPayBtn, naverPayBtn, notUsedPay, notUsedAccount, accountEditView].forEach {
            accountView.addSubview($0)
        }
        
        
        [accountEditLabel, accountEditChevron].forEach {
            accountEditView.addSubview($0)
        }
        
        
        friendView.addSubview(friendListView)

        [friendImage, friendChevron, friendListLabel].forEach {
            friendListView.addSubview($0)
        }
        
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
        
        
        let madeByWCCT = NSAttributedString(string: "만든 사람들", attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        
        
        let emptyString = NSMutableAttributedString(string: "시작하기")
        emptyString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: emptyString.length))
        
        //밑줄 만들어주기 위한 attribute
        let attributedString = NSMutableAttributedString(string: "수정하기")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        
        
        header.do {
            $0.applyStyle(style: .setting, vc: self)
        }
        
        
        myInfoLabel.do {
            $0.text = "나의 정보"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        userName.do {
            $0.font = .KoreanTitle3
            $0.textColor = .TextPrimary
        }
        
        userNameLabel.do {
            $0.text = "님"
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
    
        userBar.do {
            $0.layer.borderColor = UIColor.BorderDeactivate.cgColor
            $0.layer.borderWidth = 1
        }
        
        accountView.do {
            $0.layer.cornerRadius = 16
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .clear
        }
        
        accountInfoLabel.do {
            $0.text = "정산 받을 계좌"
            $0.font = .KoreanCaption2
            $0.textColor = .TextPrimary
            
        }
        
        accountBankLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        accountLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        accountNameLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        accountEditView.do {
            $0.backgroundColor = .clear
        }
        
        accountEditLabel.do {
            $0.attributedText = attributedString
            $0.font = .KoreanCaption2
            $0.textColor = .TextPrimary
        }
        
        accountEditChevron.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .SurfaceSecondary
        }
        
        socialPayLabel.do {
            $0.text = "사용하는 간편페이"
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
            
        }
        
        notUsedPay.do {
            $0.text = "간편페이를 사용하지 않아요"
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        notUsedAccount.do {
            $0.text = "계좌 정보가 없어요"
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        tossPayBtn.do {
            $0.image = UIImage(named: "TossPayIconDefault")
        }
        
        kakaoPayBtn.do {
            $0.image = UIImage(named: "KakaoPayIconDefault")
        }
        
        
        naverPayBtn.do {
            $0.image = UIImage(named: "NaverPayIconDefault")
        }
    
        
//        splitLabel.do {
//            $0.text = "정산 기록"
//            $0.font = .KoreanCaption1
//            $0.textColor = .TextSecondary
//        }
//
//
        friendView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .clear
        }
 
        
        friendListView.backgroundColor = .clear
        
        friendImage.do {
            $0.image = UIImage(named: "MemberIcon")
        }
        
        friendChevron.do {
            $0.image = UIImage(named: "ChevronRightIconDefault")
        }
        
        friendListLabel.do {
            $0.text = "멤버 추가 내역"
            $0.font = UIFont.KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        privacyBtn.do {
            $0.titleLabel?.font = UIFont.KoreanCaption1
            $0.titleLabel?.textColor = UIColor.TextSecondary
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 0
            $0.setAttributedTitle(privacyBtnString, for: .normal)
        }
        
        madeByWCCTBtn.do {
            $0.titleLabel?.font = UIFont.KoreanCaption1
            $0.titleLabel?.textColor = UIColor.TextSecondary
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 0
            $0.setAttributedTitle(madeByWCCT, for: .normal)
        }
        
        emptyView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
        }
        
        mainLabel.do {
            $0.text = "정산자님, 반갑습니다 🥳"
            $0.font = UIFont.KoreanSubtitle
            $0.textColor = .TextPrimary
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
            $0.textColor = .TextPrimary
        }
        
        
        emptyAccountEditChevron.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = UIColor.BorderPrimary
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
        
        
        myInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(111)
            make.leading.equalToSuperview().offset(38)
        }
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(accountView).offset(20)
            make.leading.equalTo(accountView).offset(16)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountView).offset(26)
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
            make.top.equalTo(userName.snp.bottom).offset(8)
            make.centerX.equalTo(accountView)
        }
        
        
        accountInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(userBar.snp.top).offset(16)
            make.leading.equalTo(accountView.snp.leading).offset(16)
        }
        
        
        accountBankLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(8)
            make.leading.equalTo(accountView.snp.leading).offset(16)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(8)
            make.leading.equalTo(accountBankLabel.snp.trailing).offset(4)
        }
        
        accountNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(8)
            make.leading.equalTo(accountLabel.snp.trailing).offset(4)
        }
        socialPayLabel.snp.makeConstraints { make in
            make.top.equalTo(accountBankLabel.snp.bottom).offset(16)
            make.leading.equalTo(accountView.snp.leading).offset(16)
        }
        
        friendView.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(330)
            make.top.equalTo(backView.snp.bottom).offset(16)
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
        
        privacyBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.trailing.equalToSuperview().offset(-92)
            
        }
        madeByWCCTBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(93)
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
            make.top.equalTo(socialPayLabel.snp.bottom).offset(8)
        }
        
        notUsedAccount.snp.makeConstraints { make in
            make.leading.equalTo(accountView).offset(16)
            make.top.equalTo(accountInfoLabel.snp.bottom).offset(8)
        }
        
    }
    
    func addTapGesture(to view: UIView) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
    


}

