//
//  MyInfoEmpryVC.swift
//  SplitIt
//
//  Created by cho on 2023/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RealmSwift


class MyInfoEmptyVC: UIViewController{
    
    
    var tmpView: UIView!
    let mainLabel = UILabel() //반갑습니다 정산자님
    let subLabel = UILabel() // 정산받을 곳을 ~ 시작해보세요!
    
    let emptyAccountEditView = UIView()
    let emptyAccountEditLabel = UILabel() //시작하기
    let emptyAccountEditChevron = UIImageView()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setAddView()
        setAttribute()
        setLayout()

        
    }
    
    func setAddView() {
        
        view.addSubview(tmpView)
        
        [mainLabel, subLabel, emptyAccountEditView].forEach{
            tmpView.addSubview($0)
        }
        [emptyAccountEditLabel, emptyAccountEditChevron].forEach {
            emptyAccountEditView.addSubview($0)
        }
    }
    
    
    func setAttribute() {
        
        view.backgroundColor = .white
        
        let attributedString = NSMutableAttributedString(string: "시작하기")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        
        
        tmpView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray.cgColor
        }
        
        mainLabel.do {
            $0.text = "반갑습니다 정산자님 🥳"
            $0.font = UIFont.systemFont(ofSize: 21)
        }
        
        subLabel.do {
            $0.text = "정산받을 곳을 입력하고 바로 정산을 시작해보세요!"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = UIColor.gray
        }
        emptyAccountEditView.do {
            $0.backgroundColor = .clear
        }
        
        emptyAccountEditLabel.do {
            $0.attributedText = attributedString
            $0.font = UIFont.systemFont(ofSize: 13)
        }
     
        
        emptyAccountEditChevron.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = UIColor.gray
        }
        
        
        
    }
    
    func setLayout() {
     
        tmpView.snp.makeConstraints { make in
            make.width.equalTo(330)
            make.height.equalTo(104)
            make.top.equalToSuperview().offset(108)
            make.centerX.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        
        subLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
        }
        
        emptyAccountEditView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(18)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        emptyAccountEditLabel.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        emptyAccountEditChevron.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(9)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
    }
}
