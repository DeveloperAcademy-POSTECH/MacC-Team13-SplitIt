//
//  HistoryVC.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/18.
//
import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxAppState
import RxDataSources
import Reusable

class HistoryVC: UIViewController {
    
    var disposeBag = DisposeBag()
    let viewModel = HistoryVM()
    
    let header = SPNavigationBar()
    let emptyView = UIView()
    let emptyLabel = UILabel()
    
    let splitCollectionFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                 collectionViewLayout: splitCollectionFlowLayout)
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<CreateDateSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell 
        
        header.do {
            $0.applyStyle(style: .history, vc: self)
        }
        
        splitCollectionFlowLayout.do {
            $0.scrollDirection = .vertical
        }
        
        collectionView.do {
            $0.collectionViewLayout = setCollectionLayout()
            $0.register(cellType: HistorySplitCell.self)
            $0.register(HistorySectionHeader.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: "HistorySectionHeader")
            $0.backgroundColor = .SurfacePrimary
            $0.showsVerticalScrollIndicator = false
        }
        
        emptyView.do {
            $0.backgroundColor = .SurfacePrimary
        }
        
        emptyLabel.do {
            $0.text = "여기에 스플리릿 내역을\n차곡차곡 쌓아보아요!"
            $0.numberOfLines = 0
            $0.sizeToFit()
            $0.font = .KoreanBody
            $0.textColor = .TextSecondary
            
            let attrString = NSMutableAttributedString(string: $0.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            
            $0.attributedText = attrString
            $0.textAlignment = .center
        }
        
        configureCollectionViewDataSource()
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        view.addSubview(header)
        emptyView.addSubview(emptyLabel)
        
        header.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    private func setBinding() {
        let input = HistoryVM.Input(viewWillAppear: self.rx.viewWillAppear,
                                    viewWillDisappear: self.rx.viewWillDisappear)
        let output = viewModel.transform(input: input)
        
        output.sectionRelay
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.isNotEmpty
            .bind(to: emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { indexPath in
                let vc = SplitShareVC()
                self.navigationController?.pushViewController(vc, animated: true)
                let item = self.dataSource[indexPath]
                SplitRepository.share.fetchSplitArrFromDBWithSplitIdx(splitIdx: item.splitIdx)
            })
            .disposed(by: disposeBag)
    }
    
    private func setCollectionLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(79))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item])
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(25)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading,
            absoluteOffset: CGPoint(x: 0, y: 0))
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24
        layout.configuration = config
        return layout
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<CreateDateSection>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(for: indexPath) as HistorySplitCell
            let splitItem = item
            cell.configure(split: splitItem, index: indexPath.section)
            return cell
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header: HistorySectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                let sectionTitle = dataSource.sectionModels[indexPath.section].header
                header.configure(item: sectionTitle)
                
                return header
            default:
                fatalError()
            }
        })
    }
}
