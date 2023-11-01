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
    
    let header = SPNavigationBar()
    let addView = UIView()
    let addLabel = UILabel()
    let addCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let searchTextField = UITextField()
    let addButton = UIButton()
    let searchView = UIView()
    let searchLabel = UILabel()
    let searchTableView = UITableView(frame: .zero)
    let backgroundView = EmptyBackGroundView()
    
    var selectedMemberArr: [MemberCheck] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .memberSearch, vc: self)
            $0.buttonState.accept(true)
        }
        
        addView.do {
            $0.backgroundColor = .SurfaceDeactivate
            $0.addTopBorderWithColor(color: .BorderPrimary, borderWidth: 1)
            $0.addBottomBorderWithColor(color: .BorderPrimary, borderWidth: 1)
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
            $0.backgroundColor = .SurfaceDeactivate
            $0.collectionViewLayout = layout
            $0.delegate = self
            $0.showsHorizontalScrollIndicator = false
        }
        
        searchView.do {
            $0.backgroundColor = .SurfaceDeactivate
            $0.addTopBorderWithColor(color: .BorderPrimary, borderWidth: 1)
        }
        
        searchTextField.do {
            $0.placeholder = "이름을 입력하세요"
            $0.clearButtonMode = .always
            $0.font = .KoreanTitle3
            $0.textColor = .TextPrimary
            $0.backgroundColor = .SurfacePrimary
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
        
        addButton.do {
            $0.setTitle("추가", for: .normal)
            $0.setTitleColor(.TextPrimary, for: .normal)
            $0.titleLabel?.font = .KoreanSubtitle
            $0.backgroundColor = .SurfaceBrandPear
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
        }
        
        searchView.do {
            $0.backgroundColor = .SurfaceDeactivate
        }
        
        searchLabel.do {
            $0.text = "기존에 추가했던 멤버"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        searchTableView.do {
            $0.register(cellType: SearchCell.self)
            $0.separatorStyle = .none
            $0.backgroundColor = .SurfaceDeactivate
            $0.rowHeight = 48
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func setLayout() {
        [header,searchTextField,addButton,addView,searchView,backgroundView].forEach {
            view.addSubview($0)
        }
        
        [addLabel,addCollectionView].forEach {
            addView.addSubview($0)
        }
        
        [searchLabel,searchTableView].forEach {
            searchView.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        addView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(19)
            $0.height.equalTo(88)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        addCollectionView.snp.makeConstraints {
            $0.top.equalTo(addLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(addView.snp.bottom)
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(addButton.snp.leading).offset(-10)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField)
            $0.height.equalTo(searchTextField)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(110)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        searchLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(24)
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(searchTableView)
            $0.height.equalTo(80)
        }
    }
    
    private func setBinding() {
        let input = CSMemberSearchVM.Input(viewWillAppear: self.rx.viewWillAppear,
                                           textFieldValue: searchTextField.rx.text.orEmpty.asDriver(),
                                           textFieldEnterKeyTapped: searchTextField.rx.controlEvent(.editingDidEndOnExit),
                                           searchCellTapped: searchTableView.rx.itemSelected,
                                           selectedCellTapped: addCollectionView.rx.itemSelected,
                                           addButtonTapped: addButton.rx.tap,
                                           checkButtonTapped: header.rightButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.searchMemberArr
            .bind(to: searchTableView.rx.items(cellIdentifier: "SearchCell")) { _, item, cell in
                if let cell = cell as? SearchCell {
                    cell.configure(item: item)
                }
            }
            .disposed(by: disposeBag)
        
        output.searchMemberArr
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] members in
                guard let self = self else { return }
                if members.isEmpty {
                    self.backgroundView.isHidden = false
                } else {
                    self.backgroundView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        searchTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                self.backgroundView.configure(item: text)
            })
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .asDriver()
            .map { [weak self] isValid -> String in
                guard let self = self else { return "" }
                if !isValid {
                    return String(self.searchTextField.text?.prefix(self.viewModel.maxTextCount) ?? "")
                } else {
                    return self.searchTextField.text ?? ""
                }
            }
            .drive(searchTextField.rx.text)
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
    }
}

extension CSMemberSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = selectedMemberArr[indexPath.item]
        let dynamicWidth = SelectedCell().calculateCellWidth(item: item)
        return CGSize(width: dynamicWidth, height: collectionView.frame.height)
    }
}

private extension UIView {
    func addTopBorderWithColor(color: UIColor, borderWidth: CGFloat) {
        let borderView = UIView()
        borderView.backgroundColor = color
        addSubview(borderView)
        borderView.snp.makeConstraints {
            $0.height.equalTo(borderWidth)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(-1)
        }
    }
    
    func addBottomBorderWithColor(color: UIColor, borderWidth: CGFloat) {
        let borderView = UIView()
        borderView.backgroundColor = color
        addSubview(borderView)
        borderView.snp.makeConstraints {
            $0.height.equalTo(borderWidth)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(1)
        }
    }
}
