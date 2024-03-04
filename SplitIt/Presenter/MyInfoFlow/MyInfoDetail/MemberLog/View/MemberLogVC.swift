//
//  MemberLogVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then

protocol MemberLogVCRouter {
    func moveToBackView()
}

class MemberLogVC: UIViewController, SPAlertDelegate, UIScrollViewDelegate {
    
    var router: MemberLogVCRouter?
    let disposeBag = DisposeBag()
    let viewModel: MemberLogVM
    let header: SPNaviBar
    
    let alert = SPAlertController()
    let tableView = UITableView()
    let emptyLabel = UILabel()
    let friendLabel = UILabel()
    let friendBar = UILabel()
    let friendCount = UILabel()
    let allDeleteBtn = UIButton()
    
    init(viewModel: MemberLogVM,
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
        setTableView()
        setBinding()
    }
    
    func setTableView() {
        tableView.register(MemberCell.self, forCellReuseIdentifier: "MemberCell")
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func setAddView() {
        [header,tableView, emptyLabel, friendLabel, friendCount, allDeleteBtn, friendBar].forEach {
            view.addSubview($0)
        }
    }
    
    func setAlert() {
        showAlert(view: alert,
                type: .warnNormal,
                title: "내역을 모두 지우시겠어요?",
                descriptions: "지금까지 추가하신 내역들이 사라져요",
                leftButtonTitle: "취 소",
                rightButtonTitle: "모두 지우기")
    }
  
    func setLayout() {
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        friendLabel.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(34)
        }
        
        friendBar.snp.makeConstraints {
            $0.leading.equalTo(friendLabel.snp.trailing).offset(4)
            $0.top.equalTo(header.snp.bottom).offset(24)
        }
        
        friendCount.snp.makeConstraints {
            $0.leading.equalTo(friendBar.snp.trailing).offset(8)
            $0.top.equalTo(header.snp.bottom).offset(26)
        }
        
        allDeleteBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(34)
            $0.top.equalTo(header.snp.bottom).offset(18)
        }
        
        tableView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(14)
            $0.top.equalTo(friendLabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func setAttribute() {
        tableView.backgroundColor = .SurfaceBrandCalmshell
        view.backgroundColor = .SurfaceBrandCalmshell
        
        friendLabel.do {
            $0.text = "함께한 멤버 "
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        friendBar.do {
            $0.text = "|"
            $0.font = .KoreanBody
            $0.textColor = .TextSecondary
        }
        
        friendCount.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        emptyLabel.do {
            $0.text = "아직 멤버 내역이 없어요"
            $0.font = .KoreanBody
            $0.textColor = .TextSecondary
            $0.isHidden = false
        }
        
        allDeleteBtn.do {
            let string = NSAttributedString(string: "모두 지우기", attributes: [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ])
            
            $0.titleLabel?.font = .KoreanCaption1
            $0.titleLabel?.textColor = .TextPrimary
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 0
            $0.setAttributedTitle(string, for: .normal)
            $0.setBackgroundColor(.AppColorGrayscale50K, for: .highlighted)
            $0.setBackgroundColor(.clear, for: .normal)
        }
    }
    
    func setBinding() {
        let removeLogIdx = BehaviorRelay<String>(value: "")
        
        let input = MemberLogVM.Input(removeLogIdx: removeLogIdx,
                                      backButtonTapped: header.leftButton.rx.tap,
                                      alertRightButtonTapped: alert.rightButtonTapSubject.asDriver(onErrorJustReturn: ()))
        let output = viewModel.transform(input: input)
        
        output.memberList
            .bind(to: tableView.rx.items(cellIdentifier: "MemberCell", cellType: MemberCell.self)) { (row, member, cell) in
                cell.nameLabel.text = " \(member.name)"
                
                cell.deleteBtn.rx.tap
                    .observe(on: MainScheduler.asyncInstance)
                    .subscribe(onNext: { _ in
                        removeLogIdx.accept(member.memberLogIdx)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.memberList
            .map { !$0.isEmpty }
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.memberList
            .map { "\($0.count)명" }
            .bind(to: friendCount.rx.text)
            .disposed(by: disposeBag)
        
        output.moveToBackView
            .drive(onNext: { [weak self] _ in
                self?.router?.moveToBackView()
            })
            .disposed(by: disposeBag)
        
        allDeleteBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.setAlert()
            })
            .disposed(by: disposeBag)
    }
}


extension MemberLogVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

