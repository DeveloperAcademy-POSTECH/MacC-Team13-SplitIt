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

protocol MyInfoVCRouter {
    func backFromMyInfoVC()
    func moveToPrivacyVC()
    func moveTofriendListVC()
    func moveToHistoryListVC()
    func moveToMyBackAccountVC()
    func moveToMadeByWCCT()
}

// TODO: - 해당 VC에 View를 구성하는 코드가 너무 비대해요. 지금 SwiftUI의 레이아웃 개념이 너무 많이 사용되서 그런 것 같아요. 수정해서 코드를 줄여보면 좋을 것 같습니다.
class MyInfoVC: UIViewController {
    
    var router: MyInfoVCRouter?
    let disposeBag = DisposeBag()
    let viewModel: MyInfoVM
    let header: SPNaviBar
    
    let userDefault = UserDefaults.standard
    
    let backView = UIView() //emptyView와 accountView 생성되는 뷰
    var backViewHeight: CGFloat = 104
    var tossPos: CGFloat = 10
    var kakaoPos: CGFloat = 100
    var naverPos: CGFloat = 300
    
    //>>>backView위에 그려지는 뷰
    //>>>accountView 시작
    
    let myInfoLabel = UILabel() //나의 정보
    let historyLabel = UILabel() //기록
    
    let accountView = UIView() //userDefault에 정보있을 때 나타나는 뷰
    
    let accountEditLabel = UILabel() //수정하기
    let accountEditChevron = UIImageView()
    
    let nameInfoLabel = UILabel() //예금주 성함
    let accountInfoLabel = UILabel() //은행 및 계좌정보
    
    let userName = UILabel() // 사용자의 이름
    let accountBankLabel = UILabel() //userDefaults에서 받아온 은행 이름
    let accountLabel = UILabel() //userDefault에서 받아온 사용자 계좌
    
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
    
    let emptyAccountEditLabel = UILabel() //시작하기
    let emptyAccountEditChevron = UIImageView()
    
    //>>>emptyView 끝
    let notUsedPay = UILabel() //간편페이를 사용하지 않아요
    
    let listView = UIView()
    let listBar = UIView()
    
    let friendListView = UIView()
    let friendListLabel = UILabel()
    let friendImage = UIImageView()
    let friendChevron = UIImageView()
    
    let historyListView = UIView()
    let historyListLabel = UILabel()
    let historyImage = UIImageView()
    let historyChevron = UIImageView()
    
    let privacyBtn = UIButton()
    let madeByWCCTBtn = UIButton()
    
    init(viewModel: MyInfoVM,
         header: SPNaviBar
    ) {
        self.viewModel = viewModel
        self.header = header
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddView()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.set("Setting", forKey: "MyInfoFlow")
        
        userNewInfo()
    }

    func userNewInfo() {
        let tossValue = UserDefaults.standard.bool(forKey: "tossPay")
        let kakaoValue = UserDefaults.standard.bool(forKey: "kakaoPay")
        let naverValue = UserDefaults.standard.bool(forKey: "naverPay")        
        let viewValue = userDefault.object(forKey: "userBank") != nil

        let bank: Bool = userDefault.string(forKey: "userBank") == "선택 안함" ? false : true
        let checkPay = tossValue || kakaoValue || naverValue //하나라도 참이면 checkPay는 참
        let firstCheck: Bool = UserDefaults.standard.string(forKey: "userBank") == Optional("") //아예 처음이면 nil, 뭐라도 저장되면 nil이 아님
        
        self.accountBankLabel.text = userDefault.string(forKey: "userBank") != "선택 안함" ? userDefault.string(forKey: "userBank") : "계좌를 사용하지 않아요"
        self.accountLabel.text = userDefault.string(forKey: "userAccount")
        self.userName.text = userDefault.string(forKey: "userName")
        
        //모든 정보가 없을 때,
        if firstCheck || !viewValue {
            backViewHeight = 104
            accountView.isHidden = true
            emptyView.isHidden = false
            backView.snp.updateConstraints {
                $0.height.equalTo(backViewHeight)
            }
        } else if userDefault.string(forKey: "userBank") == "선택 안함" && !checkPay {
            backViewHeight = 140
            accountView.isHidden = false
            emptyView.isHidden = true
            nameInfoLabel.isHidden = true
            notUsedPay.isHidden = false
            tossPayBtn.isHidden = !tossValue
            kakaoPayBtn.isHidden = !kakaoValue
            naverPayBtn.isHidden = !naverValue
            
            backView.snp.updateConstraints {
                $0.height.equalTo(backViewHeight)
            }
            accountInfoLabel.snp.removeConstraints()
            accountInfoLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(20)
                $0.leading.equalTo(accountView.snp.leading).offset(16)
            }
            accountView.snp.updateConstraints {
                $0.height.equalTo(backViewHeight)
            }
        } else if !bank && checkPay {
            //페이만 참, 계좌는 선택안함
            accountView.isHidden = false
            emptyView.isHidden = true
            nameInfoLabel.isHidden = true
            userName.isHidden = true
            notUsedPay.isHidden = true
            tossPayBtn.isHidden = !tossValue
            kakaoPayBtn.isHidden = !kakaoValue
            naverPayBtn.isHidden = !naverValue
            backViewHeight = 171
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
            accountInfoLabel.snp.removeConstraints()
            accountInfoLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(20)
                $0.leading.equalTo(accountView.snp.leading).offset(16)
            }
            backView.snp.updateConstraints {
                $0.height.equalTo(backViewHeight)
            }
            accountView.snp.updateConstraints {
                $0.height.equalTo(backViewHeight)
            }
            tossPayBtn.snp.updateConstraints {
                $0.width.height.equalTo(50)
                $0.leading.equalTo(accountView.snp.leading).offset(tossPos)
                $0.top.equalTo(socialPayLabel.snp.bottom).offset(8)
            }
            kakaoPayBtn.snp.updateConstraints {
                $0.width.height.equalTo(50)
                $0.leading.equalTo(accountView.snp.leading).offset(kakaoPos)
                $0.top.equalTo(socialPayLabel.snp.bottom).offset(8)
            }
            naverPayBtn.snp.updateConstraints {
                $0.width.height.equalTo(50)
                $0.leading.equalTo(accountView.snp.leading).offset(naverPos)
                $0.top.equalTo(socialPayLabel.snp.bottom).offset(8)
            }
        } else if bank && !checkPay {
            //페이류 없고, 계좌만 있을 때
            accountView.isHidden = false
            emptyView.isHidden = true
            nameInfoLabel.isHidden = false
            userName.isHidden = false
            notUsedPay.isHidden = false
            tossPayBtn.isHidden = true
            kakaoPayBtn.isHidden = true
            naverPayBtn.isHidden = true
            backViewHeight = 182
        
            backView.snp.updateConstraints {
                $0.height.equalTo(backViewHeight)
            }
            accountView.snp.updateConstraints {
                $0.height.equalTo(backViewHeight)
            }
            accountInfoLabel.snp.removeConstraints()
            accountInfoLabel.snp.makeConstraints {
                $0.top.equalTo(userName.snp.bottom).offset(8)
                $0.leading.equalTo(accountView.snp.leading).offset(16)
            }
        } else {
            //모든 정보가 다 있을 때
            accountView.isHidden = false
            emptyView.isHidden = true
            nameInfoLabel.isHidden = false
            userName.isHidden = false
            notUsedPay.isHidden = true
            tossPayBtn.isHidden = !tossValue
            kakaoPayBtn.isHidden = !kakaoValue
            naverPayBtn.isHidden = !naverValue
            backViewHeight = 213
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
        
            accountInfoLabel.snp.removeConstraints()
            accountInfoLabel.snp.makeConstraints {
                $0.top.equalTo(userName.snp.bottom).offset(8)
                $0.leading.equalTo(accountView.snp.leading).offset(16)
            }
            backView.snp.updateConstraints {
                $0.height.equalTo(backViewHeight)
            }
            accountView.snp.updateConstraints {
                $0.height.equalTo(backViewHeight)
            }
            tossPayBtn.snp.updateConstraints {
                $0.width.height.equalTo(50)
                $0.leading.equalTo(accountView.snp.leading).offset(tossPos)
                $0.top.equalTo(socialPayLabel.snp.bottom).offset(8)
            }
            kakaoPayBtn.snp.updateConstraints {
                $0.width.height.equalTo(50)
                $0.leading.equalTo(accountView.snp.leading).offset(kakaoPos)
                $0.top.equalTo(socialPayLabel.snp.bottom).offset(8)
            }
            naverPayBtn.snp.updateConstraints {
                $0.width.height.equalTo(50)
                $0.leading.equalTo(accountView.snp.leading).offset(naverPos)
                $0.top.equalTo(socialPayLabel.snp.bottom).offset(8)
            }
        }
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func setBinding() {
        
        let friendListTap = addTapGesture(to: friendListView)
        let historyListTap = addTapGesture(to: historyListView)
        let editBtnTap = addTapGesture(to: accountView)
        let startBtnTap = addTapGesture(to: emptyView)
        
        let input = MyInfoVM.Input(privacyBtnTapped: privacyBtn.rx.tap.asDriver(),
                                   friendListViewTapped: friendListTap.rx.event.asObservable().map { _ in () },
                                   historyListViewTapped: historyListTap.rx.event.asObservable().map { _ in () },
                                   editAccountViewTapped: editBtnTap.rx.event.asObservable().map{ _ in () },
                                   emptyEditAccountViewTapped: startBtnTap.rx.event.asObservable().map{ _ in () },
                                   madeByWCCTBtnTapped: madeByWCCTBtn.rx.tap.asDriver(),
                                   backButtonTapped: header.leftButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.moveToPrivacyView
            .drive(onNext: { [weak self] _ in
                self?.router?.moveToPrivacyVC()
            })
            .disposed(by: disposeBag)
        
        output.moveTofriendListView
            .subscribe(onNext: { [weak self] _ in
                self?.router?.moveTofriendListVC()
            })
            .disposed(by: disposeBag)
        
        output.moveToHistoryListView
            .subscribe(onNext: { [weak self] _ in
                self?.router?.moveToHistoryListVC()
            })
            .disposed(by: disposeBag)
        
        // MARK: - input에서는 editAccountView랑 emptyEditAccountView가 다르기때문에 각자 input을 넣어준건 좋아요. 대신 viewModel에서는 2개를 합쳐서 하나의 output으로 만들어주는게 코드 중복이 없기때문에 더 좋을 것 같습니다.
        // TODO: output의 moveToEditAccountView + moveToInitAccountView => moveToMyBankAccountVC로 변경하기
        output.moveToEditAccountView
            .subscribe(onNext: { [weak self] _ in
                self?.router?.moveToMyBackAccountVC()
            })
            .disposed(by: disposeBag)
        
        output.moveToInitAccountView
            .subscribe(onNext: { [weak self] _ in
                self?.router?.moveToMyBackAccountVC()
            })
            .disposed(by: disposeBag)
        
        output.moveToMadeByWCCT
            .drive(onNext: { [weak self] _ in
                self?.router?.moveToMadeByWCCT()
            })
            .disposed(by: disposeBag)
        
        output.moveToBackView
            .drive(onNext: { [weak self] _ in
                self?.router?.backFromMyInfoVC()
            })
            .disposed(by: disposeBag)
    }
    
    func setAddView() {
        
        [header, backView, listView, privacyBtn, madeByWCCTBtn, myInfoLabel, historyLabel].forEach {
            view.addSubview($0)
        }
        
        [emptyView, accountView].forEach {
            backView.addSubview($0)
        }
        
        [friendListView, historyListView, listBar].forEach {
            listView.addSubview($0)
        }
        
        [userName, accountInfoLabel, accountBankLabel, accountLabel,socialPayLabel,nameInfoLabel,
         tossPayBtn, kakaoPayBtn, naverPayBtn, notUsedPay, accountEditLabel, accountEditChevron].forEach {
            accountView.addSubview($0)
        }
        
        [friendImage, friendChevron, friendListLabel].forEach {
            friendListView.addSubview($0)
        }
        
        [historyImage, historyListLabel, historyChevron].forEach {
            historyListView.addSubview($0)
        }
        
        [mainLabel, subLabel, emptyAccountEditLabel, emptyAccountEditChevron].forEach{
            emptyView.addSubview($0)
        }
    }
    
    func setLayout() {
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        backView.snp.makeConstraints {
            $0.height.equalTo(104)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(myInfoLabel.snp.bottom).offset(4)
        }
        
        //backView
        emptyView.snp.makeConstraints {
            $0.height.equalTo(104)
            $0.leading.trailing.equalTo(view).inset(30)
            $0.top.equalTo(myInfoLabel.snp.bottom).offset(4)
        }
        
        accountView.snp.makeConstraints {
            $0.height.equalTo(230)
            $0.leading.trailing.equalTo(view).inset(30)
            $0.top.equalTo(myInfoLabel.snp.bottom).offset(4)
        }
        
        myInfoLabel.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(38)
        }
        
        nameInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalTo(nameInfoLabel.snp.bottom).offset(6)
            $0.leading.equalTo(accountView).offset(16)
        }
        
        accountInfoLabel.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(8)
            $0.leading.equalTo(accountView.snp.leading).offset(16)
        }
        
        accountBankLabel.snp.makeConstraints {
            $0.top.equalTo(accountInfoLabel.snp.bottom).offset(6)
            $0.leading.equalTo(accountView.snp.leading).offset(16)
        }
        
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(accountInfoLabel.snp.bottom).offset(6)
            $0.leading.equalTo(accountBankLabel.snp.trailing).offset(4)
        }
        
        
        accountEditLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.trailing.equalTo(accountEditChevron.snp.leading).offset(-6)
        }
        
        accountEditChevron.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        socialPayLabel.snp.makeConstraints {
            $0.top.equalTo(accountBankLabel.snp.bottom).offset(20)
            $0.leading.equalTo(accountView.snp.leading).offset(16)
        }
        
        historyLabel.snp.makeConstraints {
            $0.top.equalTo(backView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(38)
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(historyLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(110)
        }
        
        listBar.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        friendListView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(listBar.snp.bottom)
        }
        
        friendImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        friendListLabel.snp.makeConstraints {
            $0.leading.equalTo(friendImage.snp.trailing).offset(20)
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        friendChevron.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
        }
        
        historyListView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
        }
        
        historyImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        historyListLabel.snp.makeConstraints {
            $0.leading.equalTo(friendImage.snp.trailing).offset(20)
            $0.top.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)

        }
        
        historyChevron.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
        }
        
        
        madeByWCCTBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.leading.equalToSuperview().offset(111)
        }
        
        privacyBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.leading.equalTo(madeByWCCTBtn.snp.trailing).offset(16)
        }
        
        //emptyView
        mainLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(20)
        }
        
        subLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(mainLabel.snp.bottom).offset(4)
        }
        
        emptyAccountEditLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.trailing.equalTo(emptyAccountEditChevron.snp.leading).offset(-4)
        }
        
        emptyAccountEditChevron.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        notUsedPay.snp.makeConstraints {
            $0.leading.equalTo(accountView).offset(16)
            $0.top.equalTo(socialPayLabel.snp.bottom).offset(8)
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
        
        myInfoLabel.do {
            $0.text = "계좌 설정"
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        userName.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
 
        accountView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .clear
        }
        
        nameInfoLabel.do {
            $0.text = "예금주 성함"
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        accountInfoLabel.do {
            $0.text = "은행 및 계좌번호"
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        accountBankLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        accountLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        accountEditLabel.do {
            $0.attributedText = attributedString
            $0.font = .KoreanCaption2
            $0.textColor = .TextPrimary
        }
        
        accountEditChevron.do {
            $0.image = UIImage(named: "ChevronRightIconDefault")
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

        tossPayBtn.do {
            $0.image = UIImage(named: "TossPayIconDefault")
        }
        
        kakaoPayBtn.do {
            $0.image = UIImage(named: "KakaoPayIconDefault")
        }
        
        
        naverPayBtn.do {
            $0.image = UIImage(named: "NaverPayIconDefault")
        }
        
        
        historyLabel.do {
            $0.text = "기록"
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        listView.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .clear
        }
        
        listBar.do {
            $0.backgroundColor = .BorderDeactivate
            $0.layer.borderColor = UIColor.BorderDeactivate.cgColor
            $0.layer.borderWidth = 1
        }
    
        historyImage.do {
            $0.image = UIImage(named: "SplitIconSmall")
        }
        
        historyChevron.do {
            $0.image = UIImage(named: "ChevronRightIconDefault")
        }
        
        historyListLabel.do {
            $0.text = "정산 기록"
            $0.font = UIFont.KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        friendImage.do {
            $0.image = UIImage(named: "MemberIcon")
        }
        
        friendChevron.do {
            $0.image = UIImage(named: "ChevronRightIconDefault")
        }
        
        friendListLabel.do {
            $0.text = "멤버 내역"
            $0.font = UIFont.KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        privacyBtn.do {
            $0.titleLabel?.font = UIFont.KoreanCaption2
            $0.titleLabel?.textColor = UIColor.TextSecondary
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 0
            $0.setAttributedTitle(privacyBtnString, for: .normal)
        }
        
        madeByWCCTBtn.do {
            $0.titleLabel?.font = UIFont.KoreanCaption2
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
        
        emptyAccountEditLabel.do {
            $0.attributedText = emptyString
            $0.font = UIFont.KoreanCaption2
            $0.textColor = .TextPrimary
        }
        
        
        emptyAccountEditChevron.do {
            $0.image = UIImage(named: "ChevronRightIconDefault")
            $0.tintColor = UIColor.BorderPrimary
        }
    }
    
    func addTapGesture(to view: UIView) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
}

