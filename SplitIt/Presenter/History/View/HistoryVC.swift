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
import Reusable
import RxDataSources

class HistoryVC: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel = HistoryVM()
    
    let header = NaviHeader()
    let emptyView = UIView()
    let emptyLabel = UILabel()
    
    let splitCollectionFlowLayout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: splitCollectionFlowLayout)
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<CreateDateSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.applyStyle(.history)
            $0.setBackButton(viewController: self)
        }
        
        splitCollectionFlowLayout.do {
            $0.scrollDirection = .vertical
        }
        
        collectionView.do {
            $0.collectionViewLayout = setCollectionLayout()
            $0.register(cellType: HistorySplitCell.self)
            $0.register(HistorySectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HistorySectionHeader")
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
            $0.showsVerticalScrollIndicator = false
        }
        
        emptyView.do {
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
        }
        
        emptyLabel.do {
            $0.text = "여기에 스플리릿 내역을\n차곡차곡 쌓아보아요!"
            $0.numberOfLines = 0
            $0.sizeToFit()
            $0.font = .systemFont(ofSize: 18)
            $0.textAlignment = .center
            $0.textColor = .gray
        }
        
        configureCollectionViewDataSource()
    }
    
    func setLayout() {
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        view.addSubview(header)
        emptyView.addSubview(emptyLabel)
        
        header.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
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
    
    func setBinding() {
        let input = HistoryVM.Input(viewDidLoad: Driver.just(()))
        let output = viewModel.transform(input: input)
        
        output.sectionRelay
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.isNotEmpty
            .bind(to: emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func setCollectionLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(98))
        
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
                heightDimension: .absolute(23)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading,
            absoluteOffset: CGPoint(x: 0, y: 0))
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12
        layout.configuration = config
        return layout
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<CreateDateSection>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(for: indexPath) as HistorySplitCell
            let splitItem = item
            cell.configure(split: splitItem)
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
