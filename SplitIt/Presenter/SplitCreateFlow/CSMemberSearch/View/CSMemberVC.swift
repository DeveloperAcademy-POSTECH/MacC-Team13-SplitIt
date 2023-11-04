//
//  CSMemberVC.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/29.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Reusable

class CSMemberVC: UIViewController, Reusable {
    let disposeBag = DisposeBag()
    let viewModel = CSMemberVM()
    
    let header = SPNavigationBar()
    let titleLabel = UILabel()
    let searchBarButton = UIButton()
    let buttonTitleLabel = UILabel()
    let buttonImageView = UIImageView()
    let subTitleLabel = UILabel()
    let memberTableView = UITableView(frame: .zero)
    let nextButton = NewSPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        header.do {
            $0.applyStyle(style: .csMemberCreate, vc: self)
        }
        
        titleLabel.do {
            $0.text = "누구누구와 함께 했나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        searchBarButton.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .SurfaceBrandCalmshell
        }
        
        buttonTitleLabel.do {
            $0.text = "이름을 입력하세요"
            $0.font = .KoreanBody
            $0.textColor = .TextDeactivate
        }
        
        buttonImageView.do {
            $0.image = UIImage(systemName: "magnifyingglass")
            $0.tintColor = .TextPrimary
        }
        
        subTitleLabel.do {
            $0.text = "'정산자'님은 이미 추가해뒀어요!"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        memberTableView.do {
            let inset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
            
            $0.register(cellType: CSMemberCell.self)
            $0.separatorStyle = .none
            $0.backgroundColor = .SurfaceDeactivate
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            $0.rowHeight = 48
            $0.contentInset = inset
            $0.showsVerticalScrollIndicator = false
        }
        
        nextButton.do {
            $0.applyStyle(style: .primaryPear, shape: .rounded)
            self.nextButton.setTitle("2명부터 정산할 수 있어요", for: .normal)
        }
    }
    
    private func setLayout() {
        [header,titleLabel,searchBarButton,subTitleLabel,memberTableView,nextButton].forEach {
            view.addSubview($0)
        }
        
        [buttonTitleLabel,buttonImageView].forEach {
            searchBarButton.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(38)
        }
        
        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        
        buttonTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        buttonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(24)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(38)
        }
        
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(35)
            $0.bottom.equalTo(nextButton.snp.top).offset(-24)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-61)
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    
    private func setBinding() {
        let input = CSMemberVM.Input(searchButtonTapped: searchBarButton.rx.tap,
                                     nextButtonTapped: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.tableData
            .bind(to: memberTableView.rx.items(cellIdentifier: "CSMemberCell")) { _, item, cell in
                if let cell = cell as? CSMemberCell {
                    cell.configure(item: item)
                }
            }
            .disposed(by: disposeBag)
        
        output.tableData
            .asDriver()
            .drive(onNext: { [weak self] datas in
                guard let self = self else { return }
                let buttonState = datas.count >= 2
                self.nextButton.buttonState.accept(buttonState)
                
                buttonState
                ? self.nextButton.setTitle("\(datas.count)명이서 돈을 썼어요", for: .normal)
                : self.nextButton.setTitle("2명부터 정산할 수 있어요", for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.showSearchView
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let vc = CSMemberSearchVC()
                vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.showExclView
            .asDriver()
            .drive(onNext: {
                let vc = SplitRepository.share.isSmartSplit ? ExclItemInputVC() : SplitShareVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
