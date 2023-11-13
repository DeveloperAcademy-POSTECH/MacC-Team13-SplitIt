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
   // var searchImage = UIImageView()
    var tableView = UITableView()
   // var searchBarTextField = UITextField()
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
        [header,tableView, emptyLabel, deleteBtn].forEach {
            view.addSubview($0)
        }
        
    }
    
  
    func setLayout() {
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
       
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(header.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        
        
        emptyLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(77)
            $0.centerY.equalToSuperview()
        }
        

        
    }
    
    func setAttribute() {
        tableView.backgroundColor = .SurfaceBrandCalmshell
        view.backgroundColor = .SurfaceBrandCalmshell
        
        header.do {
            $0.applyStyle(style: .memberSearchHistory, vc: self)
        }
        
        
        emptyLabel.do {
            $0.text = "아직 친구 검색 내역이 없습니다"
            $0.font = .KoreanBody
            $0.textColor = .TextSecondary
            $0.isHidden = false
        }
        
    }
    
    func setBinding() {
    
        viewModel.memberList
            .bind(to: tableView.rx.items(cellIdentifier: "MemberCell", cellType: MemberCell.self)) { (row, member, cell) in
                cell.nameLabel.text = member.name
                //삭제버튼 눌렀을 때
                cell.deleteBtn.rx.tap
                    .observe(on: MainScheduler.asyncInstance)
                    .subscribe(onNext: { [self] in
                        repo.deleteMemberLog(memberLogIdx: member.memberLogIdx)
                        self.viewModel.memberList.accept(self.repo.memberLogArr.value.sorted { $0.name < $1.name })
                    })
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        viewModel.memberList
            .map { !$0.isEmpty }
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)

    }
}


extension MemberLogVC: UITableViewDelegate {
    
}

