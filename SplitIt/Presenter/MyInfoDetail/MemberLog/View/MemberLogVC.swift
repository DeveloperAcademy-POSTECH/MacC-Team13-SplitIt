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
    
    let header = NavigationHeader()
    var searchImage = UIImageView()
    var tableView = UITableView()
    var searchBarTextField = UITextField()
    
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
        [header,tableView, searchBarTextField].forEach {
            view.addSubview($0)
        }
        searchBarTextField.addSubview(searchImage)
        
    }
    
    func setLayout() {
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        searchBarTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(108)
            make.centerX.equalToSuperview()
            make.width.equalTo(330)
            make.height.equalTo(30)
            
        }
        
        tableView.snp.makeConstraints { make in
            make.height.equalTo(500)
            make.width.equalTo(350)
            make.top.equalTo(searchBarTextField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        searchImage.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(22)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func setAttribute() {
        
        view.backgroundColor = .white
        
        header.do {
            $0.configureBackButton(viewController: self)
        }
        
        searchBarTextField.do {
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1
            $0.placeholder = "친구이름을 입력하세요"
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: $0.frame.height))
            $0.leftViewMode = .always
            
        }
        
        searchImage.do {
            $0.image = UIImage(systemName: "magnifyingglass")
        }
        
        
    }
    
    func setBinding() {
        
        searchBarTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { [weak self] text in
                guard let self = self else { return }
                
                if text == "" {
                    viewModel.filteredMemberList = repo.memberLogArr
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
                        self.showDeteleActionSheet(memIdx: member.memberLogIdx)
                        print(member.memberLogIdx)
                        //tableView.reloadData()
                    })
                    .disposed(by: cell.disposeBag)
                    
            }
            .disposed(by: disposeBag)
        


    }
    
    func showDeteleActionSheet(memIdx: String) {
        
        let actionSheet = UIAlertController(title: nil, message: "친구를 삭제하시겠습니까?", preferredStyle: .alert)
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            repo.deleteMemberLog(memberLogIdx: memIdx)
            self.viewModel.filteredMemberList.accept(self.repo.memberLogArr.value.sorted { $0.name < $1.name })
        }))
        present(actionSheet, animated: true)
    }
   
}


extension MemberLogVC: UITableViewDelegate {
    
}

