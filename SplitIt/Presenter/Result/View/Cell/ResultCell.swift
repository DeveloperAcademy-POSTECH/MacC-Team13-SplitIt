//
//  ResultCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/20.
//

import UIKit
import Then
import Reusable
import SnapKit
import RxCocoa
import RxSwift

class ResultCell: UICollectionViewCell, Reusable {

    var disposeBag = DisposeBag()
    
    var viewModel =  ResultCellVM()
    
    let name = UILabel()
    let payment = UILabel()
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
        collectionView.snp.removeConstraints()
        payment.snp.removeConstraints()
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        payment.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setAttribute() {
        self.backgroundColor = UIColor.clear

        contentView.do {
            contentView.backgroundColor = UIColor.clear
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(hex: 0xCCCCCC).cgColor
            $0.clipsToBounds = true
        }
        
        name.do {
//            $0.text = "이름"
            $0.textColor = UIColor(hex: 0x202020)
            $0.font = .systemFont(ofSize: 12, weight: .light)
        }
        
        payment.do {
//            $0.text = "금액"
            $0.textColor = UIColor(hex: 0x202020)
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        setCollectionView()
    }
    
    func setCollectionView() {
        collectionView.do {
            $0.collectionViewLayout = DisplayLayoutFactory.createResultCellLayout()
            $0.register(cellType: ResultExclItemCell.self)
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
        }    
    }
    
    func setLayout() {
        [name, payment, collectionView].forEach {
            contentView.addSubview($0)
        }
        
        name.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
//            $0.height.equalTo(0)
        }
        
        payment.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setBinding(item: [ExclItem]) {
        let input = ResultCellVM.Input(exclItems: Driver<[ExclItem]>.just(item))
        let output = viewModel.transform(input: input)
        
        output.exclItemNames
            .bind(to: collectionView.rx.items(cellIdentifier: ResultExclItemCell.reuseIdentifier)) { row, item, cell in
                if let cell = cell as? ResultExclItemCell {
                    cell.configure(item: item)
                }
            }
            .disposed(by: disposeBag)
    }

    func configure(item: Result) {
        name.text = item.name.joined(separator: ", ")
        payment.text = "각 \(item.payment) KRW"
        
//        print("명단: \(name.text)")
//        print("제외항목: \(item.exclItems)")
        setBinding(item: item.exclItems)
//        print("---------")
        
        updateCollectionViewHeight()
    }
    
    func updateCollectionViewHeight() {
        
        print(collectionView.collectionViewLayout.collectionViewContentSize)
//        collectionView.snp.updateConstraints {
//            $0.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize)
//        }
        
        collectionView.snp.makeConstraints {
            $0.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize)
        }
//        print("Height 설정")
//        collectionView.snp.removeConstraints()
//        collectionView.snp.makeConstraints {
//            $0.top.equalTo(name.snp.bottom).offset(4)
//            $0.leading.trailing.equalToSuperview().inset(12)
//            $0.bottom.equalTo(payment.snp.top).offset(-4)
//            $0.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize)
//        }
//        collectionView.reloadData()
    }
}

