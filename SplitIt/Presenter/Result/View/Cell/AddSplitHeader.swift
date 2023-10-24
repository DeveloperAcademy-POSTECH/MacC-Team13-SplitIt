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
    let viewModel = AddSplitHeaderVM()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setBinding))
        self.addGestureRecognizer(tapGesture)
        
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
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = UIColor.SurfaceSelected
        }
        
        addLabel.do {
            $0.text = "+ 스플릿 항목 추가하기"
            $0.font = .KoreanSmallButtonText
            $0.textColor = .TextPrimary
        }
    }

    func setLayout() {
        [addLabel].forEach { addSubview($0) }

        addLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc private func setBinding() {
        viewModel.addSplitTapped.onNext(())
    }
}
  







