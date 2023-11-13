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

class MemberLogVC: UIViewController, UIScrollViewDelegate {
    let repo = SplitRepository.share
    
    let header = SPNavigationBar()
    var searchImage = UIImageView()
    var tableView = UITableView()
    var searchBarTextField = UITextField()
    let emptyLabel = UILabel()
    let deleteBtn = UIButton()
    
    var viewModel = MemberLogVM()
    var disposeBag = DisposeBag()
    
    
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
        [header,tableView, searchBarTextField, emptyLabel, deleteBtn].forEach {
            view.addSubview($0)
        }
        searchBarTextField.addSubview(searchImage)
        
    }
    
  
    func setLayout() {
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        searchBarTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(108)
            make.centerX.equalToSuperview()
            make.width.equalTo(330)
            make.height.equalTo(30)
            
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(searchBarTextField.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(30)
        }
        
        searchImage.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(22)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(77)
            $0.centerY.equalToSuperview()
        }
        
//        deleteBtn.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.bottom.equalToSuperview().inset(20)
//        }
        
    }
    
    func setAttribute() {
        tableView.backgroundColor = .SurfaceBrandCalmshell
        view.backgroundColor = .SurfaceBrandCalmshell
        
        header.do {
            $0.applyStyle(style: .memberSearchHistory, vc: self)
        }
        
        searchBarTextField.do {
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.cornerRadius = 16
            $0.layer.borderWidth = 1
            $0.placeholder = "친구 이름을 입력하세요"
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: $0.frame.height))
            $0.leftViewMode = .always
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        
        }

       
        searchImage.do {
            $0.image = UIImage(systemName: "magnifyingglass")
            $0.tintColor = UIColor.gray
        }
        
        emptyLabel.do {
            $0.text = "아직 친구 검색 내역이 없습니다"
            $0.font = .KoreanBody
            $0.textColor = .TextSecondary
            $0.isHidden = false
        }
        
//        let attributedString = NSMutableAttributedString(string: "전체 삭제하기")
//        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
//
//        deleteBtn.do {
//            $0.titleLabel?.font = UIFont.KoreanCaption1
//            $0.titleLabel?.textColor = .SurfaceWarnRed
//            $0.clipsToBounds = true
//            $0.backgroundColor = .clear
//            $0.layer.borderWidth = 0
//            $0.setAttributedTitle(attributedString, for: .normal)
//        }
        
    }
    
    func setBinding() {
        
        searchBarTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { [weak self] text in
                guard let self = self else { return }
                
                if text.isEmpty {
                    self.viewModel.filteredMemberList.accept(SplitRepository.share.memberLogArr.value.sorted { $0.name < $1.name })
                } else {
                    self.viewModel.filterMembers(with: text)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.filteredMemberList
            .bind(to: tableView.rx.items(cellIdentifier: "MemberCell", cellType: MemberCell.self)) { (row, member, cell) in
                cell.nameLabel.text = member.name
                //삭제버튼 눌렀을 때
                cell.deleteBtn.rx.tap
                    .observe(on: MainScheduler.asyncInstance)
                    .subscribe(onNext: { [self] in
                        repo.deleteMemberLog(memberLogIdx: member.memberLogIdx)
                        self.viewModel.filteredMemberList.accept(self.repo.memberLogArr.value.sorted { $0.name < $1.name })
                    })
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        viewModel.filteredMemberList
            .map { !$0.isEmpty }
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)

    }
}


extension MemberLogVC: UITableViewDelegate {
    
}

