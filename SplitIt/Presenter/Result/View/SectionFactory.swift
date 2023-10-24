//
//  SectionFactory.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/20.
//

import UIKit

enum DisplayLayoutFactory {
    // MARK: CSMemberInputView의 Layout
    static func createCSMemberInputLayout() -> UICollectionViewLayout {
        let estimatedHeight: CGFloat = 28
        let estimatedWidth: CGFloat = 120
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(estimatedWidth),
            heightDimension: .absolute(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(8), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    //MARK: - ResultView의 CompositionalLayout
    static func createResultLayout(tappedIndex: Int, lastSection: Int) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection

            switch sectionNumber {
            case tappedIndex: // TODO: (탭한 섹션)
                section = unfoldSection()
            case lastSection: // TODO: (0 대신 마지막 섹션) -> "스플릿항목 추가버튼"
                section = addSplitSection()
            default: // 접힌 섹션
                section = foldSection()
            }
            return section
        }
        // MARK: Layout Config 정의
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12
        layout.configuration = config
        
        return layout
    }
    
    static func addSplitSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(0.001)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(0.001)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
       
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(32)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading,
            absoluteOffset: CGPoint(x: 0, y: 0))
        
        header.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 45,
                                                        bottom: 0,
                                                        trailing: 45)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 0,
                                                        bottom: 18,
                                                        trailing: 0)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    static func foldSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(0.001)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(0.001)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
       
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(27)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading,
            absoluteOffset: CGPoint(x: 0, y: 0))
        section.boundarySupplementaryItems = [header]
        
        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: ResultSectionBackground.reuseIdentifier)
        section.decorationItems = [ sectionBackground ]
        
        return section
    }
    
    static func unfoldSection() -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 80
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                        leading: 18,
                                                        bottom: 16,
                                                        trailing: 18)
        
        // MARK: ExclItem 관련 Background, decoration View
        let headerHeight = 130.0
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(headerHeight)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading,
            absoluteOffset: CGPoint(x: 0, y: 0))
        header.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                       leading: -18,
                                                       bottom: 0,
                                                       trailing: -18)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(47)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        section.boundarySupplementaryItems = [header, footer]
        
        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: ResultSectionBackground.reuseIdentifier)
        section.decorationItems = [ sectionBackground ]
        
        return section
    }
    
    // MARK: CSMemberInputView의 Layout
    static func createResultCellLayout() -> UICollectionViewLayout {
        let estimatedHeight: CGFloat = 30.0
        let estimatedWidth: CGFloat = 100.0
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(estimatedWidth),
            heightDimension: .absolute(20.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(8), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
