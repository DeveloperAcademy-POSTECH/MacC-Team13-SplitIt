//
//  CSEditListCell.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/18.

import UIKit
import SnapKit
import RxSwift

class CSEditListCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    lazy var csTitleLabel: UILabel = {
        let button = UILabel()
        button.textAlignment = .center
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        let titleLB = UILabel()
        titleLB.text = "이름"
        titleLB.font = .systemFont(ofSize: 12)
        let titleBtn = UIButton(type: .system)
        titleBtn.setTitle("수정하기", for: .normal)
        titleBtn.tintColor = .lightGray
        titleBtn.titleLabel?.font = .systemFont(ofSize: 12)
        
        let roundTitleStack = UIStackView(arrangedSubviews: [csTitleLabel, titleBtn])
        roundTitleStack.axis = .horizontal
        roundTitleStack.layer.cornerRadius = 8
        roundTitleStack.layer.borderWidth = 1
        roundTitleStack.distribution = .equalSpacing
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLB,roundTitleStack])
        titleStackView.axis = .vertical
        titleStackView.spacing = 4
        roundTitleStack.snp.makeConstraints { make in
            make.height.equalTo(43)
        }
        
        
        contentView.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

