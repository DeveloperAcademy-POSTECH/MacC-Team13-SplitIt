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
import RxAppState

class ExclItemInfoAddModalVC: UIViewController, UIScrollViewDelegate {
    
    let inputTextRelay = BehaviorRelay<Int?>(value: 0)
    let customKeyboard = CustomKeyboard()
    
    var disposeBag = DisposeBag()
    
    let viewModel = ExclItemInfoAddModalVM()
    
    let header = SPNavigationBar()
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView()
    let titleMessage = UILabel()
    let titleTextFiled = SPTextField()
    let titleTextFiledCounter = UILabel()

    let priceTitleMessage = UILabel()
    let priceTextFiled = SPTextField()
    let priceTextFiledNotice = UILabel()
    
    let exclMemberMessage = UILabel()
    let tableView = UITableView()
    
    let tapGesture = UITapGestureRecognizer()
    
    var dataSource: RxTableViewSectionedReloadDataSource<ExclItemInfoModalSection>!
    
    let cellHeight: CGFloat = 40.0
    let tableInset: CGFloat = 12.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
        setBinding()
        setGestureRecognizer()
        textFieldCustomKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextFiled.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        titleTextFiled.resignFirstResponder()
        priceTextFiled.resignFirstResponder()
    }
    
    func setGestureRecognizer() {
        view.addGestureRecognizer(tapGesture)
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .exclItemCreateModal, vc: self)
        }
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        titleMessage.do {
            $0.text = "어떤 항목을 제외해야하나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextDeactivate
        }
        
        titleTextFiled.do {
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.returnKeyType = .next
            self.titleTextFiled.applyStyle(.editingDidEndNormal)
            $0.placeholder = "ex) 술, 삽겹살, 마라샹궈, 오이냉국"
        }
        
        titleTextFiledCounter.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextDeactivate
        }
        
        priceTitleMessage.do {
            $0.text = "해당 항목은 총 얼마였나요?"
            $0.font = .KoreanBody
            $0.textColor = .TextDeactivate
        }
        
        priceTextFiled.do {
            $0.applyStyle(.editingDidEndNumber)
            $0.textColor = .TextDeactivate
        }

        priceTextFiledNotice.do {
            $0.text = "전체 총액을 넘을 수 없어요"
            $0.font = .KoreanCaption1
            $0.textColor = .SurfaceWarnRed
            $0.isHidden = true
        }
        
        exclMemberMessage.do {
            $0.text = "정산에서 제외할 멤버를 선택하세요"
            $0.font = .KoreanBody
            $0.textColor = .TextDeactivate
        }
        
        setTableView()
    }
    
    func setTableView() {
        let cellInset: CGFloat = 4.0 + 4.0
        let rowHeight: CGFloat = cellHeight + cellInset
        tableView.do {
            $0.register(cellType: ExclItemInfoModalCell.self)
            $0.register(cellType: ExclItemInfoDeactiveModalCell.self)
            $0.backgroundColor = .SurfaceDeactivate
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.rowHeight = rowHeight
            $0.separatorStyle = .none
            $0.layer.borderColor = UIColor.BorderPrimary.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 8.0
            $0.contentInset = UIEdgeInsets(top: tableInset - 4.0,
                                           left: 0.0,
                                           bottom: tableInset - 4.0,
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
        [header, scrollView].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(contentView)
        
        [titleMessage, titleTextFiled, titleTextFiledCounter, priceTitleMessage, priceTextFiled, priceTextFiledNotice, exclMemberMessage, tableView].forEach {
            contentView.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(24)
            $0.height.equalTo(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(0)
        }
        
        titleMessage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }
        
        titleTextFiled.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        titleTextFiledCounter.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(4)
            $0.trailing.equalTo(titleTextFiled.snp.trailing).inset(6)
        }
        
        priceTitleMessage.snp.makeConstraints {
            $0.top.equalTo(titleTextFiled.snp.bottom).offset(24)
            $0.leading.equalTo(titleMessage.snp.leading)
        }
        
        priceTextFiled.snp.makeConstraints {
            $0.top.equalTo(priceTitleMessage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        priceTextFiledNotice.snp.makeConstraints {
            $0.leading.equalTo(priceTitleMessage)
            $0.top.equalTo(priceTextFiled.snp.bottom).offset(8)
        }
        
        exclMemberMessage.snp.makeConstraints {
            $0.top.equalTo(priceTextFiled.snp.bottom).offset(48)
            $0.leading.equalTo(titleMessage.snp.leading)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(exclMemberMessage.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }

    }
    
    func setBinding() {
        let titleTFDidEnd =  titleTextFiled.rx.controlEvent(.editingDidEnd)
        let titleTFEvent = Observable.merge(
            titleTextFiled.rx.controlEvent(.editingDidBegin).map { UIControl.Event.editingDidBegin},
            titleTFDidEnd.map { UIControl.Event.editingDidEnd },
            titleTextFiled.rx.controlEvent(.editingDidEndOnExit).map { UIControl.Event.editingDidEndOnExit })
        
        let priceTFEvent = Observable.merge(
            priceTextFiled.rx.controlEvent(.editingDidBegin).map { UIControl.Event.editingDidBegin},
            priceTextFiled.rx.controlEvent(.editingDidEnd).map { UIControl.Event.editingDidEnd })
        
        let input = ExclItemInfoAddModalVM.Input(viewWillAppear: self.rx.viewWillAppear,
                                                 title: titleTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""),
                                                 price: priceTextFiled.rx.text.orEmpty.asDriver(onErrorJustReturn: ""),
                                                 titleTextFieldControlEvent: titleTFEvent,
                                                 priceTextFieldControlEvent: priceTFEvent,
                                                 cancelButtonTapped: header.leftButton.rx.tap,
                                                 addButtonTapped: header.rightButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.addButtonTapped
            .drive(onNext: {
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: .exclItemIsAdded, object: nil)
                }
            })
            .disposed(by: disposeBag)
        
        output.cancelButtonTapped
            .drive(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.titleCount
            .drive(titleTextFiledCounter.rx.text)
            .disposed(by: disposeBag)
        
        output.titleTextFieldIsValid
            .asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.titleTextFiledCounter.textColor = isValid
                ? .TextSecondary
                : .AppColorStatusError
            })
            .disposed(by: disposeBag)
        
        output.titleTextFieldIsValid
            .asDriver()
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
        
        output.price
            .drive(priceTextFiled.rx.text)
            .disposed(by: disposeBag)
        
        output.addButtonIsEnable
            .drive(header.rightButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.titleTextFieldControlEvent
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .editingDidBegin:
                    focusTitleTF(output: output)
                    unfocusPriceTF()
                    unfocusExclMember()
                case .editingDidEnd:
                    focusPriceTF()
                    unfocusTitleTF()
                    unfocusExclMember()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        output.priceTextFieldControlEvent
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .editingDidBegin:
                    focusPriceTF()
                    unfocusTitleTF()
                    unfocusExclMember()
                case .editingDidEnd:
                    unfocusPriceTF()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.sections
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: 키보드 보일 때 ContentView, TableView의 Height 세팅
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let self = self else { return }
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    let keyboardHeight: CGFloat
                    keyboardHeight = keyboardSize.height
                    
                    let items = viewModel.sections.value

                    let topArea = tableView.frame.minY
                    let bottomArea = CGFloat(33.0) // bottom_offset
                    let tableInset = self.tableInset
                    let cellHeight = self.cellHeight
                    let tableViewHeight = CGFloat(items[0].items.count) * (cellHeight + 8.0) + (tableInset * 2.0)

                    self.contentView.snp.remakeConstraints {
                        $0.top.bottom.leading.trailing.equalTo(self.scrollView)
                        $0.width.equalTo(self.scrollView)
                        $0.height.equalTo(tableViewHeight + topArea + bottomArea + keyboardHeight)
                    }
                    
                    self.tableView.snp.remakeConstraints {
                        $0.top.equalTo(self.exclMemberMessage.snp.bottom).offset(12)
                        $0.leading.trailing.equalToSuperview()
                        $0.height.equalTo(tableViewHeight)
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.sections
            .asDriver()
            .drive(onNext: { [weak self] items in
                guard let self = self else { return }
                let topArea = tableView.frame.minY
                let bottomArea = CGFloat(33.0) // bottom_offset
                let tableInset = self.tableInset
                let cellHeight = self.cellHeight
                let tableViewHeight = CGFloat(items[0].items.count) * (cellHeight + 8.0) + (tableInset * 2.0)

                self.contentView.snp.remakeConstraints {
                    $0.top.bottom.leading.trailing.equalTo(self.scrollView)
                    $0.width.equalTo(self.scrollView)
                    $0.height.equalTo(tableViewHeight + topArea + bottomArea)
                }
                
                self.tableView.snp.remakeConstraints {
                    $0.top.equalTo(self.exclMemberMessage.snp.bottom).offset(12)
                    $0.leading.trailing.equalToSuperview()
                    $0.height.equalTo(tableViewHeight)
                }
            })
            .disposed(by: disposeBag)
        
        let isTitleTextFieldActive = BehaviorRelay<Bool>(value: false)
        let isPriceTextFieldActive = BehaviorRelay<Bool>(value: false)

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

        priceTextFiled.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { _ in
                isPriceTextFieldActive.accept(true)
            })
            .disposed(by: disposeBag)

        priceTextFiled.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { _ in
                isPriceTextFieldActive.accept(false)
            })
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .asControlEvent()
            .filter { [weak self] gesture in
                guard let self = self else { return false }
                if isTitleTextFieldActive.value || isPriceTextFieldActive.value {
                    tapGesture.cancelsTouchesInView = true
                    return true
                }
                let location = gesture.location(in: self.tableView)
                tapGesture.cancelsTouchesInView = false
                return self.tableView.point(inside: location, with: nil) == false
            }
            .subscribe(onNext: { [weak self] gesture in
                guard let self = self else { return }
                titleTextFiled.endEditing(true)
                priceTextFiled.endEditing(true)
                unfocusTitleTF()
                unfocusPriceTF()
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
        
        output.priceIsLimited
            .drive(onNext: { [weak self] isLimited in
                guard let self = self else { return }
                UIView.transition(with: self.priceTextFiledNotice, duration: 0.33, options: .transitionCrossDissolve) {
                    self.priceTextFiledNotice.isHidden = !isLimited
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: TextField (활성화/비활성화)에 따른 UI 로직
extension ExclItemInfoAddModalVC {
    func focusExclMember() {
        UIView.animate(withDuration: 0.33) {
            self.tableView.layer.borderColor = UIColor.BorderPrimary.cgColor
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.exclMemberMessage.textColor = .TextPrimary
            self.priceTextFiledNotice.isHidden = true
        }
        
        var sections = viewModel.sections.value
        sections[0].isActive = true
        viewModel.sections.accept(sections)
    }
    
    func unfocusExclMember() {
        UIView.animate(withDuration: 0.33) {
            self.tableView.layer.borderColor = UIColor.BorderDeactivate.cgColor
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.exclMemberMessage.textColor = .TextDeactivate
        }
        
        var sections = viewModel.sections.value
        sections[0].isActive = false
        viewModel.sections.accept(sections)
    }
    
    func focusTitleTF(output: ExclItemInfoAddModalVM.Output) {
        self.titleTextFiled.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.33) {
            self.titleTextFiled.applyStyle(.editingDidBeginNormal)
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.titleMessage.textColor = .TextPrimary
            self.titleTextFiled.textColor = .TextPrimary
            
            self.priceTextFiledNotice.isHidden = true
            self.titleTextFiledCounter.textColor = output.titleTextFieldIsValid.value
            ? .TextSecondary
            : .AppColorStatusError
        }
        
        view.layoutIfNeeded()
    }
    
    func unfocusTitleTF() {
        self.titleTextFiled.applyStyle(.editingDidEndNormal)
        
        self.titleMessage.textColor = .TextDeactivate
        self.titleTextFiled.textColor = .TextDeactivate
        self.titleTextFiledCounter.textColor = .TextDeactivate
    }
    
    func focusPriceTF() {
        self.priceTextFiled.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.33) {
            self.priceTextFiled.applyStyle(.editingDidBeginNumber)
        }
        
        UIView.transition(with: self.contentView, duration: 0.33, options: .transitionCrossDissolve) {
            self.priceTitleMessage.textColor = .TextPrimary
            self.priceTextFiled.textColor = .TextPrimary
            self.priceTextFiled.currencyLabel.textColor = .TextPrimary
        }
        
        view.layoutIfNeeded()
    }
    
    func unfocusPriceTF() {
        self.priceTextFiled.applyStyle(.editingDidEndNumber)
        
        self.priceTitleMessage.textColor = .TextDeactivate
        self.priceTextFiled.textColor = .TextDeactivate
        self.priceTextFiled.currencyLabel.textColor = .TextDeactivate
    }
}

extension ExclItemInfoAddModalVC: CustomKeyboardDelegate {
    func textFieldCustomKeyboard() {
        priceTextFiled.inputView = customKeyboard.inputView
        customKeyboard.delegate = self
        customKeyboard.setCurrentTextField(priceTextFiled)
        customKeyboard.customKeyObservable
            .subscribe(onNext: { [weak self] value in
                self?.customKeyboard.handleInputValue(value)
                self?.inputTextRelay.accept(Int(self?.priceTextFiled.text ?? ""))
            })
            .disposed(by: disposeBag)
    }
}
