//
//  SPPopUp.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/13.
//

import UIKit
import SnapKit
import Then
import RxCocoa

extension SPPopUp {
    enum PopUpType {
        case goToMyInfo
    }
}

class SPPopUp: UIView {
    var title = UILabel()
    var image = UIImageView()
    var descript = UILabel()
    let bottomButton = SPButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyStyle(style: PopUpType, vc: UIViewController) {
        switch style {
        case .goToMyInfo:
            self.backgroundColor = .SurfaceBrandCalmshell
            
            title.text = "입금 정보가 있으면 더 편해요"
            image.image = UIImage(named: "GoToMyInfo")
            descript.text = "영수증과 함께 친구에게 전달돼요"
            
            bottomButton.do {
                $0.setTitle("입력하러 가기", for: .normal)
                $0.applyStyle(style: .primaryWatermelon, shape: .square)
                $0.buttonState.accept(true)
            }
        }
    }
    
    private func setAttribute() {
        self.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 3
        }
        
        title.do {
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        image.do {
            $0.contentMode = .scaleAspectFit
        }
        
        descript.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
    }
    
    private func setLayout() {
        [title,image,descript,bottomButton].forEach {
            addSubview($0)
        }
        
        title.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(32)
        }
        
        image.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(title.snp.bottom).offset(24)
            $0.height.equalTo(229)
            $0.width.equalTo(224)
        }
        
        descript.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(descript.snp.bottom).offset(32)
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-32)
        }
    }
}
