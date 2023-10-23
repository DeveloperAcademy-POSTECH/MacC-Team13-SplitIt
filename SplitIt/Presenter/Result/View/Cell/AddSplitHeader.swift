//
//  AddSplitHeader.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/20.
//

import UIKit
import SnapKit
import Then
import Reusable
import RxSwift
import RxCocoa

class AddSplitHeader: UICollectionReusableView, Reusable {
    
    var disposeBag = DisposeBag()
    
    let addLabel = UILabel()
    
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
    }
    
    func setAttribute() {
        self.backgroundColor = UIColor.clear
        
        self.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = UIColor(hex: 0xEEEDE8)
        }
        
        addLabel.do {
            $0.text = "+ 스플릿 항목 추가하기"
            $0.font = .systemFont(ofSize: 12, weight: .bold)
        }
    }

    func setLayout() {
        [addLabel].forEach { addSubview($0) }

        addLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
  







