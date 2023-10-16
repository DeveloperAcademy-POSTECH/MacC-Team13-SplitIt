//
//  NavigationHeader.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/15.
//

import UIKit
import SnapKit
import Then

class NavigationHeader: UIView {
    private let backButton = UIButton()
    private let navigationTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            $0.tintColor = UIColor(hex: 0x292D32)
        }
        navigationTitle.do {
            $0.text = "Header Image"
        }
    }
    
    func setLayout() {
        
        self.addSubview(backButton)
        self.addSubview(navigationTitle)
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(21)
            $0.centerY.equalToSuperview()
        }
        
        navigationTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func configureTitle(title: String) {
        self.navigationTitle.text = title
    }
    
    func configureBackButton(viewController: UIViewController) {
        let backAction = UIAction { action in
            viewController.navigationController?.popViewController(animated: true)
        }
        backButton.addAction(backAction, for: .touchUpInside)
    }
}
