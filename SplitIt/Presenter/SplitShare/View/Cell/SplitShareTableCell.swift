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
    let line = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAttribute()
        setLayout()
        setLine()
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
        backgroundColor = .SurfacePrimary
        
        nameLabel.do {
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        priceLabel.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        krwLabel.do {
            $0.text = "원"
            $0.font = .KoreanCaption2
            $0.textColor = .TextPrimary
        }
        
        stackView.do {
            $0.backgroundColor = .SurfacePrimary
            $0.axis = .vertical
            $0.spacing = 4
            $0.translatesAutoresizingMaskIntoConstraints = true
        }
    }
    
    private func setLayout() {
        
        [nameLabel,priceLabel,krwLabel,stackView].forEach {
            addSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(18)
        }
        
        krwLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalTo(priceLabel.snp.bottom)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.trailing.equalTo(krwLabel.snp.leading).offset(-4)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
    }
    
    func setExclDatas(item: [String]) {
        
        if item.count > 0 && stackView.arrangedSubviews.count == 0 {
            let exclTitle = UILabel()
            
            exclTitle.do {
                $0.text = "정산에서 제외"
                $0.font = .KoreanCaption2
                $0.textColor = .TextSecondary
            }
            
            self.stackView.addArrangedSubview(exclTitle)
            
            for str in item {
                let dataLabel = UILabel()
                
                dataLabel.do {
                    $0.text = str
                    $0.font = .KoreanCaption2
                    $0.textColor = .TextPrimary
                    $0.numberOfLines = 0
                }
                
                self.stackView.addArrangedSubview(dataLabel)
            }
        }
    }
    
    func setLine() {
        line.do {
            $0.backgroundColor = .BorderTertiary
        }
        
        addSubview(line)
        
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.height.equalTo(1)
        }
    }
}
