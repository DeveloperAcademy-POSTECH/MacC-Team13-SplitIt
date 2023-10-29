//
//  CSEditListVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/18.
//

import UIKit
import Reusable
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import RxAppState
import RealmSwift

final class CSEditListVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let csinfoIdx: String
    let viewModel: CSEditListVM
    
    let header = NaviHeader()
    let titleEditBtn = UIButton(type: .system)
    let titleLabel = UILabel()
    var titleStackView = UIStackView()
    let totalAmountEditBtn = UIButton(type: .system)
    let totalAmountLabel = UILabel()
    var totalAmountStack = UIStackView()
    let memberEditBtn = UIButton(type: .system)
    let memberLabel = UILabel()
    var memberStack = UIStackView()
    let tableHeaderLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    let exclAddButton = UILabel()
    let saveButton = NewSPButton()
    let delButton = UILabel()
    let tapDelBtn = UITapGestureRecognizer()
    let tapAddExclItem = UITapGestureRecognizer()
    
    init(csinfoIdx: String = "652fe13e384fd0feba2561bf") {
        self.disposeBag = DisposeBag()
        self.csinfoIdx = csinfoIdx
        self.viewModel = CSEditListVM(csinfoIdx: csinfoIdx)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        let atrString = NSMutableAttributedString(string: "따로 계산할 것 추가하기")
        atrString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: atrString.length))
        
        let atrString2 = NSMutableAttributedString(string: "삭제하기")
        atrString2.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: atrString2.length))
        
         titleStackView = setStackView(titleBtn: titleEditBtn ,
                            st: "이름",
                            view: titleLabel)
        totalAmountStack = setStackView(titleBtn: totalAmountEditBtn ,
                            st: "사용한 총액",
                            view: totalAmountLabel)
        memberStack = setStackView(titleBtn: memberEditBtn ,
                                   st: "함께한 사람들",
                                   view: memberLabel)
        
        header.do {
            $0.applyStyle(.edit)
            $0.setBackButton(viewController: self)
        }
        
        tableHeaderLabel.do {
            $0.text = "따로 계산할 것"
            $0.textColor = .TextSecondary
            $0.font = .KoreanCaption2
        }
        
        tableView.do {
            $0.register(cellType: CSEditListCell.self)
            $0.rowHeight = 39
            $0.backgroundColor = UIColor(hex: 0xF8F7F4)
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.486, green: 0.486, blue: 0.486, alpha: 1).cgColor
        }
        
        exclAddButton.do {
            $0.attributedText = atrString
            $0.textAlignment = .center
            $0.font = .KoreanCaption2
            $0.tintColor = .TextSecondary
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(self.tapAddExclItem)
        }
        
        saveButton.do {
            $0.setTitle("수정하기", for: .normal)
            $0.applyStyle(style: .primaryPear, shape: .rounded)
            $0.buttonState.accept(true)
        }
        
        delButton.do {
            $0.attributedText = atrString2
            $0.textAlignment = .center
            $0.font = .KoreanButtonText
            $0.textColor = .TextSecondary
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(self.tapDelBtn)
        }
        
    }
    
    func setLayout() {
        
        [header, titleStackView, totalAmountStack, memberStack, tableHeaderLabel,tableView, exclAddButton, saveButton, delButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(25)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        totalAmountStack.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleStackView)
        }
        
        memberStack.snp.makeConstraints {
            $0.top.equalTo(totalAmountStack.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleStackView)
        }
        
        tableHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(memberStack.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleStackView)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(tableHeaderLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleStackView)
            $0.height.equalTo(0)
        }
        
        exclAddButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleStackView)
        }
        
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleStackView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(93)
            $0.height.equalTo(48)
        }
        
        delButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleStackView)
            $0.top.equalTo(saveButton.snp.bottom).offset(29)
        }
        
    }
    
    func setBinding() {
        viewModel.itemsObservable
            .observe(on: MainScheduler.asyncInstance)
            .map { [weak self] exclItems -> [ExclItem] in
                guard let self = self else { return [] }
                self.setTableViewHeightByItems(items: exclItems)
                return exclItems
            }
            .bind(to: tableView.rx.items(cellIdentifier: "CSEditListCell", cellType: CSEditListCell.self)) { [weak self] idx, item, cell in
                guard let self = self else { return }
                
                cell.configure(item: item, index: idx, items: viewModel.itemsObservable.value)
            }
            .disposed(by: disposeBag)
        
        let input = CSEditListVM.Input(titleBtnTap: titleEditBtn.rx.tap,
                                    totalPriceTap: totalAmountEditBtn.rx.tap,
                                    memberTap: memberEditBtn.rx.tap,
                                       exclItemTap: tableView.rx.itemSelected.asControlEvent(),
                                       addExclItemTap: tapAddExclItem.rx.event,
                                    saveButtonTap: saveButton.rx.tap,
                                       delCSInfoTap: tapDelBtn.rx.event,
                                       viewWillAppear: self.rx.viewWillAppear)
        
        let output = viewModel.transform(input: input)
        
        output.titleOB
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.totalAmOb
            .drive(totalAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.membersOb
            .drive(memberLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.pushTitleEditVC
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushTitleEditViewController()
            })
            .disposed(by: disposeBag)
        
        output.pushPriceEditVC
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushTotalPriceEditViewController()})
            .disposed(by: disposeBag)
        
        output.pushMemberEditVC
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushMemberEditViewController()})
            .disposed(by: disposeBag)
        
        output.pushExclItemEditVC
            .drive(onNext: { [weak self] index in
                guard let self = self else { return }
                self.pushExclItemEditViewController(index: index)
            })
            .disposed(by: disposeBag)
        
        output.popVCinSaveBtn
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.popDelCSInfo
            .drive (onNext: { [weak self] _ in
                guard let self = self else { return }
                SplitRepository.share.deleteCSInfoAndRelatedData(csInfoIdx: csinfoIdx)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.pushExclItemAddVC
            .drive { [weak self] _ in
                guard let self = self else { return }
                let vc = ExclItemNameEditVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

    
    private func setTableViewHeightByItems(items: [ExclItem]) {
        let maxCount = 5
        let itemCount = min(items.count, maxCount)
        let cellHeight = 39
        let tableViewHeight = itemCount * cellHeight

        self.tableView.snp.updateConstraints {
            $0.height.equalTo(tableViewHeight)
        }
    }
}


// MARK: CSEditListView/Navigation-PUSH
extension CSEditListVC {
    private func pushTitleEditViewController() {
        let vc = CSTitleEditVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushTotalPriceEditViewController() {
        let vc = CSTotalAmountEditVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushMemberEditViewController() {
        let vc = CSMemberEditVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushExclItemEditViewController(index: IndexPath) {
        let vc = ExclItemNameEditVC(index: index)
        navigationController?.pushViewController(vc, animated: true)
    }
}


func setStackView(titleBtn: UIButton, st: String, view: UILabel) -> UIStackView {
    let titleLB = UILabel()
    titleLB.do {
        $0.text = st
        $0.textColor = .TextSecondary
        $0.font = .KoreanCaption2
    }
    
    titleBtn.do {
        $0.setTitle("수정하기", for: .normal)
        $0.tintColor = .TextSecondary
        $0.titleLabel?.font = .KoreanCaption2
        $0.titleLabel?.textAlignment = .left
    }
    
    let roundView = UIView(frame: .zero)
    roundView.do {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.486, green: 0.486, blue: 0.486, alpha: 1).cgColor
    }
    
    view.font = .KoreanCaption1
    view.textColor = .TextPrimary
    
    [view, titleBtn].forEach {
        roundView.addSubview($0)
    }
    
    view.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(16)
        $0.centerY.equalToSuperview()
    }
    
    titleBtn.snp.makeConstraints {
        $0.trailing.equalToSuperview().inset(16)
        $0.centerY.equalToSuperview()
    }
    
    roundView.snp.makeConstraints {
        $0.height.equalTo(43)
    }
    
    let titleStackView = UIStackView(arrangedSubviews: [titleLB,roundView])
    titleStackView.do {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    return titleStackView
}

