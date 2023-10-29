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
import RxAppState

class ResultVC: UIViewController {
    
    var disposeBag = DisposeBag()
    var footerDisposeBag = DisposeBag()
    
    let viewModel = ResultVM()
    let headerViewModel = ResultSectionHeaderVM()
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<ResultSection>!
    
    let header = NaviHeader()
    let splitTitle = UILabel()
    let splitDate = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let nextButton = SPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    deinit {
        footerDisposeBag = DisposeBag()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.applyStyle(.result)
            $0.setExitButton(viewController: self)
        }
        
        splitTitle.do {
            $0.text = "Split Title"
            $0.font = .KoreanTitle3
            $0.textColor = .TextPrimary
        }
        
        splitDate.do {
            $0.text = "2023년 10월 3일"
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
        }
        
        nextButton.do {
            $0.applyStyle(.primaryWatermelon)
            $0.setTitle("내가 만든 영수증 발급하기", for: .normal)
            $0.setTitleColor(UIColor.TextPrimary, for: .normal)
            $0.titleLabel?.font = .KoreanButtonText
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
            $0.register(supplementaryViewType: ResultSectionFooter.self,
                        ofKind: UICollectionView.elementKindSectionFooter)
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
                
                if kind == UICollectionView.elementKindSectionFooter {
                    let footer: ResultSectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                    
                    footer.button.rx.tap
                        .asDriver()
                        .drive(onNext: { [weak self] in
                            // TODO: Edit Flow
                            guard let self = self else { return }
                            let csinfo = viewModel.csInfos.value[indexPath.section].csInfoIdx
                            let vc = CSEditListVC(csinfoIdx: csinfo)
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            footerDisposeBag = DisposeBag()
                        })
                        .disposed(by: self.footerDisposeBag)
                    
                    footer.indexPath = indexPath
                    return footer
                }
                
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
        
//        collectionView.rx
//            .modelSelected(ResultSectionFooter.self)
//            .subscribe(onNext: { footer in
//
//            })
//            .disposed(by: disposeBag)
    }
    
    func setLayout() {
        [header, splitTitle, splitDate, collectionView ,nextButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        splitTitle.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(24)
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
        let input = ResultVM.Input(viewWillAppear: self.rx.viewWillAppear.asDriver(onErrorJustReturn: false),
                                   viewDidLoad: Driver<Void>.just(()),
                                   nextButtonTapSend: nextButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        setCollectionView()
        
        output.sections
            .asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.splitTitle
            .map { [weak self] title in
                guard let self = self else { return "" }
                let splitTitleAttribute = NSMutableAttributedString(string: title)
                splitTitleAttribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: splitTitleAttribute.length))
                self.splitTitle.attributedText = splitTitleAttribute
                return title
            }
            .drive(splitTitle.rx.text)
            .disposed(by: disposeBag)
        
        output.splitDateString
            .drive(splitDate.rx.text)
            .disposed(by: disposeBag)
        
        output.presentResultView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nextButton.applyStyle(.primaryWatermelonPressed)
                let vc = SplitShareVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.presentResultView
            .delay(.milliseconds(500))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nextButton.applyStyle(.primaryWatermelon)
            })
            .disposed(by: disposeBag)
        
        //MARK: 이걸로 수정할거임
//        viewModel.tappedSectionIndex
//            .asDriver()
//            .drive(onNext: { [weak self] index in
//                guard let self = self else { return }
//                let layout = DisplayLayoutFactory.createResultLayout(tappedIndex: index, lastSection: output.sections.value.count)
//                layout.register(ResultSectionBackground.self, forDecorationViewOfKind: ResultSectionBackground.reuseIdentifier)
//                collectionView.collectionViewLayout = layout
//                collectionView.reloadData()
//            })
//            .disposed(by: disposeBag)

    }
}

////MARK: 이걸로 수정할거임
//extension ResultVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        if elementKind == UICollectionView.elementKindSectionHeader {
//            let section = dataSource.sectionModels[indexPath.section]
//            let addSplitSection = dataSource.sectionModels.count - 1
//            if indexPath.section == addSplitSection {
//                let addSplitHeader: AddSplitHeader = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, for: indexPath)
//
//                addSplitHeader.viewModel.addSplitTapped
//                    .take(1)
//                    .observe(on: MainScheduler.asyncInstance)
//                    .subscribe(onNext: { [weak self] _ in
//                        guard let self = self else { return }
//                        let vc = CSTitleInputVC()
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }, onCompleted: {
//                        SplitRepository.share.createNewCS()
//                    })
//                    .disposed(by: addSplitHeader.disposeBag)
//            } else {
//                let header: ResultSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, for: indexPath)
//                header.indexPath = indexPath
//                header.viewModel = self.viewModel
//                header.setBinding()
//                if section.isFold {
//                    print("접힘: \(indexPath)")
//                    header.configureFold(item: section.header, sectionIndex: indexPath.section)
//                } else {
//                    print("펼쳐짐: \(indexPath)")
//                    header.configureUnfold(item: section.header, sectionIndex: indexPath.section)
//                }
//
//            }
//        } else if elementKind == UICollectionView.elementKindSectionFooter {
//
//        }
//    }
//}
