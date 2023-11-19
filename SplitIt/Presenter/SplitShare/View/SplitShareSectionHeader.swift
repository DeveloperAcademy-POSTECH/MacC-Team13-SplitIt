//
//  SplitShareSectionHeader.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/23.
//

import UIKit
import Then
import SnapKit

class SplitShareSectionHeader: UIView {
    let splitImage = UIImageView()
    let dateLabel = UILabel()
    let firstDashLine = UIView()
    let label = UILabel()
    let stackView = UIStackView()
    let secondDashLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttribute()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        
        splitImage.do {
            $0.image = UIImage(named: "ShareViewSplitLogo")
            $0.sizeToFit()
        }
        
        dateLabel.do {
            $0.font = .ReceiptCaption2
            $0.textColor = .TextPrimary
            $0.addCharacterSpacing()
        }
        
        firstDashLine.do {
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
        
        label.do {
            $0.text = "함께한 곳"
            $0.font = .ReceiptCaption1
            $0.textColor = .TextPrimary
            $0.addCharacterSpacing()
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.backgroundColor = .clear
            $0.spacing = 4
        }
        
        secondDashLine.do {
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
    }
    
    private func setLayout() {
        [splitImage,dateLabel,firstDashLine,label,stackView,secondDashLine].forEach {
            addSubview($0)
        }
        
        splitImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(splitImage.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(26)
        }
        
        firstDashLine.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(firstDashLine.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(22)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        secondDashLine.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(item: [CSInfo], splitDate: Date) {
        let colorSet: [UIColor] = [.SurfaceBrandCherry, .SurfaceBrandPear, .SurfaceBrandRadish, .SurfaceBrandWatermelon]
        
        let dateFormatter = DateFormatterHelper()
        self.dateLabel.text = "발급일: \(dateFormatter.dateToResult(from: splitDate))"
        
        var count = 0
        
        for csInfo in item {
            
            let titleView = UIView()
            let dotView = UIView()
            let csTitle = UILabel()
            let krwLabel = UILabel()
            let csPrice = UILabel()
            
            titleView.backgroundColor = .clear
            
            dotView.do {
                $0.backgroundColor = colorSet[count % 4]
                $0.layer.borderColor = UIColor.BorderPrimary.cgColor
                $0.layer.borderWidth = 1
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 4
            }
            
            csTitle.do {
                $0.text = csInfo.title
                $0.font = .ReceiptCaption2
                $0.textColor = .TextPrimary
                $0.addCharacterSpacing()
            }
            
            krwLabel.do {
                $0.text = "₩"
                $0.font = .ReceiptFooter2
                $0.textColor = .TextPrimary
            }
            
            csPrice.do {
                $0.text = "\(NumberFormatter.localizedString(from: csInfo.totalAmount as NSNumber, number: .decimal))"
                $0.font = .ReceiptCaption2
                $0.textColor = .TextPrimary
                $0.addCharacterSpacing()
            }
            
            [dotView,csTitle,krwLabel,csPrice].forEach {
                titleView.addSubview($0)
            }
            
            titleView.snp.makeConstraints {
                $0.top.equalTo(csTitle).offset(-2)
                $0.bottom.equalTo(csTitle).offset(2)
                $0.leading.equalTo(dotView)
                $0.trailing.equalTo(csPrice).inset(-8)
            }
            
            dotView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(12)
                $0.size.equalTo(8)
            }
            
            csTitle.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(dotView.snp.trailing).offset(4)
            }
            
            krwLabel.snp.makeConstraints {
                $0.trailing.equalTo(csPrice.snp.leading).offset(-4)
                $0.bottom.equalToSuperview().offset(-2)
            }
            
            csPrice.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
            
            self.stackView.addArrangedSubview(titleView)
            
            count += 1
        }
    }
}
