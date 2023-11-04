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
            $0.font = .KoreanCaption2
            $0.textColor = .TextPrimary
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
        [splitImage,dateLabel,firstDashLine,stackView,secondDashLine].forEach {
            addSubview($0)
        }
        
        splitImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(splitImage.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        firstDashLine.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(firstDashLine.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        secondDashLine.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(item: [CSInfo], splitDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        self.dateLabel.text = "정산 날짜: \(dateFormatter.string(from: splitDate))"
        
        var count = 1
        
        for csInfo in item {
            let titleView = UIView()
            let csCount = UILabel()
            let csTitle = UILabel()
            let csPrice = UILabel()
            
            titleView.backgroundColor = .clear
            
            csCount.do {
                $0.text = "\(count)차"
                $0.font = .KoreanCaption1
                $0.textColor = .TextPrimary
            }
            
            csTitle.do {
                $0.text = csInfo.title
                $0.font = .KoreanCaption2
                $0.textColor = .TextPrimary
            }
            
            csPrice.do {
                $0.text = "₩ \(NumberFormatter.localizedString(from: csInfo.totalAmount as NSNumber, number: .decimal))"
                $0.font = .KoreanCaption2
                $0.textColor = .TextPrimary
            }
            
            [csCount,csTitle,csPrice].forEach {
                titleView.addSubview($0)
            }
            
            titleView.snp.makeConstraints {
                $0.verticalEdges.leading.equalTo(csCount)
                $0.trailing.equalTo(csPrice)
            }
            
            csCount.snp.makeConstraints {
                $0.bottom.leading.equalToSuperview()
            }
            
            csTitle.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.leading.equalTo(csCount.snp.trailing).offset(2)
            }
            
            csPrice.snp.makeConstraints {
                $0.bottom.trailing.equalToSuperview()
            }
            
            self.stackView.addArrangedSubview(titleView)
            
            count += 1
        }
    }
}
