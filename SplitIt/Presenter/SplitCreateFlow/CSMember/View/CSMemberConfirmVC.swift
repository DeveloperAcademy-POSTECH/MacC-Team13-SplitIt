//
//  CSMemberConfirmVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/17.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class CSMemberConfirmVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSMemberConfirmVM()
    
    let header = NavigationHeader()
    let titleMessage = UILabel()
    let subTitleMessage = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    let bottomDescription = UILabel()
    let equalSplitButton = UIButton()
    let equalSplitImage = UIImageView(image: UIImage(named: "XMark"))
    let equalSplitLabel = UILabel()
    let smartSplitButton = UIButton()
    let smartSplitImage = UIImageView(image: UIImage(named: "XMark"))
    let smartSplitLabel = UILabel()
    
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
        
        equalSplitButton.do {
            $0.layer.cornerRadius = 42
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
        }
        
        equalSplitLabel.do {
            $0.text = "1/n 정산하기"
            $0.textColor = UIColor(hex: 0x202020)
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }
        
        smartSplitButton.do {
            $0.layer.cornerRadius = 42
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
        }
        
        smartSplitLabel.do {
            $0.text = "쓴 만큼 정산하기"
            $0.textColor = UIColor(hex: 0x202020)
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }
        
        bottomDescription.do {
            $0.text = "위 내용으로 정산을 시작합니다"
            $0.font = .systemFont(ofSize: 15)
        }
        
        setTableView()
    }

    func setTableView() {
        let bottomInset: CGFloat = 16.0
        let interItemSpacing: CGFloat = 8.0
        let rowHeight: CGFloat = 32.0
        
        tableView.do {
            $0.register(cellType: CSMemberConfirmCell.self)
            $0.register(headerFooterViewType: CSMemberConfirmHeader.self)
            $0.clipsToBounds = true
            $0.alwaysBounceVertical = false
//            $0.backgroundColor = UIColor(hex: 0xE5E4E0)
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.rowHeight = rowHeight + interItemSpacing // 40
            $0.separatorStyle = .none
            $0.sectionHeaderTopPadding = 0.0
            $0.contentInset = UIEdgeInsets(top: 0.0,
                                           left: 0.0,
                                           bottom: bottomInset,
                                           right: 0.0)
            $0.rx.setDelegate(self)
                .disposed(by: disposeBag)
        }
    }
    
    func setLayout() {
        [header, titleMessage, subTitleMessage, equalSplitButton, smartSplitButton, tableView, bottomDescription].forEach {
            view.addSubview($0)
        }
        
        [equalSplitImage, equalSplitLabel].forEach {
            equalSplitButton.addSubview($0)
        }
        
        [smartSplitImage, smartSplitLabel].forEach {
            smartSplitButton.addSubview($0)
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
        
        equalSplitButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(51)
            $0.leading.equalToSuperview().inset(32)
            $0.width.height.equalTo(150)
        }
        
        equalSplitImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
            $0.top.equalToSuperview().inset(24)
        }
        
        equalSplitLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(25)
        }
        
        smartSplitButton.snp.makeConstraints {
            $0.centerY.equalTo(equalSplitButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(32)
            $0.width.height.equalTo(150)
        }
        
        smartSplitImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
            $0.top.equalToSuperview().inset(24)
        }
        
        smartSplitLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    func setBinding() {
        let input = CSMemberConfirmVM.Input(viewDidLoad: Driver.just(()),
                                                   nextButtonTapSend: smartSplitButton.rx.tap.asDriver())
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

extension CSMemberConfirmVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(CSMemberConfirmHeader.self) else { return UIView() }
        header.contentView.backgroundColor = UIColor(hex: 0xF8F7F4)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight = 90.0
        return headerHeight
    }
}
