//
//  CSMemberInputSearchFooter.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/16.
//

import UIKit
import SnapKit
import Then
import Reusable
import RxSwift

class CSMemberInputSearchFooter: UITableViewHeaderFooterView, Reusable {

    var footerDisposBag = DisposeBag()
    
    let addMemberButton = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.footerDisposBag = DisposeBag()
    }
    
    func setAttribute() {
        self.backgroundColor = UIColor(hex: 0xE5E4E0)
        
        addMemberButton.do {
            $0.layer.cornerRadius = 18
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.setTitleColor(UIColor(hex: 0xF1F1F1), for: .normal)
            $0.titleLabel?.textAlignment = .left
            $0.backgroundColor = UIColor(hex: 0x343434)
        }
    }
    
    func setLayout() {
        [addMemberButton].forEach { self.addSubview($0)
        }

        addMemberButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}


