//
//  ExclItemInputEmptyView.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/31.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class ExclItemInputEmptyView: UIView {
    
    let view = UIView()
    let notice = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        view.do {
            $0.layer.cornerRadius = 4
            $0.layer.borderColor = UIColor.BorderDeactivate.cgColor
            $0.layer.borderWidth = 1
        }
        
        notice.do {
            $0.text = "우측 상단의 '항목 추가' 버튼을 탭하여\n따로 정산하실 항목을 추가하세요"
            $0.textAlignment = .center
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
            $0.numberOfLines = 2
        }
    }
    
    func setLayout() {
        self.addSubview(view)
        view.addSubview(notice)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        notice.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
