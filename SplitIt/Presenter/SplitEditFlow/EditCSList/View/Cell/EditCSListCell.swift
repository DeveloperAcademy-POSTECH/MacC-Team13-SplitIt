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
    
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let exclLabel = UILabel()
    let csTitleLabel = UILabel()
    let editBtnLabel = DefaultEditButton()
    let memberCountLabel = UILabel()
    let totalAmountLabel = UILabel()
    let exclItemCountLabel = UILabel()
    let divView1 = UIView()
    let divView2 = UIView()
    lazy var titleStack = UIStackView(arrangedSubviews: [csTitleLabel, editBtnLabel])
    lazy var nameStackView = UIStackView(arrangedSubviews: [nameLabel, memberCountLabel])
    lazy var priceStackView = UIStackView(arrangedSubviews: [priceLabel, totalAmountLabel])
    lazy var exclStackView = UIStackView(arrangedSubviews: [exclLabel, exclItemCountLabel])
    lazy var mainStackView = UIStackView(arrangedSubviews: [titleStack, divView1, nameStackView,
                                                            priceStackView, divView2, exclStackView])
    
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
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            $0.backgroundColor = .SurfaceWhite
        }
        
        nameLabel.do {
            $0.text = "인원"
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption1
        }
        
        priceLabel.do {
            $0.text = "총액"
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption1
        }
        
        
        exclLabel.do {
            $0.text = "제외 항목"
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption1
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
        
        titleStack.do {
            $0.axis = .horizontal
            $0.spacing = 35
//            $0.distribution = .equalSpacing
            $0.alignment = .trailing
        }
        
        nameStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        priceStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        exclStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        divView1.do {
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
        
        divView2.do {
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
        
        mainStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
        
        setLineDot(view: divView1)
        setLineDot(view: divView2)
    }
    
    func setLayout() {
        
        divView1.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        divView2.snp.makeConstraints {
            $0.height.equalTo(1)
        }

        contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(csinfo: CSInfo, csMemberCount: Int, exclItemCount: Int) {
        
        let price = attributeStringPriceSet(st1: "₩", st2: csinfo.totalAmount)
        let member = attributeStringMemberAndExclCountSet(st1: csMemberCount, st2: "명")
        let excl = attributeStringMemberAndExclCountSet(st1: exclItemCount, st2: "건")

        csTitleLabel.text = csinfo.title
        memberCountLabel.attributedText = member
        totalAmountLabel.attributedText = price
        exclItemCountLabel.attributedText = excl
    }
}

extension EditCSListCell {
    // 점선 그리기
    func setLineDot(view: UIView){
        
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineDashPattern = [4, 4]
        borderLayer.frame = view.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: view.bounds).cgPath
        
        view.layer.addSublayer(borderLayer)
    }
    
    // attrubuteString 셋팅
    func attributeStringPriceSet(st1: String, st2: Int) -> NSMutableAttributedString {
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
    
    func attributeStringMemberAndExclCountSet(st1: Int, st2: String) -> NSMutableAttributedString {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.NumRoundedBody as Any
        ]

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.NumRoundedCaption1 as Any
        ]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let numberString = NSAttributedString(string: "\(st1) ", attributes: numberAttributes)
        let textString = NSAttributedString(string: st2, attributes: textAttributes)

        let finalString = NSMutableAttributedString()
        finalString.append(numberString)
        finalString.append(textString)
        
        return finalString
    }
}
