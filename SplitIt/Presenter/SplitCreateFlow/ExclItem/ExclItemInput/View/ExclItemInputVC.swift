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
    
    let scrollView = UIScrollView(frame: .zero)
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
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            
        }
        
        header.do {
            $0.applyStyle(.csExcl)
            $0.setBackButtonToRootView(viewController: self)
        }
        
        nextButton.do {
            $0.setTitle("정산 결과 확인하기", for: .normal)
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
        }
    }
    
    func setLayout() {
        [header, exclListLabel, exclItemCountLabel, scrollView].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(contentView)
        
        [tableView, nextButton].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = ExclItemInputVM.Input(nextButtonTapped: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        
    }
}
