//
//  File.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class CSMemberEditVC: UIViewController {
    
    var disposeBag = DisposeBag()
    var footerDisposBag = DisposeBag()
    
    let viewModel = CSMemberEditVM()
    
    let header = NavigationHeader()
    let titleMessage = UILabel()
    let textFieldCounter = UILabel()
    let textFiledNotice = UILabel()
    let searchBar = UITextField()
    let searchListTableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let nextButton = SPButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeyboardNotification()
        self.searchBar.becomeFirstResponder()
    }

    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.configureTitle(title: "모임 수정하기")
            $0.configureBackButton(viewController: self)
        }
        
        titleMessage.do {
            $0.text = "누구와 함께했나요?"
        }
        
        searchBar.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.textAlignment = .center
        }
        
        textFiledNotice.do {
            $0.text = "여기에 사용을 돕는 문구가 들어가요"
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = UIColor(hex: 0x7C7C7C)
        }
        
        textFieldCounter.do {
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = UIColor(hex: 0x7C7C7C)
        }
        
        nextButton.do {
            $0.setTitle("저장하기", for: .normal)
            $0.applyStyle(.primaryPear)
        }

        setSearchTableView()
        setCollectionView()
    }
    
    func setSearchTableView() {
        searchListTableView.do {
            $0.register(cellType: CSMemberInputSearchCell.self)
            $0.register(headerFooterViewType: CSMemberInputSearchFooter.self)
            $0.backgroundColor = UIColor(hex: 0xE5E4E0)
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.layer.zPosition = 1
            $0.rowHeight = 40
            $0.separatorStyle = .none
            $0.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            $0.rx.setDelegate(self)
                .disposed(by: disposeBag)
        }
    }
    
    func setCollectionView() {
        let layout = createLayout()

        collectionView.do {
            $0.layer.borderColor = UIColor(hex: 0x202020).cgColor
            $0.layer.borderWidth = 1
            $0.collectionViewLayout = layout
            $0.register(cellType: CSMemberEditCell.self)
            $0.backgroundColor = UIColor(hex: 0xE5E4E0)
            $0.layer.cornerRadius = 16
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let estimatedHeight: CGFloat = 28
        let estimatedWidth: CGFloat = 120
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(estimatedWidth),
            heightDimension: .absolute(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(8), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func setLayout() {
        [header, titleMessage, searchBar, textFiledNotice, textFieldCounter, nextButton, searchListTableView, collectionView].forEach {
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
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }

        textFieldCounter.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(6)
            $0.trailing.equalTo(searchBar.snp.trailing).inset(6)
        }
        
        textFiledNotice.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(textFiledNotice.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        searchListTableView.snp.makeConstraints {
            $0.top.equalTo(textFiledNotice.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(0)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    func setBinding() {
        let input = CSMemberEditVM.Input(viewDidLoad: Driver.just(()),
                                            nextButtonTapSend: nextButton.rx.tap.asDriver(),
                                          searchBarText: searchBar.rx.text.orEmpty.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input)

        output.isOverlayingSearchView
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isTrue in
                guard let self = self else { return }
                self.collectionView.isUserInteractionEnabled = isTrue
            })
            .disposed(by: disposeBag)
    
        output.memberList
            .bind(to: collectionView.rx.items(cellIdentifier: "CSMemberEditCell")) {
                [weak self] (row, item, cell) in
                guard let self = self else { return }
                if let csCell = cell as? CSMemberEditCell {
                    let cellIndexPath = IndexPath(row: row, section: 0)
                    csCell.configure(item: item, indexPath: cellIndexPath, viewModel: self.viewModel)
                }
            }
            .disposed(by: disposeBag)
        
        output.searchList
            .bind(to: searchListTableView.rx.items(cellIdentifier: "CSMemberInputSearchCell")) {
                (row, item, cell) in
                if let searchCell = cell as? CSMemberInputSearchCell {
                    searchCell.name.text = item
                    searchCell.selectionStyle = .none
                }
            }
            .disposed(by: disposeBag)
        
        output.searchList
            .map { list -> CGFloat in
                let count = list.count
                let searchBarHeight = 36 * (count+1) + 4 * count + 15 * 2
                return CGFloat(searchBarHeight)
            }
            .bind(onNext: { [weak self] height in
                guard let self = self else { return }
                self.searchListTableView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
            })
            .disposed(by: disposeBag)
        
        output.textFieldCounter
            .drive(textFieldCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .map { [weak self] isValid -> String in
                guard let self = self else { return "" }
                if !isValid {
                    return String(self.searchBar.text?.prefix(self.viewModel.maxTextCount) ?? "")
                } else {
                    return self.searchBar.text ?? ""
                }
            }
            .drive(searchBar.rx.text)
            .disposed(by: disposeBag)
        
        output.showCSMemberConfirmView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
        
        viewModel.isOverayViewHidden
            .asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
            .map { $0 }
            .drive(searchListTableView.rx.isHidden)
            .disposed(by: disposeBag)

        searchListTableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                /// 현재 text를 Repository에 추가함.
                /// searchList의 memberList와의 중복 및 text와의 매칭은 viewModel의 비즈니스 로직이 담당.
                let tappedMemberName = output.searchList.value[indexPath.row]
                SplitRepository.share.createCSMember(name: tappedMemberName)

                /// 입력한 text가 현재 memberLog에 존재하지 않는다면 그 text를 Repository에 추가함.
                let canAddMemberLog = viewModel.canAddMemberLogWithName(name: tappedMemberName)
                if canAddMemberLog {
                    SplitRepository.share.createMemberLog(name: tappedMemberName)
                }

                hideSearchView()
                scrollToItemInTableView()
            })
            .disposed(by: disposeBag)
    }
    
    func hideSearchView() {
        Driver<String>.just("")
            .drive(searchBar.rx.text)
            .disposed(by: disposeBag)
        
        Driver<Bool>.just(true)
            .drive(self.viewModel.isOverayViewHidden)
            .disposed(by: disposeBag)
    }
    
    func scrollToItemInTableView() {
        let lastSection = collectionView.numberOfSections - 1
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1

        if lastSection >= 0 && lastItem >= 0 {
            let indexPath = IndexPath(item: lastItem, section: lastSection)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension CSMemberEditVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerCell = tableView.dequeueReusableHeaderFooterView(CSMemberInputSearchFooter.self) else { return UIView() }
        footerCell.addMemberButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }

                let currentMemberList = self.viewModel.memberList.value.map{$0.name}
                let currentSearchText = self.viewModel.currentSearchText.value
                
                let canAddMember = currentMemberList.contains(currentSearchText) ? false : true
                let canAddMemberLog = viewModel.canAddMemberLogWithName(name: currentSearchText)
                
                /// 입력한 text가 memberList에 존재하지 않는다면 그 text를 Repository에 추가함.
                if canAddMember {
                    SplitRepository.share.createCSMember(name: currentSearchText)
                }
                /// 입력한 text가 현재 memberLog에 존재하지 않는다면 그 text를 Repository에 추가함.
                if canAddMemberLog {
                    SplitRepository.share.createMemberLog(name: currentSearchText)
                }

                self.footerDisposBag = DisposeBag()
                
                hideSearchView()
                scrollToItemInTableView()
            })
            .disposed(by: footerDisposBag)
        
        viewModel.currentSearchText
            .asDriver(onErrorJustReturn: "")
            .map { "+ \"\($0)\"님과 함께했어요!"}
            .drive(footerCell.addMemberButton.rx.title(for: .normal))
            .disposed(by: footerDisposBag)
        
        return footerCell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40 - 4
    }
}

extension CSMemberEditVC: UITextFieldDelegate {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.nextButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight + 26)
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        self.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setKeyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self)
    }
    
}

