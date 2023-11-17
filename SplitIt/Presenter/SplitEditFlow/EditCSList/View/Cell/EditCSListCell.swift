//
//  EditCSListCell.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/30.
//

import Reusable
import UIKit
import SnapKit
import Then
import RxSwift

final class EditCSListCell: UITableViewCell, Reusable {
    
    var disposeBag = DisposeBag()
    
    let csTitleLabel = UILabel()
    let editBtnLabel = DefaultEditButton()
    let memberCountLabel = UILabel()
    let totalAmountLabel = UILabel()
    let exclItemCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
        backgroundColor = .SurfaceBrandCalmshell
        selectionStyle = .none
    }
    
    func setAttribute() {
        contentView.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.backgroundColor = .SurfaceBrandCalmshell
        }
        
        csTitleLabel.do {
            $0.font = .KoreanTitle3
            $0.textColor = .TextPrimary
        }
        
        editBtnLabel.do {
            $0.isEnabled = false
            $0.setTitleColor(.TextPrimary, for: .normal)
        }
        
        memberCountLabel.do {
            $0.textAlignment = .right
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption1
        }
        
        totalAmountLabel.do {
            $0.textAlignment = .right
            $0.textColor = .TextPrimary
        }
        
        exclItemCountLabel.do {
            $0.textAlignment = .right
            $0.textColor = .TextPrimary
            $0.font = .KoreanCaption1
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
        
        setLineDot(view: divView1)
        setLineDot(view: divView2)

        let mainStackView = UIStackView(arrangedSubviews: [titleStack, divView1, nameStackView, priceStackView, divView2, exclStackView]).then {
            $0.axis = .vertical
            $0.spacing = 16
        }
        
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
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
    
    
    func attributeStringSet(st1: String, st2: Int) -> NSMutableAttributedString {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.NumRoundedCaption1 as Any
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.NumRoundedBody as Any
        ]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedPrice = formatter.string(from: NSNumber(value: st2)) ?? "\(st2)"
        
        let numberString = NSAttributedString(string: st1, attributes: numberAttributes)
        let textString = NSAttributedString(string: " \(formattedPrice)", attributes: textAttributes)

        let finalString = NSMutableAttributedString()
        finalString.append(numberString)
        finalString.append(textString)
        
        return finalString
    }
    
    func configure(csinfo: CSInfo, csMemberCount: Int, exclItemCount: Int) {
        
        let price = attributeStringSet(st1: "₩", st2: csinfo.totalAmount)

        csTitleLabel.text = csinfo.title
        memberCountLabel.text = "\(csMemberCount) 명"
        totalAmountLabel.attributedText = price
        exclItemCountLabel.text = "\(exclItemCount) 건"
    }
}

