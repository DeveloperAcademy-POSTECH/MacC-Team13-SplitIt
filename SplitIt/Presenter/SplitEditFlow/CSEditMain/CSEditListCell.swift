//
//  CSEditListCell.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/18.

import UIKit
import SnapKit
import Reusable
import RxSwift

class CSEditListCell: UITableViewCell, Reusable {
    
    var disposeBag = DisposeBag()
    
    var csTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .TextPrimary
        return label
    }()
    
    var editBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("수정하기", for: .normal)
        btn.setTitleColor(.TextSecondary, for: .normal)
        btn.titleLabel?.font = .KoreanCaption2
        btn.isEnabled = false
        return btn
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor(hex: 0xF8F7F4)
        [csTitleLabel, editBtn].forEach {
            contentView.addSubview($0)
        }
        csTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        editBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


