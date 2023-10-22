//
//  ResultVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

// TODO: 마지막 섹션에는 스플릿항목추가하기버튼
// TODO: compositionalLayout backgroundView 필요
// TODO: ViewModel 정의 나머지
// TODO: Cell안에 CompositionalLayout 해야함
// TODO: Cell Layout 정의

class ResultVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = ResultVM()
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<ResultSection>!
    
    let header = NavigationHeader()
    let splitTitle = UILabel()
    let splitDate = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.configureBackButton(viewController: self)
        }
        
        splitTitle.do {
            $0.text = "Split Title"
            $0.font = .systemFont(ofSize: 24)
        }
        
        splitDate.do {
            $0.text = "2023년 10월 3일"
            $0.font = .systemFont(ofSize: 12)
        }
        
        nextButton.do {
            $0.setTitle("내가 만든 영수증 발급하기", for: .normal)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = UIColor(hex: 0x19191B)
        }
        
        setCollectionView()
    }
    
    func setCollectionView() {
        // MARK: CollectionView Layout 정의
        
        let addSplitSectionIndex = viewModel.sections.value.count - 1
        let lastSectionIndex = addSplitSectionIndex - 1
        
        let layout = DisplayLayoutFactory.createResultLayout(tappedIndex: lastSectionIndex, lastSection: addSplitSectionIndex)
        
        layout.register(ResultSectionBackground.self, forDecorationViewOfKind: ResultSectionBackground.reuseIdentifier)
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.collectionViewLayout = layout
            $0.register(cellType: ResultCell.self)
            $0.register(supplementaryViewType: AddSplitHeader.self,
                        ofKind: UICollectionView.elementKindSectionHeader)
            $0.register(supplementaryViewType: ResultSectionHeader.self,
                        ofKind: UICollectionView.elementKindSectionHeader)
        }
        
        dataSource = RxCollectionViewSectionedReloadDataSource<ResultSection>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                let section = dataSource.sectionModels[indexPath.section]
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ResultCell.self)
                let item = section.items[indexPath.row]
                cell.configure(item: item)
                return cell
            }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                
                let section = dataSource.sectionModels[indexPath.section]
                let addSplitSection = dataSource.sectionModels.count - 1

                if indexPath.section == addSplitSection {
                    let addSplitHeader: AddSplitHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                    
                    return addSplitHeader
                } else {
                    let header: ResultSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                    
                    if section.isFold {
                        header.configureFold(item: section.header, sectionIndex: indexPath.section)
                    } else {
                        header.configureUnfold(item: section.header, sectionIndex: indexPath.section)
                    }
                    header.toggleButton.rx.tap
                        .asDriver()
                        .drive(onNext: { [weak self] _ in
                            guard let self = self else { return }
                            // TODO: 나중엔 section 자체의 isFold도 바꿔줘서 collectionView를 다시그려주도록 해야함
                            self.collectionView.collectionViewLayout = DisplayLayoutFactory.createResultLayout(tappedIndex: indexPath.section, lastSection: addSplitSection)
                            
                            var sections = viewModel.sections.value
                            sections.enumerated().forEach { index, section in
                                if index == indexPath.section {
                                    sections[index].isFold = false
                                } else {
                                    sections[index].isFold = true
                                }
                            }
                            viewModel.sections.accept(sections)
                        })
                        .disposed(by: header.disposeBag)
                    
                    return header
                }
            }
        )
        
    }
    
    func setLayout() {
        [header, splitTitle, splitDate, collectionView ,nextButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        splitTitle.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        splitDate.snp.makeConstraints {
            $0.top.equalTo(splitTitle.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(splitDate.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = ResultVM.Input(nextButtonTapSend: nextButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        viewModel.sections
            .asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.presentResultView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                print("다음 ㄱㄱ")
                //                let vc = ExclItemPriceInputVC()
                //                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
}

//// TODO: ResultView에서 쓰일 foldLayout
///// 마지막 차수가 열려있고 나머지는 닫혀있어야함.
//extension ResultVC {
//    func createLayout() -> UICollectionViewLayout {
//        let estimatedHeight: CGFloat = 28
//        let estimatedWidth: CGFloat = 80
//
//        // MARK: Section -> ExclItem이 item으로 존재하는 Section
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .estimated(estimatedWidth),
//            heightDimension: .absolute(estimatedHeight)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
//            leading: .fixed(8),
//            top: .fixed(0),
//            trailing: .fixed(0),
//            bottom: .fixed(0)
//        )
//
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(estimatedHeight)
//        )
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize,
//            subitems: [item]
//        )
//        group.contentInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: 8,
//            bottom: 0,
//            trailing: 8
//        )
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 8
//        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
//                                                        leading: 0,
//                                                        bottom: 16,
//                                                        trailing: 0)
//
//        // MARK: ExclItem 관련 Background, decoration View
//        let header = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .absolute(25)),
//            elementKind: UICollectionView.elementKindSectionHeader,
//            alignment: .topLeading,
//            absoluteOffset: CGPoint(x: 0, y: 0))
//        section.boundarySupplementaryItems = [header]
//
//        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: ResultSectionBackground.reuseIdentifier)
//        section.decorationItems = [ sectionBackground ]
//
//        // MARK: Section -> 따로 계산할 항목 더 추가하기 버튼이 존재하는 Section
//        let addButtonHeight = 104.0
//        let addSectionItemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .absolute(addButtonHeight)
//        )
//        let addSectionItem = NSCollectionLayoutItem(layoutSize: addSectionItemSize)
//        let addSectionGroup = NSCollectionLayoutGroup.horizontal(layoutSize: addSectionItemSize,
//                                                                 subitems: [addSectionItem])
//        let addSection = NSCollectionLayoutSection(group: addSectionGroup)
//
//        // MARK: Layout 정의
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
//            return sectionIndex == self.viewModel.sections.value.count - 1 ? addSection : section
//        }
//
//        // MARK: Layout Config 정의
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 16
//        layout.configuration = config
//
//        return layout
//    }
//
//
//    func foldLayout(index: Int) -> UICollectionViewLayout {
//        let estimatedHeight: CGFloat = 28
//        let estimatedWidth: CGFloat = 80
//
//        // MARK: Section -> ExclItem이 item으로 존재하는 Section
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .estimated(estimatedWidth),
//            heightDimension: .absolute(estimatedHeight)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
//            leading: .fixed(8),
//            top: .fixed(0),
//            trailing: .fixed(0),
//            bottom: .fixed(0)
//        )
//
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(estimatedHeight)
//        )
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize,
//            subitems: [item]
//        )
//        group.contentInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: 8,
//            bottom: 0,
//            trailing: 8
//        )
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 8
//        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
//                                                        leading: 0,
//                                                        bottom: 16,
//                                                        trailing: 0)
//
//
//
//        // MARK: Section -> ExclItem이 item으로 존재하는 Section
//        let foldItemSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(0),
//            heightDimension: .absolute(0)
//        )
//        let foldItem = NSCollectionLayoutItem(layoutSize: foldItemSize)
//
//
//        let foldGroupSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(0),
//            heightDimension: .absolute(0)
//        )
//        let foldGroup = NSCollectionLayoutGroup.horizontal(
//            layoutSize: foldGroupSize,
//            subitems: [foldItem]
//        )
//        foldGroup.contentInsets = NSDirectionalEdgeInsets(
//            top: 0,
//            leading: 0,
//            bottom: 0,
//            trailing: 8
//        )
//        let foldSection = NSCollectionLayoutSection(group: foldGroup)
//        foldSection.interGroupSpacing = 0
//        foldSection.contentInsets = NSDirectionalEdgeInsets(top: 0,
//                                                        leading: 0,
//                                                        bottom: 0,
//                                                        trailing: 0)
//
//        // MARK: ExclItem 관련 Background, decoration View
//        let header = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .absolute(27)),
//            elementKind: UICollectionView.elementKindSectionHeader,
//            alignment: .topLeading,
//            absoluteOffset: CGPoint(x: 0, y: 0))
//
//        let foldHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .absolute(50)),
//            elementKind: UICollectionView.elementKindSectionHeader,
//            alignment: .topLeading,
//            absoluteOffset: CGPoint(x: 0, y: 0))
//
//        foldSection.boundarySupplementaryItems = [foldHeader]
//
//
//
//        section.boundarySupplementaryItems = [header]
//
//        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: ResultSectionBackground.reuseIdentifier)
//        section.decorationItems = [ sectionBackground ]
//
//        // MARK: Section -> 따로 계산할 항목 더 추가하기 버튼이 존재하는 Section
//        let addButtonHeight = 104.0
//        let addSectionItemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .absolute(addButtonHeight)
//        )
//        let addSectionItem = NSCollectionLayoutItem(layoutSize: addSectionItemSize)
//        let addSectionGroup = NSCollectionLayoutGroup.horizontal(layoutSize: addSectionItemSize,
//                                                                 subitems: [addSectionItem])
//        let addSection = NSCollectionLayoutSection(group: addSectionGroup)
//
//        // MARK: Layout 정의
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
//
//            if sectionIndex == self.viewModel.sections.value.count - 1 {
//                return addSection
//            } else if sectionIndex == index {
//                return foldSection
//            } else {
//                return section
//            }
//
//            //return sectionIndex == self.viewModel.sections.value.count - 1 ? addSection : section
//        }
//
//        // MARK: Layout Config 정의
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 16
//        layout.configuration = config
//
//        return layout
//    }
//}
//
//
//
