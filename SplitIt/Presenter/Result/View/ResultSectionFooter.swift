//
//  ResultSectionFooter.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/24.
//

import UIKit
import SnapKit
import Then
import Reusable
import RxSwift
import RxCocoa

class ResultSectionFooter: UICollectionReusableView, Reusable {
    
    let button = UIButton()
    
    var disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        button.do {
            $0.setTitle("수정하기", for: .normal)
            $0.setTitleColor(UIColor(hex: 0x202020), for: .normal)
        }
    }
    
    func setLayout() {
        addSubview(button)
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
