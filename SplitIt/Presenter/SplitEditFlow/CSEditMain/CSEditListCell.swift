//
//  CSEditListCell.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/18.

import UIKit
import SnapKit
import Reusable
import RxSwift

final class CSEditListCell: UITableViewCell, Reusable {
    
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
        setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        contentView.backgroundColor = UIColor(hex: 0xF8F7F4)
    }
    
    func setupLayout(type: CSEditListCellType) {
        [csTitleLabel, editBtn].forEach {
            contentView.addSubview($0)
        }
        
        switch type {
        case .top:
            csTitleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.leading.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(8)
            }
            
            editBtn.snp.remakeConstraints {
                $0.trailing.equalToSuperview().inset(16)
                $0.centerY.equalTo(csTitleLabel)
            }
            
        case .bottom:
            csTitleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(8)
                $0.leading.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(12)
            }
            
            editBtn.snp.remakeConstraints {
                $0.trailing.equalToSuperview().inset(16)
                $0.centerY.equalTo(csTitleLabel)
            }
            
        case .default:
            csTitleLabel.snp.remakeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
            }
            
            editBtn.snp.remakeConstraints {
                $0.trailing.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    func configure(item: ExclItem, index: Int, items: [ExclItem]) {
        
        csTitleLabel.text = "\(item.name) 값"
        
        let firstIdx = 0
        let lastIdx = items.count - 1
        
        switch index {
        case firstIdx:
            setupLayout(type: .top)
        case lastIdx:
            setupLayout(type: .bottom)
        default:
            setupLayout(type: .default)
        }
    }
    
    enum CSEditListCellType {
        case top
        case bottom
        case `default`
    }
}


