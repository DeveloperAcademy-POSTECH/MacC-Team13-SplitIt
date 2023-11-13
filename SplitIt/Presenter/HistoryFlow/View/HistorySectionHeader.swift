//
 //  HistorySectionHeader.swift
 //  SplitIt
 //
 //  Created by Zerom on 2023/10/19.
 //
 import UIKit
 import SnapKit
 import Then
 import Reusable

 class HistorySectionHeader: UICollectionReusableView, Reusable {
     let headerTitle = UILabel()

     override init(frame: CGRect) {
         super.init(frame: frame)

         setAttribute()
         setLayout()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     private func setAttribute() {
         headerTitle.do {
             $0.textColor = .TextPrimary
             $0.font = .KoreanCaption2
         }
     }

     private func setLayout() {
         addSubview(headerTitle)

         headerTitle.snp.makeConstraints {
             $0.top.equalToSuperview()
             $0.leading.equalToSuperview().inset(8)
         }
     }

     func configure(item: String) {
         headerTitle.text = item
     }
 }
