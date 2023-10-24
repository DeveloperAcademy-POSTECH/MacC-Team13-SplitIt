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
    let paymentPrefix = UILabel()
    let paymentSuffix = UILabel()
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
        
        paymentPrefix.text = ""
        
        collectionView.snp.removeConstraints()
        payment.snp.removeConstraints()
        paymentPrefix.snp.removeConstraints()
        paymentSuffix.snp.removeConstraints()
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        paymentSuffix.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        payment.snp.makeConstraints {
            $0.trailing.equalTo(paymentSuffix.snp.leading).offset(-2)
            $0.centerY.equalTo(paymentSuffix)
        }
        
        paymentPrefix.snp.makeConstraints {
            $0.trailing.equalTo(payment.snp.leading).offset(-4)
            $0.centerY.equalTo(paymentSuffix)
        }
    }
    
    func setAttribute() {
        self.backgroundColor = UIColor.clear

        contentView.do {
            contentView.backgroundColor = UIColor.clear
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            $0.clipsToBounds = true
        }
        
        name.do {
            $0.textColor = UIColor.TextPrimary
            $0.font = .KoreanCaption2
        }
        
        payment.do {
            $0.textColor = UIColor.TextPrimary
            $0.font = .KoreanCaption1
        }
        
        paymentPrefix.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
        }
        
        paymentSuffix.do {
            $0.text = "KRW"
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
        }
        
        setCollectionView()
    }
    
    func setCollectionView() {
        collectionView.do {
            $0.collectionViewLayout = DisplayLayoutFactory.createResultCellLayout()
            $0.register(cellType: ResultExclItemCell.self)
            $0.backgroundColor = UIColor.SurfaceBrandCalmshell
        }    
    }
    
    func setLayout() {
        [name, payment, collectionView, paymentPrefix, paymentSuffix].forEach {
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
        
        paymentSuffix.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        payment.snp.makeConstraints {
            $0.trailing.equalTo(paymentSuffix.snp.leading).offset(-2)
            $0.centerY.equalTo(paymentSuffix)
        }
        
        paymentPrefix.snp.makeConstraints {
            $0.trailing.equalTo(payment.snp.leading).offset(-4)
            $0.centerY.equalTo(paymentSuffix)
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
        let numberFormatter = NumberFormatterHelper()
        name.text = item.name.joined(separator: ", ")
        if item.name.count > 1 {
            paymentPrefix.text = "각"
        }
        payment.text = numberFormatter.formattedString(from: item.payment)
        
        print("명단: \(name.text!)")
        print("제외항목: \(item.exclItems)")
        print("---------")
        setBinding(item: item.exclItems)
        
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

