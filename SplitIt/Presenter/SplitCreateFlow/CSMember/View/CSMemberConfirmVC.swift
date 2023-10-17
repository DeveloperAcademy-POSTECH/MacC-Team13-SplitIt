//
//  CSMemberConfirmVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import UIKit
import RxSwift
import RxCocoa

class CSMemberConfirmVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSMemberConfirmVM()
    
    let header = NavigationHeader()
    let titleMessage = UILabel()
    let subTitleMessage = UILabel()
    let tableView = UITableView()
    let bottomDescription = UILabel()
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }

    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.configureBackButton(viewController: self)
        }

        titleMessage.do {
            $0.text = "좋아요 :D"
            $0.font = .systemFont(ofSize: 24)
        }
        
        subTitleMessage.do {
            $0.text = "입력한 내용이 정확한지 확인해주세요"
            $0.font = .systemFont(ofSize: 15)
        }
        
        nextButton.do {
            $0.setTitle("똑똑한 정산하기", for: .normal)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = UIColor(hex: 0x19191B)
        }
        
        bottomDescription.do {
            $0.text = "위 내용으로 정산을 시작합니다"
            $0.font = .systemFont(ofSize: 15)
        }
        
        setTableView()
    }
    

    
    func setTableView() {
        let topInset: CGFloat = 16.0
        let bottomInset: CGFloat = 16.0
        let interItemSpacing: CGFloat = 8.0
        let rowHeight: CGFloat = 32.0
        
        tableView.do {
            $0.register(cellType: CSMemberConfirmCell.self)
            $0.clipsToBounds = true
            $0.backgroundColor = UIColor(hex: 0xE5E4E0)
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.rowHeight = rowHeight + interItemSpacing // 40
            $0.separatorStyle = .none
            $0.contentInset = UIEdgeInsets(top: topInset-interItemSpacing,
                                           left: 0,
                                           bottom: bottomInset,
                                           right: 0)
        }
    }
    
    func setLayout() {
        [header, titleMessage, subTitleMessage, nextButton, tableView, bottomDescription].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        subTitleMessage.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(subTitleMessage.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(360)
        }

        bottomDescription.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(170)
        }

    }
    
    func setBinding() {
        let input = CSMemberConfirmVM.Input(viewDidLoad: Driver.just(()),
                                                   nextButtonTapSend: nextButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        viewModel.memberList
            .bind(to: tableView.rx.items(cellIdentifier: "CSMemberConfirmCell")) {
                (row, item, cell) in
                if let memberCell = cell as? CSMemberConfirmCell {
                    memberCell.configure(item: item, row: row)
                    memberCell.selectionStyle = .none
                }
            }
            .disposed(by: disposeBag)
        
        output.showExclCycle
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
//                let vc = ExclItemNameInputVC()
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
