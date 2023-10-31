//
//  ExclItemInfoModalVC.swift
//  SplitIt
//
//  Created by 홍승완 on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxDataSources

class ExclItemInfoModalVC: UIViewController, UIScrollViewDelegate {
    
    var disposeBag = DisposeBag()
    
    let viewModel = ExclItemInfoModalVM()
    
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView()
    let titleMessage = UILabel()
    let titleTextFiled = SPTextField()
    let textFiledCounter = UILabel()

    let totalAmountTitleMessage = UILabel()
    let totalAmountTextFiled = SPTextField()
    
    let exclMemberMessage = UILabel()
    let tableView = UITableView()
    
    let nextButton = NewSPButton()
    
    let tapGesture = UITapGestureRecognizer()
    
    var dataSource: RxTableViewSectionedReloadDataSource<ExclItemInfoModalSection>!
    
    let cellHeight: CGFloat = 32.0
    let tableInset: CGFloat = 12.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
        setGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyboardNotification()
        titleTextFiled.becomeFirstResponder()
    }
    
    func setGestureRecognizer() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        titleMessage.do {
            $0.text = "어떤 정산에서 제외해야하나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextDeactivate
        }
        
        titleTextFiled.do {
            $0.font = .KoreanCaption1
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.returnKeyType = .next
            self.titleTextFiled.applyStyle(.editingDidEndNormal)
            $0.placeholder = "ex) 술, 삽겹살, 마라샹궈, 오이냉국"
        }
        
        textFiledCounter.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextDeactivate
        }
        
        totalAmountTitleMessage.do {
            $0.text = "해당 항목은 총 얼마였나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextDeactivate
        }
        
        totalAmountTextFiled.do {
            $0.applyStyle(.editingDidEndNumber)
            $0.font = .KoreanSubtitle
            $0.textColor = .TextDeactivate
        }

        exclMemberMessage.do {
            $0.text = "제외할 분들을 선택하세요"
            $0.font = .KoreanBody
            $0.textColor = .TextDeactivate
        }
        
        setTableView()
        
        nextButton.do {
            $0.setTitle("추가하기", for: .normal)
            $0.applyStyle(style: .primaryWatermelon, shape: .rounded)
        }
    }
    
    func setTableView() {
        let cellInset: CGFloat = 4.0 + 4.0
        let rowHeight: CGFloat = cellHeight + cellInset
        tableView.do {
            $0.register(cellType: ExclItemInfoModalCell.self)
            $0.register(cellType: ExclItemInfoDeactiveModalCell.self)
            $0.backgroundColor = .SurfacePrimary
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.rowHeight = rowHeight
            $0.separatorStyle = .none
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8.0
            $0.contentInset = UIEdgeInsets(top: tableInset,
                                           left: 0.0,
                                           bottom: tableInset,
                                           right: 0.0)
            tableView.rx.setDelegate(self)
                .disposed(by: disposeBag)
            
            dataSource = RxTableViewSectionedReloadDataSource<ExclItemInfoModalSection>(configureCell: { dataSource, tableView, indexPath, item in
                let section = dataSource.sectionModels[indexPath.section]
                let item = section.items[indexPath.row]

                if section.isActive {
                    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ExclItemInfoModalCell.self)
                    cell.configure(item: item)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ExclItemInfoDeactiveModalCell.self)
                    cell.configure(item: item)
                    return cell
                }
            })
        }
    }
    
    func setLayout() {
        [scrollView].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(contentView)
        
        [titleMessage, titleTextFiled, textFiledCounter, nextButton, totalAmountTitleMessage, totalAmountTextFiled, exclMemberMessage, tableView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView)
            $0.width.height.equalTo(scrollView)
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(8)
        }
        
        titleTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        textFiledCounter.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(8)
            $0.trailing.equalTo(titleTextFiled.snp.trailing).inset(6)
        }
        
        totalAmountTitleMessage.snp.makeConstraints {
            $0.top.equalTo(textFiledCounter.snp.bottom).offset(24)
            $0.leading.equalTo(titleMessage.snp.leading).inset(8)
        }
        
        totalAmountTextFiled.snp.makeConstraints {
            $0.top.equalTo(totalAmountTitleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        exclMemberMessage.snp.makeConstraints {
            $0.top.equalTo(totalAmountTextFiled.snp.bottom).offset(24)
            $0.leading.equalTo(titleMessage.snp.leading).inset(8)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(exclMemberMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

    }
    
    func setBinding() {
        let titleTFDidEnd =  titleTextFiled.rx.controlEvent(.editingDidEnd)
        let titleTFEvent = Observable.merge(
            titleTextFiled.rx.controlEvent(.editingDidBegin).map { UIControl.Event.editingDidBegin},
            titleTFDidEnd.map { UIControl.Event.editingDidEnd },
            titleTextFiled.rx.controlEvent(.editingDidEndOnExit).map { UIControl.Event.editingDidEndOnExit })
        
        let totalAmountTFEvent = Observable.merge(
            totalAmountTextFiled.rx.controlEvent(.editingDidBegin).map { UIControl.Event.editingDidBegin},
            totalAmountTextFiled.rx.controlEvent(.editingDidEnd).map { UIControl.Event.editingDidEnd })
        
        let input = ExclItemInfoModalVM.Input(nextButtonTapped: nextButton.rx.tap,
                                   title: titleTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""),
                                   totalAmount: totalAmountTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""),
                                   titleTextFieldControlEvent: titleTFEvent,
                                   totalAmountTextFieldControlEvent: totalAmountTFEvent
        )
        let output = viewModel.transform(input: input)
        
        output.addExclItem
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.titleCount
            .drive(textFiledCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.textFiledCounter.textColor = isValid
                ? .TextSecondary
                : .AppColorStatusError
            })
            .disposed(by: disposeBag)
        
        output.textFieldIsValid
            .map { [weak self] isValid -> String in
                guard let self = self else { return "" }
                if !isValid {
                    return String(self.titleTextFiled.text?.prefix(self.viewModel.maxTextCount) ?? "")
                } else {
                    return self.titleTextFiled.text ?? ""
                }
            }
            .drive(titleTextFiled.rx.text)
            .disposed(by: disposeBag)
        
        output.totalAmount
            .drive(totalAmountTextFiled.rx.text)
            .disposed(by: disposeBag)
        
        output.nextButtonIsEnable
            .drive(nextButton.buttonState)
            .disposed(by: disposeBag)
        
        output.titleTextFieldControlEvent
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .editingDidBegin:
                    focusTitleTF()
                    unfocusTotalAmountTF()
                    unfocusExclMember()
                case .editingDidEnd:
                    focusTotalAmountTF()
                    unfocusTitleTF()
                    unfocusExclMember()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        output.totalAmountTextFieldControlEvent
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .editingDidBegin:
                    focusTotalAmountTF()
                    unfocusTitleTF()
                    unfocusExclMember()
                case .editingDidEnd:
                    unfocusTotalAmountTF()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.sections
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

//        viewModel.exclMembers
//            .asDriver()
//            .drive(onNext: { [weak self] items in
//                guard let self = self else { return }
//                print(contentView.frame)
//                print(tableView.frame)
//                let tableInset = Int(self.tableInset)
//                let cellHeight = Int(self.cellHeight)
//                let tableViewHeight = items.count * (cellHeight + 8) + (tableInset * 2)
//                // MARK: tableView Height
//                self.contentView.snp.updateConstraints {
//                    $0.height.equalTo(tableViewHeight + 320 + 120)
//                }
//                self.tableView.snp.updateConstraints {
//                    $0.height.equalTo(tableViewHeight)
//                }
//                print(contentView.frame)
//                print(tableView.frame)
//                UIView.animate(withDuration: 0.33) {
//                    self.view.layoutIfNeeded()
//                }
//
//            })
//            .disposed(by: disposeBag)
        
        
        let isTitleTextFieldActive = BehaviorRelay<Bool>(value: false)
        let isTotalAmountTextFieldActive = BehaviorRelay<Bool>(value: false)

        titleTextFiled.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { _ in
                isTitleTextFieldActive.accept(true)
            })
            .disposed(by: disposeBag)

        titleTextFiled.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { _ in
                isTitleTextFieldActive.accept(false)
            })
            .disposed(by: disposeBag)

        totalAmountTextFiled.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { _ in
                isTotalAmountTextFieldActive.accept(true)
            })
            .disposed(by: disposeBag)

        totalAmountTextFiled.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { _ in
                isTotalAmountTextFieldActive.accept(false)
            })
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .asControlEvent()
            .filter { [weak self] gesture in
                guard let self = self else { return false }
                if isTitleTextFieldActive.value || isTotalAmountTextFieldActive.value {
                    return true
                }
                let location = gesture.location(in: self.tableView)
                return self.tableView.point(inside: location, with: nil) == false
            }
            .subscribe(onNext: { [weak self] gesture in
                guard let self = self else { return }
                titleTextFiled.endEditing(true)
                totalAmountTextFiled.endEditing(true)
                unfocusTitleTF()
                unfocusTotalAmountTF()
                focusExclMember()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                var sections = viewModel.sections.value

                var target = sections[indexPath.section].items[indexPath.row]
                target.isTarget.toggle()
                sections[indexPath.section].items[indexPath.row] = target
                viewModel.sections.accept(sections)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: TextField (활성화/비활성화)에 따른 UI 로직
extension ExclItemInfoModalVC {
    func focusExclMember() {
        UIView.animate(withDuration: 0.33) {
            self.tableView.layer.borderColor = UIColor.BorderPrimary.cgColor
            self.tableView.backgroundColor = .SurfaceDeactivate
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.exclMemberMessage.textColor = .TextPrimary
        }
        
        var sections = viewModel.sections.value
        sections[0].isActive = true
        viewModel.sections.accept(sections)
    }
    
    func unfocusExclMember() {
        UIView.animate(withDuration: 0.33) {
            self.tableView.layer.borderColor = UIColor.BorderDeactivate.cgColor
            self.tableView.backgroundColor = .SurfacePrimary
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.exclMemberMessage.textColor = .TextDeactivate
        }
        
        var sections = viewModel.sections.value
        sections[0].isActive = false
        viewModel.sections.accept(sections)
    }
    
    func focusTitleTF() {
        self.titleTextFiled.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.33) {
            self.titleTextFiled.applyStyle(.editingDidBeginNormal)
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.titleMessage.textColor = .TextPrimary
            self.titleTextFiled.textColor = .TextPrimary
            self.textFiledCounter.textColor = .TextSecondary
        }
        
        view.layoutIfNeeded()
    }
    
    func unfocusTitleTF() {
        self.titleTextFiled.applyStyle(.editingDidEndNormal)
        
        self.titleMessage.textColor = .TextDeactivate
        self.titleTextFiled.textColor = .TextDeactivate
        self.textFiledCounter.textColor = .TextDeactivate
    }
    
    func focusTotalAmountTF() {
        self.totalAmountTextFiled.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.33) {
            self.totalAmountTextFiled.applyStyle(.editingDidBeginNumber)
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.totalAmountTitleMessage.textColor = .TextPrimary
            self.totalAmountTextFiled.textColor = .TextPrimary
            self.totalAmountTextFiled.currencyLabel.textColor = .TextPrimary
        }
        
        view.layoutIfNeeded()
    }
    
    func unfocusTotalAmountTF() {
        self.totalAmountTextFiled.applyStyle(.editingDidEndNumber)
        
        self.totalAmountTitleMessage.textColor = .TextDeactivate
        self.totalAmountTextFiled.textColor = .TextDeactivate
        self.totalAmountTextFiled.currencyLabel.textColor = .TextDeactivate
    }
}

extension ExclItemInfoModalVC: UITextFieldDelegate {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.scrollView.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight)
            }
        }
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide() {
        self.scrollView.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
