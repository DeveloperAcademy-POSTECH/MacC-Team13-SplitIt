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
    
    var nameLabel = UILabel()
    var deleteBtn = UIButton()
    
    let viewModel = MemberLogVM()
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
               
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addView()
        setAttribute()
        setLayout()
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
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-15)
        }
        
    }
    
    func setAttribute() {
        contentView.backgroundColor = .SurfaceBrandCalmshell
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .black
        
        deleteBtn.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        deleteBtn.tintColor = .gray
        deleteBtn.clipsToBounds = true
        deleteBtn.layer.cornerRadius = 12
        deleteBtn.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

