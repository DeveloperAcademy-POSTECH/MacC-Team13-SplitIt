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
    var editBtn = UIButton()
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
        contentView.addSubview(editBtn)
        contentView.addSubview(deleteBtn)
        
    }

    
    func setLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
        }
        
        editBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-50)
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    func setAttribute() {

        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .black
        
        editBtn.setTitle("수정", for: .normal)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        editBtn.titleLabel?.textColor = .black
        editBtn.clipsToBounds = true
        editBtn.layer.cornerRadius = 12
        editBtn.backgroundColor = .blue
        
        
        deleteBtn.setTitle("삭제", for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        deleteBtn.titleLabel?.textColor = .black
        deleteBtn.clipsToBounds = true
        deleteBtn.layer.cornerRadius = 12
        deleteBtn.backgroundColor = .red
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

