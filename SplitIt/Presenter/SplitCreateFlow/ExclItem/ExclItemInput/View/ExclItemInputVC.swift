//
//  ExclItemInputVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/29.
//

import UIKit
import RxSwift
import RxCocoa

class ExclItemInputVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = ExclItemInputVM()
    
    let header = NaviHeader()
    let exclListLabel = UILabel()
    let exclItemCountLabel = UILabel()
    let exclItemAddButton = NewSPButton()
    
    let contentView = UIView()
    let tableView = UITableView(frame: .zero)
    
    let nextButton = NewSPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(.csExcl)
            $0.setBackButtonToRootView(viewController: self)
        }
        
        exclListLabel.do {
            $0.text = "따로 정산 목록"
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        exclItemCountLabel.do {
            $0.text = "1"
            $0.font = .KoreanCaption1
            $0.textColor = .TextInvert
            $0.textAlignment = .center
            $0.backgroundColor = .AppColorBrandWatermelon
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        exclItemAddButton.do {
            $0.setTitle("추가하기", for: .normal)
            $0.buttonState.accept(true)
            $0.applyStyle(style: .primaryWatermelon, shape: .square)
        }
        
        nextButton.do {
            $0.setTitle("정산 결과 확인하기", for: .normal)
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
        }
        
        setTableView()
    }
    
    func setTableView() {
        let rowHeight = 114.0 + 8.0
        tableView.do {
            $0.register(cellType: ExclItemCell.self)
            $0.backgroundColor = .SurfacePrimary
            //$0.alwaysBounceVertical = false
//            $0.isScrollEnabled = false
//            $0.bounces = false
            $0.showsVerticalScrollIndicator = false
            $0.rowHeight = rowHeight
            $0.separatorStyle = .none
        }
    }
    
    func setLayout() {
        [header, exclListLabel, exclItemCountLabel, exclItemAddButton, tableView, nextButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        exclListLabel.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(27)
            $0.leading.equalToSuperview().inset(34)
        }
        
        exclItemCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(exclListLabel.snp.centerY)
            $0.leading.equalTo(exclListLabel.snp.trailing).offset(8)
            $0.width.height.equalTo(20)
        }
        
        exclItemAddButton.snp.makeConstraints {
            $0.centerY.equalTo(exclListLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(38)
            $0.width.equalTo(112)
            $0.height.equalTo(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(exclListLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = ExclItemInputVM.Input(nextButtonTapped: nextButton.rx.tap,
                                          exclItemAddButtonTapped: exclItemAddButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.exclItems
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: "ExclItemCell", cellType: ExclItemCell.self)) { (idx, item, cell) in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        output.nextButtonIsEnable
            .drive(nextButton.buttonState)
            .disposed(by: disposeBag)
        
        output.showExclItemInfoModal
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = ExclItemInfoModalVC()
                vc.modalPresentationStyle = .formSheet
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}