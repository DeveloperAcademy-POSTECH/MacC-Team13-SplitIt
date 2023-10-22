//
//  PayButton.swift
//  SplitIt
//
//  Created by cho on 2023/10/19.
//

import UIKit
import SnapKit


//간편페이류 버튼 - 토스뱅크, 카카오페이, 네이버페이
struct PayButton {
    
    var btnView = UIView()
    
    var label: UILabel
    var btnImage: UIImageView
    var activeCheck: UIImageView

    init(labelText: String, btn: UIImage, check: UIImage) {
        
        self.label = UILabel()
        self.label.text = labelText
        self.label.font = UIFont.systemFont(ofSize: 11)
        
        self.btnImage = UIImageView()
        self.btnImage.image = btn
        self.btnImage.tintColor = .black

        self.activeCheck = UIImageView()
        self.activeCheck.image = check
        self.activeCheck.tintColor = .red
        
    }

    mutating func setupConstraints(in view: UIView) {
        view.addSubview(btnView)
        view.addSubview(label)
        btnView.addSubview(btnImage)
        btnView.addSubview(activeCheck)
        
   
        btnView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(80)
            
        }
        
        label.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.width.equalTo(48)
            make.centerX.equalToSuperview()
            make.top.equalTo(btnImage.snp.bottom).offset(6)
        }

        btnImage.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }

        activeCheck.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(18)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-25)
        }
    }
}
