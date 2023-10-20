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

class MemberLogVC: UIViewController {
    
    var label = UILabel()
    var tableView = UITableView()
    var searchBarTextField = UITextField()
    let header = NavigationHeader()
    //searchBar에 있는 돋보기 모양
    
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
        
        tableView.rx.itemSelected
            .bind { indexPath in
                print(indexPath)
            }
            .disposed(by: disposeBag)
    }
    
    
    func setAddView() {
        [header, label, tableView, searchBarTextField].forEach {
            view.addSubview($0)
        }
       
    }
    
    func setLayout() {
      
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.height.equalTo(500)
            make.width.equalTo(350)
            make.top.equalToSuperview().offset(180)
            make.centerX.equalToSuperview()
        }
        
        searchBarTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(50)
            
        }
    }
    
    
    func setAttribute() {
        
        self.navigationController?.navigationBar.topItem?.title = ""
        view.backgroundColor = .white
        
        
        header.do {
            $0.configureBackButton(viewController: self)
        }
        
        label.text = "친구 목록"
        label.font = UIFont.systemFont(ofSize: 20)
        
        searchBarTextField.clipsToBounds = true
        searchBarTextField.layer.borderColor = UIColor.black.cgColor
        searchBarTextField.layer.borderWidth = 1
        searchBarTextField.placeholder = "간단히 입력해주세요"
    }
    
    
    func setBinding() {
        
        searchBarTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { [weak self] text in
                guard let self = self else { return }
                
                if text == "" {
                    viewModel.filteredMemberList = viewModel.memberList
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
                    .subscribe(onNext: {
                       // self.showDeteleActionSheet(memIdx: member.memberLogIdx)
                        print(member.memberLogIdx)
                    })
                    .disposed(by: cell.disposeBag)
                
                //수정버튼을 눌렀을 때
                cell.editBtn.rx.tap
                    .observe(on: MainScheduler.asyncInstance)
                    .subscribe(onNext: {
                        //self.showEditActionSheet(name: member.name, memIndex: member.memberIdx)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    
    
    func showDeteleActionSheet(memIdx: Int32) {
        
        let actionSheet = UIAlertController(title: nil, message: "친구를 삭제하시겠습니까?", preferredStyle: .alert)
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            var currentMembers = viewModel.memberList.value
//            if let index = currentMembers.firstIndex(where: { $0.memberIdx == memberLogIdx }) {
//                print(index)
//                currentMembers.remove(at: index)
//                viewModel.memberList.accept(currentMembers)
//            }
        }))
        
        present(actionSheet, animated: true)
        
    }
    
    func showEditActionSheet(name: String, memIndex: Int32){
        
        let actionSheet = UIAlertController(title: nil, message: "친구 이름 수정", preferredStyle: .alert)
        
        actionSheet.addTextField(configurationHandler: { textField in
            textField.placeholder = name
        })
        
        actionSheet.addAction(UIAlertAction(title: "저장", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            var currentMembers = viewModel.memberList.value
//            if let index = currentMembers.firstIndex(where: { $0.memberIdx == memIndex }), let textField = actionSheet.textFields?.first {
//                currentMembers[index].name = textField.text!
//                viewModel.memberList.accept(currentMembers)
//                print(textField.text!)
//            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
}


extension MemberLogVC: UITableViewDelegate {
    
}

