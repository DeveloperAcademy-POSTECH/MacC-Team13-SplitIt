//
//  SplitShareTableCell.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit
import Reusable
import Then
import SnapKit

class SplitShareTableCell: UITableViewCell, Reusable {
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let krwLabel = UILabel()
    let stackView = UIStackView()
    let dashLineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        backgroundColor = .white
        selectionStyle = .none
        
        nameLabel.do {
            $0.font = .ReceiptBody
            $0.textColor = .TextPrimary
            $0.addCharacterSpacing()
        }
        
        krwLabel.do {
            $0.text = "₩"
            $0.font = .ReceiptCaption2
            $0.textColor = .TextPrimary
            $0.addCharacterSpacing()
        }
        
        priceLabel.do {
            $0.font = .ReceiptBody
            $0.textColor = .TextPrimary
            $0.addCharacterSpacing()
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.translatesAutoresizingMaskIntoConstraints = true
        }
        
        dashLineView.do {
            let lineDashPattern: [NSNumber]? = [6, 6]

            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = lineDashPattern
            shapeLayer.strokeColor = UIColor.BorderTertiary.cgColor

            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: UIScreen.main.bounds.width - 96, y: 0)])
            
            shapeLayer.path = path
            $0.layer.addSublayer(shapeLayer)
        }
    }
    
    private func setLayout() {
        
        [nameLabel,priceLabel,krwLabel,stackView,dashLineView].forEach {
            addSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(26)
        }
        
        krwLabel.snp.makeConstraints {
            $0.trailing.equalTo(priceLabel.snp.leading).offset(-2)
            $0.bottom.equalTo(priceLabel.snp.bottom).offset(-3)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-26)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel.snp.leading).offset(8)
            $0.trailing.equalToSuperview().offset(-18)
        }
        
        dashLineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.height.equalTo(1)
        }
    }
    
    func configure(item: SplitMemberResult, indexPath: Int) {
        nameLabel.text = item.memberName
        priceLabel.text = NumberFormatter.localizedString(from: item.memberPrice as NSNumber, number: .decimal)
        
        if item.exclDatas.count > 0 && stackView.arrangedSubviews.count == 0 {
            let exclTitle = UILabel()
            
            exclTitle.do {
                $0.text = "제외 항목"
                $0.font = .ReceiptCaption2
                $0.textColor = .TextPrimary
                $0.addCharacterSpacing()
            }
            
            self.stackView.addArrangedSubview(exclTitle)
            
            for str in item.exclDatas {
                let dataLabel = UILabel()
                
                dataLabel.do {
                    $0.text = "· \(str)"
                    $0.font = .ReceiptCaption2
                    $0.textColor = .TextSecondary
                    $0.numberOfLines = 0
                    $0.addCharacterSpacing()
                }
                
                self.stackView.addArrangedSubview(dataLabel)
            }
        }
    }
}
