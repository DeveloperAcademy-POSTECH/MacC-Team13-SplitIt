//
//  CSMemberSearchView.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/27.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxAppState
import Reusable

class CSMemberSearchVC: UIViewController, Reusable {
    let disposeBag = DisposeBag()
    let viewModel = CSMemberSearchVM()
    
    let naviTitle = UILabel()
    let checkButton = UIButton()
    let addTopBorder = UIView()
    let addLabel = UILabel()
    let addCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let addBottomBorder = UIView()
    let searchTextField = UITextField()
    let addButton = UIButton()
    let searchTopBorder = UIView()
    let searchLabel = UILabel()
    let searchTableView = UITableView(frame: .zero)
    
    var selectedMemberArr: [MemberCheck] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        naviTitle.do {
            $0.text = "멤버 추가"
            $0.font = .KoreanTitle3
            $0.textColor = .TextPrimary
        }
        
        checkButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.SurfaceBrandPear, for: .normal)
            $0.titleLabel?.font = .KoreanTitle3
        }
        
        addTopBorder.do {
            $0.backgroundColor = .BorderPrimary
        }
        
        addLabel.do {
            $0.text = "추가 된 멤버"
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        addCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            $0.register(cellType: SelectedCell.self)
            $0.backgroundColor = .SurfacePrimary
            $0.collectionViewLayout = layout
            $0.delegate = self
            $0.showsHorizontalScrollIndicator = false
        }
        
        addBottomBorder.do {
            $0.backgroundColor = .BorderPrimary
        }
        
        searchTextField.do {
            $0.placeholder = "이름을 입력하세요"
            $0.font = .KoreanTitle3
            $0.textColor = .TextPrimary
            $0.backgroundColor = .SurfacePrimary
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
        
        addButton.do {
            $0.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        }
        
        searchTopBorder.do {
            $0.backgroundColor = .BorderPrimary
        }
        
        searchLabel.do {
            $0.text = "기존에 추가했던 멤버"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        searchTableView.do {
            $0.register(cellType: SearchCell.self)
            $0.separatorStyle = .none
            $0.backgroundColor = .SurfacePrimary
            $0.rowHeight = 48
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func setLayout() {
        [naviTitle,checkButton,addTopBorder,addLabel,addCollectionView,addBottomBorder,
         searchTextField,addButton,searchLabel,searchTopBorder,searchTableView].forEach {
            view.addSubview($0)
        }
        
        naviTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(11)
            $0.centerX.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalTo(naviTitle)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        addTopBorder.snp.makeConstraints {
            $0.top.equalTo(naviTitle.snp.bottom).offset(19)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addLabel.snp.makeConstraints {
            $0.top.equalTo(addTopBorder.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        addCollectionView.snp.makeConstraints {
            $0.top.equalTo(addLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(addBottomBorder.snp.top)
        }
        
        addBottomBorder.snp.makeConstraints {
            $0.top.equalTo(addTopBorder.snp.bottom).offset(88)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(addBottomBorder.snp.bottom)
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(addButton.snp.leading)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(30)
        }
        
        searchTopBorder.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        searchLabel.snp.makeConstraints {
            $0.top.equalTo(searchTopBorder.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setBinding() {
        let input = CSMemberSearchVM.Input(viewWillAppear: self.rx.viewWillAppear,
                                           textFieldValue: searchTextField.rx.text.orEmpty.asDriver(),
                                           textFieldEnterKeyTapped: searchTextField.rx.controlEvent(.editingDidEndOnExit),
                                           searchCellTapped: searchTableView.rx.itemSelected,
                                           selectedCellTapped: addCollectionView.rx.itemSelected,
                                           addButtonTapped: addButton.rx.tap,
                                           checkButtonTapped: checkButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.searchMemberArr
            .bind(to: searchTableView.rx.items(cellIdentifier: "SearchCell")) { _, item, cell in
                if let cell = cell as? SearchCell {
                    cell.configure(item: item)
                }
            }
            .disposed(by: disposeBag)
        
        output.selectedMemberArr
            .bind(to: addCollectionView.rx.items(cellIdentifier: "SelectedCell")) { _, item, cell in
                if let cell = cell as? SelectedCell {
                    cell.configure(item: item)
                }
            }
            .disposed(by: disposeBag)
        
        output.selectedMemberArr
            .asDriver()
            .drive(onNext: { [weak self] memberArr in
                guard let self = self else { return }
                self.selectedMemberArr = memberArr
            })
            .disposed(by: disposeBag)
        
        output.selectedMemberArr
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] selectedMembers in
                guard let self = self else { return }
                let count = selectedMembers.count
                if count == 0 {
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                        self.addBottomBorder.backgroundColor = .SurfacePrimary
                        self.addBottomBorder.snp.updateConstraints {
                            $0.top.equalTo(self.addTopBorder.snp.bottom)
                        }
                        
                        self.view.layoutIfNeeded()
                    })
                } else if count == 1 && addBottomBorder.backgroundColor == .SurfacePrimary {
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                        self.addBottomBorder.backgroundColor = .BorderPrimary
                        self.addBottomBorder.snp.updateConstraints {
                            $0.top.equalTo(self.addTopBorder.snp.bottom).offset(88)
                        }
                        
                        self.view.layoutIfNeeded()
                    })
                }
            })
            .disposed(by: disposeBag)
        
        Driver.combineLatest(addCollectionView.rx.willDisplayCell.asDriver(),
                             output.isCellAppear.asDriver(),
                             output.deleteIndex.asDriver())
            .drive(onNext: { (cell, isAppear, deleteIndex) in
                let (cell, indexPath) = cell
                
                if isAppear && indexPath.row == 0 {
                    cell.alpha = 0
                    cell.transform = CGAffineTransform(translationX: -cell.frame.width, y: 0)
                    
                    UIView.animate(withDuration: 0.3) {
                        cell.alpha = 1
                        cell.transform = .identity
                    }
                } else if !isAppear && indexPath.row >= deleteIndex {
                    cell.transform = CGAffineTransform(translationX: cell.frame.width, y: 0)

                    UIView.animate(withDuration: 0.3) {
                        cell.transform = .identity
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.closeCurrentVC.asDriver()
            .drive(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension CSMemberSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = selectedMemberArr[indexPath.item]
        let dynamicWidth = SelectedCell().calculateCellWidth(item: item)
        return CGSize(width: dynamicWidth, height: collectionView.frame.height)
    }
}
