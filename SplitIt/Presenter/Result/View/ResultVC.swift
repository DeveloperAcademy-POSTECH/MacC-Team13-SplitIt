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
    let headerViewModel = ResultSectionHeaderVM()
    
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
        
        //TODO: 토글버튼 이벤트 VM에 주고 collectionview를 reload하기
        dataSource = RxCollectionViewSectionedReloadDataSource<ResultSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
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
                    
                    addSplitHeader.viewModel.addSplitTapped
                        .take(1)
                        .observe(on: MainScheduler.asyncInstance)
                        .subscribe(onNext: { [weak self] _ in
                            guard let self = self else { return }
                            let vc = CSTitleInputVC()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }, onCompleted: {
                            SplitRepository.share.createNewCS()
                        })
                        .disposed(by: addSplitHeader.disposeBag)
                    
                    return addSplitHeader
                } else {
                    let header: ResultSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                    header.indexPath = indexPath
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
                            
                            let layout = DisplayLayoutFactory.createResultLayout(tappedIndex: header.indexPath.section, lastSection: addSplitSection)
                            layout.register(ResultSectionBackground.self, forDecorationViewOfKind: ResultSectionBackground.reuseIdentifier)
                            collectionView.collectionViewLayout = layout

                            UIView.performWithoutAnimation {
                                collectionView.reloadSections([header.indexPath.section, addSplitSection], animationStyle: .none)
                            }

                            header.configureUnfold(item: section.header, sectionIndex: indexPath.section)
                            
                            var sections = viewModel.sections.value
                            sections.enumerated().forEach { index, section in
                                if index == header.indexPath.section {
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
        let input = ResultVM.Input(viewDidLoad: Driver<Void>.just(()),
                                   nextButtonTapSend: nextButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        setCollectionView()
        
        viewModel.sections
            .asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.splitTitle
            .drive(splitTitle.rx.text)
            .disposed(by: disposeBag)
        
        output.splitDateString
            .drive(splitDate.rx.text)
            .disposed(by: disposeBag)

        output.presentResultView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                print("다음 ㄱㄱ")
                //                let vc = ExclItemPriceInputVC()
                //                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
//
//        viewModel.addSplitHeaderTapped
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { _ in
//                SplitRepository.share.createNewCS()
//
//                print("taptap")
////                let vc = CSTitleInputVC()
////                self.navigationController?.pushViewController(vc, animated: true)
//            })
//            .disposed(by: disposeBag)
    }
}
