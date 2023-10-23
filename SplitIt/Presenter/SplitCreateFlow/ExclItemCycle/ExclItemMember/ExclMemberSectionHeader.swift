

//
//  ExclMemberSectionHeader.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/18.
//

import UIKit
import SnapKit
import Then
import Reusable
import RxSwift
import RxCocoa


protocol CustomAlertVCDelegate: AnyObject {
    func didDeleteItem(item: ExclMemberSection)
}

class ExclMemberSectionHeader: UICollectionReusableView, Reusable, CustomAlertVCDelegate {
        
    func didDeleteItem(item: ExclMemberSection) {
           SplitRepository.share.deleteExclItemAndRelatedData(exclItemIdx: item.exclItem.exclItemIdx)
           print("항목이 삭제되었습니다.")
       }
    
    func configure(item: ExclMemberSection, sectionIndex: Int) {
        let numberFormatter = NumberFormatterHelper()
        
        self.backgroundColor = backgroundColor(forSectionIndex: sectionIndex)
        
        let name = item.exclItem.name
        let price = numberFormatter.formattedString(from: item.exclItem.price)
        
        headerTitle.text = "[\(name) 값 / \(price) KRW]"

        deleteButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("헤더 눌림")
                self.presentCustomAlert(item: item, name: name)
            })
            .disposed(by: disposeBag)

    }
    

    var disposeBag = DisposeBag()
    
    let headerTitle = UILabel()
    let deleteButton = UIButton()
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    
    private func presentCustomAlert(item: ExclMemberSection, name: String) {
        print("헤더 눌림")
        let customAlertVC = CustomAlertVC()
        customAlertVC.modalPresentationStyle = .overFullScreen
        customAlertVC.delegate = self
        customAlertVC.item = item
        customAlertVC.itemName = name
        self.window?.rootViewController?.present(customAlertVC, animated: false)
    }
    
    func setAttribute() {
        self.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        headerTitle.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption2
        }
        
        deleteButton.do {
            $0.setImage(UIImage(named: "DeleteIconTypeC"), for: .normal)
        }
    }
    
    func setLayout() {
        [headerTitle, deleteButton].forEach { addSubview($0)}
        
        headerTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(headerTitle.snp.centerY)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.width.equalTo(15)
        }
    }

//    func deleteSectionRelatedExclItem(item: ExclMemberSection) {
//        SplitRepository.share.deleteExclItemAndRelatedData(exclItemIdx: item.exclItem.exclItemIdx)
//    }
        
    func backgroundColor(forSectionIndex sectionIndex: Int) -> UIColor {
        return sectionIndex % 2 == 1 ? .AppColorGrayscale200 : .AppColorGrayscale50
    }
    
    
    
}




