//
//  MemberCell.swift
//  SplitIt
//
//  Created by cho on 2023/10/20.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MemberCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    let nameLabel = UILabel()
    let deleteBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addView()
        setAttribute()
        setLayout()

        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func addView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(deleteBtn)
    }
    
    func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        deleteBtn.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().offset(-15)
        }
    }
    
    func setAttribute() {
        contentView.backgroundColor = .SurfaceBrandCalmshell
        
        nameLabel.do {
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
       
        deleteBtn.do {
            $0.isEnabled = true
            $0.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
            $0.tintColor = .AppColorGrayscale200
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .clear
        }
    }
}

