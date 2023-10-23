//
//  ExclMemberVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ExclMemberVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let viewModel = ExclMemberVM()
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<ExclMemberSectionModel>!
    
    let titleMessage = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let nextButton = SPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        titleMessage.do {
            $0.text = "계산에서 제외할 사람을 선택해주세요"
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        nextButton.do {
            $0.setTitle("결과 확인하기", for: .normal)
            $0.applyStyle(.primaryPear)
        }
        
        setCollectionView()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let estimatedHeight: CGFloat = 28
        let estimatedWidth: CGFloat = 80
        
        // MARK: Section -> ExclItem이 item으로 존재하는 Section
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(estimatedWidth),
            heightDimension: .absolute(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(8),
            top: .fixed(0),
            trailing: .fixed(0),
            bottom: .fixed(0)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                        leading: 0,
                                                        bottom: 16,
                                                        trailing: 0)

        // MARK: ExclItem 관련 Background, decoration View
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(25)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading,
            absoluteOffset: CGPoint(x: 0, y: 0))
        section.boundarySupplementaryItems = [header]
        
        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: ExclMemberSectionBackground.reuseIdentifier)
        section.decorationItems = [ sectionBackground ]

        // MARK: Section -> 따로 계산할 항목 더 추가하기 버튼이 존재하는 Section
        let addButtonHeight = 104.0
        let addSectionItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(addButtonHeight)
        )
        let addSectionItem = NSCollectionLayoutItem(layoutSize: addSectionItemSize)
        let addSectionGroup = NSCollectionLayoutGroup.horizontal(layoutSize: addSectionItemSize,
                                                                 subitems: [addSectionItem])
        let addSection = NSCollectionLayoutSection(group: addSectionGroup)
        
        // MARK: Layout 정의
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return sectionIndex == self.viewModel.sections.value.count - 1 ? addSection : section
        }
        
        // MARK: Layout Config 정의
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        
        return layout
    }
    
    func setCollectionView() {
        // MARK: CollectionView Layout 정의
        let layout = createLayout()
        // layout에 background register
        layout.register(ExclMemberSectionBackground.self, forDecorationViewOfKind: ExclMemberSectionBackground.reuseIdentifier)

        collectionView.do {
            $0.backgroundColor = .clear
            $0.collectionViewLayout = layout
            $0.register(cellType: ExclMemberCell.self)
            $0.register(cellType: ExclAddCell.self)
            $0.register(supplementaryViewType: ExclMemberSectionHeader.self,
                        ofKind: UICollectionView.elementKindSectionHeader)
        }
        
        dataSource = RxCollectionViewSectionedReloadDataSource<ExclMemberSectionModel>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                switch dataSource.sectionModels[indexPath.section].type {
                case .data(let section):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ExclMemberCell.self)
                    let item = section.items[indexPath.row]
                    cell.configure(item: item)
                    return cell
                case .button:
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ExclAddCell.self)
                    return cell
                }
            }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header: ExclMemberSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                
                switch dataSource.sectionModels[indexPath.section].type {
                case .data(let section):
                    header.configure(item: section, sectionIndex: indexPath.section)
                case .button:
                    break
                }
                return header
            }
        )

        collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let sections = viewModel.sections.value
                let sectionModel = sections[indexPath.section]
                
                switch sectionModel.type {
                case .button(_:):
                    let vc = ExclPageController()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .data(let target):
                    let tappedExclMemberIdx = target.items[indexPath.row].exclMemberIdx
                    SplitRepository.share.toggleExclMember(exclMemberIdx: tappedExclMemberIdx)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setLayout() {
        [titleMessage, collectionView, nextButton].forEach {
            view.addSubview($0)
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-34)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = ExclMemberVM.Input(viewDidLoad: Driver.just(()),
                                       nextButtonTapSend: nextButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        viewModel.sections
            .asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.presentResultView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nextButton.applyStyle(.primaryPearPressed)
                print("다음 ㄱㄱ")
//                let vc = ExclItemPriceInputVC()
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.presentResultView
            .delay(.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nextButton.applyStyle(.primaryPear)
            })
            .disposed(by: disposeBag)
    }
    
}


