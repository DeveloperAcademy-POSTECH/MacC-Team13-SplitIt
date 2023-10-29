//
//  File.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/22.
//
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ExclMemberEditVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var viewModel: ExclMemberEditVM
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<ExclMemberEditSectionModel>!
    
    let header = NaviHeader()
    let titleMessage = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let nextButton = NewSPButton()
    
    init(viewModel: ExclMemberEditVM) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setAttribute()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.applyStyle(.edit)
            $0.setBackButton(viewController: self)
        }
        
        titleMessage.do {
            $0.text = "계산에서 제외할 사람을 다시 선택해주세요"
            $0.font = .KoreanBody
        }
        
        nextButton.do {
            $0.setTitle("저장하기", for: .normal)
            $0.applyStyle(style: .primaryPear, shape: .rounded)
            $0.buttonState.accept(true)
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
        
        // MARK: Layout 정의
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return section
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
            $0.register(supplementaryViewType: ExclMemberEditSectionHeader.self,
                        ofKind: UICollectionView.elementKindSectionHeader)
        }
        
        dataSource = RxCollectionViewSectionedReloadDataSource<ExclMemberEditSectionModel>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                switch dataSource.sectionModels[indexPath.section].type {
                case .data(let section):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ExclMemberCell.self)
                    let item = section.items[indexPath.row]
                    cell.configure(item: item)
                    return cell
                }
            }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header: ExclMemberEditSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                
                switch dataSource.sectionModels[indexPath.section].type {
                case .data(let section):
                    header.configure(item: section, sectionIndex: indexPath.section)
                }
                return header
            }
        )

        collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let sections = viewModel.sections.value
                let sectionModel = sections
                
                switch sectionModel.type {
                case .data(let target):
                    let tappedExclMemberIdx = target.items[indexPath.row].exclMemberIdx
                    SplitRepository.share.toggleExclMember(exclMemberIdx: tappedExclMemberIdx)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setLayout() {
        [header, titleMessage, collectionView, nextButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = ExclMemberEditVM.Input(nextButtonTapSend: nextButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        viewModel.sections
            .asDriver()
            .map { [$0] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.presentResultView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                // 현재 뷰 컨트롤러에서 3개의 뷰를 건너뛰어 이전 뷰로 돌아가기
//                self.nextButton.applyStyle(.primaryPearPressed)
                SplitRepository.share.updateDataToDB()
                if let navigationController = self.navigationController {
                    if let previousViewController = navigationController.viewControllers[navigationController.viewControllers.count - 4] as? CSEditListVC {
                        navigationController.popToViewController(previousViewController, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}
