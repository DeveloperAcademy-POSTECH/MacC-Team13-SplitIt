//
//  CSEditListVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/18.
//

import UIKit
import Reusable
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class CSEditListVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSEditListVM()
    
    let header = NavigationHeader()
    let tableView = UITableView(frame: .zero, style: .grouped)
    let headerLabel = UILabel()
    let csTitleLabel = UILabel()
    let totalAmountLabel = UILabel()
    let csMemberLabel = UILabel()
    let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.configureBackButton(viewController: self)
        }
        
        headerLabel.do { label in
            label.text = "각 항목을 탭하여 수정하세요."
            label.font = .systemFont(ofSize: 15)
        }
        
        csTitleLabel.do { label in
            label.text = "title임"
            label.font = .systemFont(ofSize: 15)
        }
//        dfdfdf
        
        totalAmountLabel.do { label in
            label.text = "totalAmount 임"
            label.font = .systemFont(ofSize: 15)
        }
        
        csMemberLabel.do { label in
            label.text = "csMember 임"
            label.font = .systemFont(ofSize: 15)
        }
        
    }
    
    func setLayout() {
        let titleStackView = setStackView(view: csTitleLabel, st: "이름")
        let totalAmountStack = setStackView(view: totalAmountLabel, st: "사용한 총액")
        let memberStack = setStackView(view: csMemberLabel, st: "함께한 사람들")
        
        [header, headerLabel, titleStackView, totalAmountStack, memberStack, tableView, saveButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).inset(-17)
            make.centerX.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        totalAmountStack.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        memberStack.snp.makeConstraints { make in
            make.top.equalTo(totalAmountStack.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(memberStack.snp.bottom).offset(16)
            make.leading.trailing.equalTo(memberStack)
//            make.height.equalTo(300)
        }
        
    }
    
    func setBinding() {
        viewModel.titleObservable
            .bind(to: csTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalObservable
            .bind(to: totalAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.membersObservable
            .bind(to: csMemberLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setStackView(view: UILabel, st: String) -> UIStackView {
        let titleLB = UILabel()
        let titleBtn = UIButton(type: .system)
        
        titleLB.do { label in
            titleLB.text = st
            titleLB.font = .systemFont(ofSize: 12)
        }
        
        titleBtn.do { button in
            button.setTitle("수정하기", for: .normal)
            button.tintColor = .lightGray
            button.titleLabel?.font = .systemFont(ofSize: 12)
        }
        
        let roundTitleStack = UIStackView(arrangedSubviews: [view, titleBtn])
        roundTitleStack.axis = .horizontal
        roundTitleStack.layer.cornerRadius = 8
        roundTitleStack.layer.borderWidth = 1
        roundTitleStack.layer.borderColor = UIColor(red: 0.486, green: 0.486, blue: 0.486, alpha: 1).cgColor
        roundTitleStack.distribution = .equalSpacing
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLB,roundTitleStack])
        titleStackView.axis = .vertical
        titleStackView.spacing = 4
        
        roundTitleStack.snp.makeConstraints { make in
            make.height.equalTo(43)
        }
        
        return titleStackView
    }

}
