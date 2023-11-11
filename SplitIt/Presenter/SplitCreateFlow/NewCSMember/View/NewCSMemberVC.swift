//
//  NewCSMemberVC.swift
//  SplitIt
//
//  Created by Zerom on 2023/11/09.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxAppState
import Reusable

class NewCSMemberVC: UIViewController, Reusable {
    let disposeBag = DisposeBag()
    let viewModel = NewCSMemberVM()
    
    let header = SPNavigationBar()
    let addLabel = UILabel()
    let memberCount = UILabel()
    let addCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let lineView = UIView()
    let searchTextFieldLabel = UILabel()
    let searchTextField = SPTextField()
    let addButton = UIButton()
    let searchView = UIView()
    let searchLabel = UILabel()
    let searchTableView = UITableView(frame: .zero)
    let nextButton = NewSPButton()
    
    let backgroundView = CSMemberEmptyBackGroundView()
    
    // searchTextField delegate에서 인지해서 신호를 보내주기 위한 Relay
    // return키를 눌렀을 때만 endEditing이 동작하지 않도록 하기 위함
    let searchTextFieldReturnKeyTapped = PublishRelay<Void>()
    
    var selectedMemberArr: [MemberCheck] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextField.resignFirstResponder()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .csMemberCreate, vc: self)
        }
        
        addLabel.do {
            $0.text = "함께한 멤버 | "
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        memberCount.do {
            $0.font = .KoreanCaption2
            $0.textColor = .TextPrimary
        }
        
        addCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            $0.register(cellType: CSMemberSelectedCell.self)
            $0.backgroundColor = .clear
            $0.collectionViewLayout = layout
            $0.delegate = self
            $0.showsHorizontalScrollIndicator = false
        }
        
        lineView.do {
            $0.backgroundColor = .BorderDeactivate
        }
        
        searchTextFieldLabel.do {
            $0.text = "누구누구와 함께했나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextPrimary
        }
        
        searchTextField.do {
            $0.placeholder = "이름을 입력하세요"
            $0.applyStyle(.normal)
            $0.textColor = .TextPrimary
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.delegate = self
        }
        
        addButton.do {
            $0.setImage(UIImage(named: "PlusIconDefault"), for: .normal)
            $0.imageView?.contentScaleFactor = 2.0
            $0.backgroundColor = .SurfaceBrandPear
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        searchView.do {
            $0.backgroundColor = .SurfaceDeactivate
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        searchLabel.do {
            $0.text = "기존에 추가했던 멤버"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        searchTableView.do {
            $0.register(cellType: CSMemberSearchCell.self)
            $0.separatorStyle = .none
            $0.backgroundColor = .SurfaceDeactivate
            $0.rowHeight = 48
            $0.showsVerticalScrollIndicator = false
        }
        
        nextButton.do {
            $0.applyStyle(style: .primaryPear, shape: .rounded)
            self.nextButton.setTitle("2명부터 정산할 수 있어요", for: .normal)
        }
    }
    
    private func setLayout() {
        [header,addLabel,memberCount,addCollectionView,lineView,searchTextFieldLabel,searchTextField,addButton,searchView,nextButton,backgroundView].forEach {
            view.addSubview($0)
        }
        
        [searchLabel,searchTableView].forEach {
            searchView.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        addLabel.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(38)
        }
        
        memberCount.snp.makeConstraints {
            $0.centerY.equalTo(addLabel)
            $0.leading.equalTo(addLabel.snp.trailing)
        }
        
        addCollectionView.snp.makeConstraints {
            $0.top.equalTo(addLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(53)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(addCollectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        searchTextFieldLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(38)
        }
         
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(searchTextFieldLabel.snp.bottom).offset(8)
            $0.height.equalTo(46)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalTo(addButton.snp.leading).offset(-10)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField)
            $0.height.width.equalTo(46)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(nextButton.snp.top).offset(-24)
        }
        
        searchLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(searchTableView)
            $0.height.equalTo(80)
        }
    }
    
    private func setBinding() {
        let input = NewCSMemberVM.Input(viewWillAppear: self.rx.viewWillAppear,
                                        textFieldValue: searchTextField.rx.text.orEmpty.asDriver(),
                                        textFieldReturnKeyTapped: searchTextFieldReturnKeyTapped,
                                        searchCellTapped: searchTableView.rx.itemSelected,
                                        selectedCellTapped: addCollectionView.rx.itemSelected,
                                        addButtonTapped: addButton.rx.tap,
                                        nextButtonTapped: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.searchMemberArr
            .bind(to: searchTableView.rx.items(cellIdentifier: "CSMemberSearchCell")) { _, item, cell in
                if let cell = cell as? CSMemberSearchCell {
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
        
        output.textFieldValue
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else { return }
                self.backgroundView.configure(item: text)
            })
            .disposed(by: disposeBag)
        
        output.textFieldValue
            .asDriver()
            .drive(searchTextField.rx.value)
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
            .bind(to: addCollectionView.rx.items(cellIdentifier: "CSMemberSelectedCell")) { _, item, cell in
                if let cell = cell as? CSMemberSelectedCell {
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
            .asDriver()
            .drive(onNext: { [weak self] memberArr in
                guard let self = self else { return }
                let buttonState = memberArr.count >= 2
                self.nextButton.buttonState.accept(buttonState)
                
                buttonState
                ? self.nextButton.setTitle("\(memberArr.count)명이서 돈을 썼어요", for: .normal)
                : self.nextButton.setTitle("2명부터 정산할 수 있어요", for: .normal)
                
                self.memberCount.text = "\(memberArr.count)명"
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
        
        searchTableView.rx.didScroll.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.showExclItemVC
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let vc = SplitRepository.share.isSmartSplit ? ExclItemInputVC() : SplitShareVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension NewCSMemberVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = selectedMemberArr[indexPath.item]
        let dynamicWidth = CSMemberSelectedCell().calculateCellWidth(item: item)
        return CGSize(width: dynamicWidth, height: collectionView.frame.height)
    }
}

extension NewCSMemberVC: UISearchTextFieldDelegate {
    // searchTextField에서 returnKey를 탭했을 때 인지해서 신호만 보내줌
    // 이때는 endEditing이 동작하지 않도록 하기 위함
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextFieldReturnKeyTapped.accept(())
        return false
    }
}