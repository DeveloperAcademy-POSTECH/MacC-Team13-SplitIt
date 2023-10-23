//
//  ExclMemberSectionBackground.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/18.
//

import UIKit
import SnapKit
import Then
import Reusable

class ExclMemberSectionBackground: UICollectionReusableView, Reusable {
    let backgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        backgroundView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .SurfacePrimary
        }
    }
    
    func setLayout() {
        self.addSubview(backgroundView)

        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

