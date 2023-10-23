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

final class CSEditListVC: UIViewController {
    
    weak var pageChangeDelegate: CSMemberPageChangeDelegate?
    
    var disposeBag = DisposeBag()
    let viewModel = CSEditListVM()
    
    let header = NaviHeader()
    let titleEditBtn = UIButton(type: .system)
    let titleLabel = UILabel()
    lazy var titleStackView: UIStackView = {
        return setStackView(titleBtn: titleEditBtn ,
                            st: "이름",
                            view: titleLabel)
    }()
    let totalAmountEditBtn = UIButton(type: .system)
    let totalAmountLabel = UILabel()
    lazy var totalAmountStack: UIStackView = {
        return setStackView(titleBtn: totalAmountEditBtn ,
                            st: "사용한 총액",
                            view: totalAmountLabel)
    }()
    let memberEditBtn = UIButton(type: .system)
    let memberLabel = UILabel()
    lazy var memberStack: UIStackView = {
        return setStackView(titleBtn: memberEditBtn ,
                            st: "함께한 사람들",
                            view: memberLabel)
    }()
    
    let tableHeaderLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    let exclAddButton = UILabel()
    let saveButton = SPButton()
    let delButton = UILabel()
    let tapDelBtn = UITapGestureRecognizer()
    let tapAddExclItem = UITapGestureRecognizer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    func setAttribute() {
        view.backgroundColor = UIColor(hex: 0xF8F7F4)
        
        header.do {
            $0.applyStyle(.edit)
        }
        
        tableHeaderLabel.do { label in
            label.text = "따로 계산할 것"
            label.textColor = .TextSecondary
            label.font = .KoreanCaption2
        }
        
        tableView.do { view in
            view.register(cellType: CSEditListCell.self)
            view.rowHeight = UITableView.automaticDimension
            view.estimatedRowHeight = 42
            view.isScrollEnabled = false
            view.backgroundColor = UIColor(hex: 0xF8F7F4)
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(red: 0.486, green: 0.486, blue: 0.486, alpha: 1).cgColor
        }
        
        let atrString = NSMutableAttributedString(string: "따로 계산할 것 추가하기")
        atrString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: atrString.length))
        
        exclAddButton.do { btn in
            btn.attributedText = atrString
            btn.textAlignment = .center
            btn.font = .KoreanCaption2
            btn.tintColor = .TextSecondary
            btn.isUserInteractionEnabled = true
            btn.addGestureRecognizer(self.tapAddExclItem)
        }
        
        saveButton.do { btn in
            btn.setTitle("수정하기", for: .normal)
            btn.applyStyle(.primaryPear)
        }
        
        let atrString2 = NSMutableAttributedString(string: "삭제하기")
        atrString2.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: atrString2.length))
        
        delButton.do { btn in
            btn.attributedText = atrString2
            btn.textAlignment = .center
            btn.font = .KoreanButtonText
            btn.textColor = .TextSecondary
            btn.isUserInteractionEnabled = true
            btn.addGestureRecognizer(self.tapDelBtn)
        }
        
    }
    
    func setLayout() {
        
        [header, titleStackView, totalAmountStack, memberStack, tableHeaderLabel,tableView, exclAddButton, saveButton, delButton].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(25)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        totalAmountStack.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        memberStack.snp.makeConstraints { make in
            make.top.equalTo(totalAmountStack.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        tableHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(memberStack.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableHeaderLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleStackView)
            viewModel.itemsObservable
                .map { $0.count * 43 }
                .subscribe { int in
                    make.height.equalTo(int)
                }
                .disposed(by: disposeBag)
//            make.height.equalTo()
        }
        
        exclAddButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleStackView)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleStackView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(93)
            make.height.equalTo(48)
        }
        
        delButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleStackView)
            make.top.equalTo(saveButton.snp.bottom).offset(29)
        }
        
    }
    
    func setBinding() {
        
        viewModel.titleObservable
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalObservable
            .bind(to: totalAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.membersObservable
            .bind(to: memberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.itemsObservable
            .bind(to: tableView.rx.items(cellIdentifier: "CSEditListCell", cellType: CSEditListCell.self)) { _, item, cell in
                cell.csTitleLabel.text = "\(item.name) 값"
            }
            .disposed(by: disposeBag)
        
        let input = CSEditListVM.Input(titleBtnTap: titleEditBtn.rx.tap,
                                    totalPriceTap: totalAmountEditBtn.rx.tap,
                                    memberTap: memberEditBtn.rx.tap,
                                       exclItemTap: tableView.rx.itemSelected.asControlEvent(),
                                       addExclItemTap: tapAddExclItem.rx.event,
                                    saveButtonTap: saveButton.rx.tap,
                                       delCSInfoTap: tapDelBtn.rx.event)
        
        let output = viewModel.transform(input: input)
        
        output.pushTitleEditVC
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushTitleEditViewController()
            })
            .disposed(by: disposeBag)
        output.pushPriceEditVC
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushTotalPriceEditViewController()})
            .disposed(by: disposeBag)
        output.pushMemberEditVC
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushMemberEditViewController()})
            .disposed(by: disposeBag)
        output.pushExclItemEditVC
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.pushExclItemEditViewController(index: index)
            })
            .disposed(by: disposeBag)
        
        output.popVCinSaveBtn
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
                self.saveButton.applyStyle(.primaryPearPressed)
            }
            .disposed(by: disposeBag)
        
        output.popVCinSaveBtn
            .delay(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
           .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
               self.saveButton.applyStyle(.primaryPear)
            })
            .disposed(by: disposeBag)
        
        output.popDelCSInfo
            .subscribe (onNext: {_ in
//                SplitRepository.share.deleteCSInfoAndRelatedData(csInfoIdx: "")
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.pushExclItemAddVC
            .subscribe { [weak self] _ in
                guard let self = self else { return }
//                SplitRepository.share.currentCSInfo
                let vc = ExclEditPageController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
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
        let vc = ExclItemNameEditVC(viewModel: ExclItemNameEditVM(indexPath: index))
        navigationController?.pushViewController(vc, animated: true)
    }
}


func setStackView(titleBtn: UIButton, st: String, view: UILabel) -> UIStackView {
    let titleLB = UILabel()
    titleLB.do { label in
        label.text = st
        label.textColor = .TextSecondary
        label.font = .KoreanCaption2
    }
    
    titleBtn.do { button in
        button.setTitle("수정하기", for: .normal)
        button.tintColor = .TextSecondary
        button.titleLabel?.font = .KoreanCaption2
        button.titleLabel?.textAlignment = .left
    }
    
    let roundView = UIView(frame: .zero)
    roundView.do { view in
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.486, green: 0.486, blue: 0.486, alpha: 1).cgColor
    }
    
    view.font = .KoreanCaption1
    view.textColor = .TextPrimary
    
    [view, titleBtn].forEach { view in
        roundView.addSubview(view)
    }
    
    view.snp.makeConstraints { make in
        make.leading.equalToSuperview().inset(16)
        make.centerY.equalToSuperview()
    }
    
    titleBtn.snp.makeConstraints { make in
        make.trailing.equalToSuperview().inset(16)
        make.centerY.equalToSuperview()
    }
    
    roundView.snp.makeConstraints { make in
        make.height.equalTo(43)
    }
    
    let titleStackView = UIStackView(arrangedSubviews: [titleLB,roundView])
    titleStackView.do { stack in
        stack.axis = .vertical
        stack.spacing = 4
    }
    
    return titleStackView
}

