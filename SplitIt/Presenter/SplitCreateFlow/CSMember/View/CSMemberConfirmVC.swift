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
import RxAppState

class CSMemberConfirmVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = CSMemberConfirmVM()
    
    let titleMessage = UILabel()
    let subTitleMessage = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    let bottomDescription = UILabel()
    let equalSplitButton = SPButton()
    let equalSplitImage = UIImageView(image: UIImage(named: "EqualSplitIconDefault"))
    let smartSplitButton = SPButton()
    let smartSplitImage = UIImageView(image: UIImage(named: "SmartSplitIconDefault"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }

    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)

        titleMessage.do {
            $0.text = "좋아요 :D"
            $0.font = .KoreanTitle3
            $0.textColor = .TextPrimary
        }
        
        subTitleMessage.do {
            $0.text = "입력한 내용이 정확한지 확인해주세요"
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        equalSplitButton.do {
            $0.applyStyle(.halfEqualSplit)
        }
        
        smartSplitButton.do {
            $0.applyStyle(.halfSmartSplit)
        }
        
        bottomDescription.do {
            $0.text = "위 내용으로 정산을 시작합니다"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
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
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .AppColorGrayscale25K
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
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
        [titleMessage, subTitleMessage, equalSplitButton, smartSplitButton, tableView, bottomDescription].forEach {
            view.addSubview($0)
        }
        
        equalSplitButton.addSubview(equalSplitImage)
        smartSplitButton.addSubview(smartSplitImage)
        
        titleMessage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        subTitleMessage.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(subTitleMessage.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(350)
        }

        bottomDescription.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        equalSplitButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(52)
            $0.leading.equalToSuperview().inset(30)
            $0.width.height.equalTo(150)
        }
        
        equalSplitImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().inset(14)
        }
        
        smartSplitButton.snp.makeConstraints {
            $0.centerY.equalTo(equalSplitButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(150)
        }
        
        smartSplitImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().inset(14)
        }
    }
    
    func setBinding() {
        let input = CSMemberConfirmVM.Input(viewWillAppear: self.rx.viewWillAppear.asDriver(onErrorJustReturn: false),
                                            smartSplitTap: smartSplitButton.rx.tap.asDriver(),
                                            equalSplitTap: equalSplitButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.memberList
            .bind(to: tableView.rx.items(cellIdentifier: "CSMemberConfirmCell")) {
                (row, item, cell) in
                if let memberCell = cell as? CSMemberConfirmCell {
                    memberCell.configure(item: item, row: row)
                    memberCell.selectionStyle = .none
                }
            }
            .disposed(by: disposeBag)
        
        output.showSmartSplitCycle
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.smartSplitButton.applyStyle(.halfSmartSplitPressed)
                let vc = ExclPageController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showSmartSplitCycle
            .delay(.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.smartSplitButton.applyStyle(.halfSmartSplit)
            })
            .disposed(by: disposeBag)
        
        output.showEqualSplitCycle
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.equalSplitButton.applyStyle(.halfEqualSplitPressed)
                
                print(">>> 1/n 정산버튼 탭")
            })
            .disposed(by: disposeBag)
        
        output.showEqualSplitCycle
            .delay(.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.equalSplitButton.applyStyle(.halfEqualSplit)
            })
            .disposed(by: disposeBag)
    }
    
}

extension CSMemberConfirmVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(CSMemberConfirmHeader.self) else { return UIView() }
        header.setHeader(viewModel: CSMemberConfirmHeaderVM())
        header.contentView.backgroundColor = UIColor(hex: 0xF8F7F4)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight = 90.0
        return headerHeight
    }
}
