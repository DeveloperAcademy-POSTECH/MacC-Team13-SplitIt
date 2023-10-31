//
//  JSDetailCell.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/30.
//

import Reusable
import UIKit
import SnapKit
import Then
import RxSwift

final class JSDetailCell: UICollectionViewCell, Reusable {
    
    var disposeBag = DisposeBag()
    
    let csTitleLabel = UILabel()
    let editBtnLabel = DefaultEditButton()
    let memberCountLabel = UILabel()
    let totalAmountLabel = UILabel()
    let exclItemCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        contentView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.backgroundColor = .SurfaceBrandCalmshell
        }
        
        csTitleLabel.do {
            $0.text = "완마카세 장보기"
            $0.font = .KoreanTitle1
            $0.tintColor = .TextPrimary
        }
        
        editBtnLabel.do {
            $0.isEnabled = false
        }
        
        memberCountLabel.do {
//            $0.text = "6 명"
            $0.textAlignment = .right
        }
        
        totalAmountLabel.do {
            $0.textAlignment = .right
            $0.textColor = .TextPrimary
        }
        
        exclItemCountLabel.do {
            $0.textAlignment = .right
        }
        
    }
    
    func setLayout() {
        let nameLabel = UILabel().then {
            $0.text = "인원"
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption1
        }
        
        let priceLabel = UILabel().then {
            $0.text = "총액"
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption1
        }
        
        let exclLabel = UILabel().then {
            $0.text = "제외 항목"
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption1
        }
        
        let titleStack = UIStackView(arrangedSubviews: [csTitleLabel, editBtnLabel])
        titleStack.do {
            $0.axis = .horizontal
            $0.spacing = 35
//            $0.distribution = .equalSpacing
            $0.alignment = .trailing
        }
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, memberCountLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        let priceStackView = UIStackView(arrangedSubviews: [priceLabel, totalAmountLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        let exclStackView = UIStackView(arrangedSubviews: [exclLabel, exclItemCountLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        let divView1 = UIView().then {
            let lineDashPattern: [NSNumber]? = [6, 6]

            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = lineDashPattern
            shapeLayer.strokeColor = UIColor.BorderSecondary.cgColor

            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: UIScreen.main.bounds.width - 96, y: 0)])
            
            shapeLayer.path = path
            $0.layer.addSublayer(shapeLayer)
        }
        let divView2 = UIView().then {
            let lineDashPattern: [NSNumber]? = [6, 6]

            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = lineDashPattern
            shapeLayer.strokeColor = UIColor.BorderSecondary.cgColor

            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: UIScreen.main.bounds.width - 96, y: 0)])
            
            shapeLayer.path = path
            $0.layer.addSublayer(shapeLayer)
        }
        
        divView1.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        divView2.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        setLineDot(view: divView1) // 왜 점선 안그려짐 ㅡ
        setLineDot(view: divView2)

        let mainStackView = UIStackView(arrangedSubviews: [titleStack, divView1, nameStackView, priceStackView, divView2, exclStackView]).then {
            $0.axis = .vertical
            $0.spacing = 16
        }
        
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(16)
        }
        
    }
    
    func setLineDot(view: UIView){
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineDashPattern = [4, 4]
        borderLayer.frame = view.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: view.bounds).cgPath
        
        view.layer.addSublayer(borderLayer)
    }
    
    func attributeStringSet(st1: String, st2: String) -> NSMutableAttributedString {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanCaption1
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanCaption2
        ]
        let numberString = NSAttributedString(string: st1, attributes: numberAttributes)
        let textString = NSAttributedString(string: " \(st2)", attributes: textAttributes)

        let finalString = NSMutableAttributedString()
        finalString.append(numberString)
        finalString.append(textString)
        
        return finalString
    }
    
    func attributeStringSet2(st1: String, st2: String) -> NSMutableAttributedString {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanCaption2
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.KoreanCaption1
        ]
        let numberString = NSAttributedString(string: st1, attributes: numberAttributes)
        let textString = NSAttributedString(string: " \(st2)", attributes: textAttributes)

        let finalString = NSMutableAttributedString()
        finalString.append(numberString)
        finalString.append(textString)
        
        return finalString
    }
    
    func configure(csinfo: CSInfo, csMemberCount: Int, exclItemCount: Int) {
        csTitleLabel.text = csinfo.title
        let member = attributeStringSet(st1: "\(csMemberCount)", st2: "명")
        let price = attributeStringSet2(st1: "₩", st2: "\(csinfo.totalAmount)")
        let excl = attributeStringSet(st1: "\(exclItemCount)", st2: "건")
        totalAmountLabel.attributedText = price
        memberCountLabel.attributedText = member
        exclItemCountLabel.attributedText = excl
        
    }
 
    
}

