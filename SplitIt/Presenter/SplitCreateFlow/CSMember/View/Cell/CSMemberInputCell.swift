//
//  CSMemberInputCell.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/16.
//

import UIKit
import Then
import Reusable
import SnapKit
import RxSwift

class CSMemberInputCell: UICollectionViewCell, Reusable {

    var cellDisposeBag = DisposeBag()
    
    var viewModel: CSMemberInputVM?
    
    let memberName = UILabel()
    let deleteButton = UIButton()
    var indexPath = IndexPath()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        claerLayout()
        cellDisposeBag = DisposeBag()
    }
    
    func setAttribute() {
        self.backgroundColor = UIColor(hex: 0xE5E4E0)
        
        contentView.do {
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
        
        deleteButton.do {
            $0.setImage(UIImage(named: "XMark"), for: .normal)
        }
    }
    
    func setLayout() {
        contentView.addSubview(memberName)
        contentView.addSubview(deleteButton)
        
        memberName.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-8)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(18.5)
            $0.centerY.equalTo(memberName.snp.centerY)
        }
    }
    
    func setLayoutMe() {
        contentView.addSubview(memberName)
        
        memberName.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
    
    func claerLayout() {
        [memberName,deleteButton].forEach{$0.removeFromSuperview()}
        memberName.snp.removeConstraints()
        deleteButton.snp.removeConstraints()
    }

    func configure(item: String, indexPath: IndexPath, viewModel: CSMemberInputVM) {
        self.viewModel = viewModel
        self.indexPath = indexPath

        if indexPath.row == 0 {
            setLayoutMe()
            memberName.text = "\(item) (나)"
            contentView.backgroundColor = UIColor(hex: 0x343434)
            memberName.textColor = UIColor(hex: 0xF1F1F1)
        } else {
            setLayout()
            memberName.text = item
            contentView.backgroundColor = UIColor(hex: 0xF8F7F4)
            memberName.textColor = UIColor(hex: 0x202020)
            
            deleteButton.rx.tap
                .withLatestFrom(viewModel.memberList)
                .map { memberList -> [String] in
                    var updatedList = memberList
                    updatedList.remove(at: indexPath.row)
                    return updatedList
                }
                .asDriver(onErrorJustReturn: [])
                .drive(viewModel.memberList)
                .disposed(by: cellDisposeBag)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if deleteButton.isHidden {
            // deleteButton이 숨겨진 경우, 다른 내용에 따라 intrinsicContentSize를 계산
            let contentWidth = memberName.intrinsicContentSize.width
            let contentHeight = memberName.intrinsicContentSize.height
            return CGSize(width: contentWidth, height: contentHeight)
        } else {
            // deleteButton이 보이는 경우, 기본 크기를 반환
            return CGSize(width: super.intrinsicContentSize.width, height: super.intrinsicContentSize.height)
        }
    }
}