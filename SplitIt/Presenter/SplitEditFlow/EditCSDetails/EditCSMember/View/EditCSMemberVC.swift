//
//  CSMemberVC.swift
//  SplitIt
//
//  Created by 주환 on 2023/11/13.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxAppState
import Reusable

final class EditCSMemberVC: UIViewController, Reusable, SPAlertDelegate {
    let disposeBag = DisposeBag()
    let viewModel = EditCSMemberVM()
    
    let header = SPNavigationBar()
    let addLabel = UILabel()
    let verticalBar = UILabel()
    let memberCount = UILabel()
    let addCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let lineView = UIView()
    let searchTextFieldLabel = UILabel()
    let searchTextField = SPTextField()
    let textCountVerticalBar = UILabel()
    let textCount = UILabel()
    let addButton = UIButton()
    let searchView = UIView()
    let searchLabel = UILabel()
    let searchTableView = UITableView(frame: .zero)
    let backAlert = SPAlertController()
    
    let backgroundView = CSMemberEmptyBackGroundView()
    
    // searchTextField delegate에서 인지해서 신호를 보내주기 위한 Relay
    // return키를 눌렀을 때만 endEditing이 동작하지 않도록 하기 위함
    let searchTextFieldReturnKeyTapped = PublishRelay<Void>()
    
    var selectedMemberArr: [MemberCheck] = []
    
    let backLeftEdgePanGesture = UIScreenEdgePanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextField.resignFirstResponder()
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .editCSMember, vc: self)
        }
        
        addLabel.do {
            $0.text = "함께한 멤버"
            $0.font = .KoreanCaption1
            $0.textColor = .TextPrimary
        }
        
        verticalBar.do {
            $0.text = "|"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        memberCount.do {
            $0.font = .KoreanCaption2
            $0.textColor = .TextSecondary
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
        
        textCountVerticalBar.do {
            $0.text = "|"
            $0.font = .KoreanBody
            $0.textColor = .TextSecondary
        }
        
        textCount.do {
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
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
            $0.backgroundColor = .SurfaceBrandWatermelon
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
        
        backLeftEdgePanGesture.do {
            $0.edges = .left
        }
    }
    
    private func setLayout() {
        [header,addLabel,verticalBar,memberCount,addCollectionView,lineView,searchTextFieldLabel,textCountVerticalBar,textCount,searchTextField,addButton,searchView,backgroundView].forEach {
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
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(38)
        }
        
        verticalBar.snp.makeConstraints {
            $0.centerY.equalTo(addLabel)
            $0.leading.equalTo(addLabel.snp.trailing).offset(4)
        }
        
        memberCount.snp.makeConstraints {
            $0.centerY.equalTo(addLabel)
            $0.leading.equalTo(verticalBar.snp.trailing).offset(4)
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
        
        textCountVerticalBar.snp.makeConstraints {
            $0.centerY.equalTo(searchTextFieldLabel)
            $0.leading.equalTo(searchTextFieldLabel.snp.trailing).offset(4)
        }
         
        textCount.snp.makeConstraints {
            $0.centerY.equalTo(searchTextFieldLabel)
            $0.leading.equalTo(textCountVerticalBar.snp.trailing).offset(4)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-27)
        }
        
        searchLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(searchTableView)
            $0.height.equalTo(80)
        }
    }
    
    private func setBinding() {
        let swipeBackLeftSideObservable = backLeftEdgePanGesture.rx.event
            .when(.recognized)
        
        let input = EditCSMemberVM.Input(viewWillAppear: self.rx.viewWillAppear,
                                            textFieldValue: searchTextField.rx.text.orEmpty.asDriver(),
                                            textFieldReturnKeyTapped: searchTextFieldReturnKeyTapped,
                                            searchCellTapped: searchTableView.rx.itemSelected,
                                            selectedCellTapped: addCollectionView.rx.itemSelected,
                                            backButtonTapped: header.leftButton.rx.tap,
                                            addButtonTapped: addButton.rx.tap,
                                            saveButtonTapped: header.rightButton.rx.tap,
                                            swipeBack: swipeBackLeftSideObservable)
        let output = viewModel.transform(input: input)
        
        output.searchMemberArr
            .bind(to: searchTableView.rx.items(cellIdentifier: "CSMemberSearchCell")) { _, item, cell in
                if let cell = cell as? CSMemberSearchCell {
                    cell.configure(item: item)
                    if item.isCheck {
                        cell.contentView.backgroundColor = .SurfaceBrandWatermelon
                    }
                    
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
        
        output.textCount
            .asDriver()
            .drive(textCount.rx.text)
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
                    cell.xMark.do {
                        $0.image = UIImage(named: "DeleteIconTypeE")
//                        $0.backgroundColor = .SurfaceBrandWatermelon
//                        $0.layer.cornerRadius = 9
                    }
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
                self.header.buttonState.accept(buttonState)
                
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
        
//        Driver.just(true)
//            .drive(header.buttonState)
//            .disposed(by: disposeBag)
        
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
                SplitRepository.share.editCSMemberAndExclMember()
                self.sendConfirmToastMessage()
            })
            .disposed(by: disposeBag)
        
        output.isEdited
            .asDriver()
            .drive(onNext: { [weak self] isEdited in
                guard let self = self else { return }
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = !isEdited
                
                if isEdited {
                    view.addGestureRecognizer(self.backLeftEdgePanGesture)
                } else {
                    view.removeGestureRecognizer(self.backLeftEdgePanGesture)
                }
            })
            .disposed(by: disposeBag)
        
        output.showBackAlert
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if output.isEdited.value {
                    self.showAlert(view: self.backAlert,
                                   type: .warnNormal,
                                   title: "수정을 중단하시겠어요?",
                                   descriptions: "지금까지 수정하신 내역이 사라져요",
                                   leftButtonTitle: "취 소",
                                   rightButtonTitle: "중단하기")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        backAlert.rightButtonTapSubject
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension EditCSMemberVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = selectedMemberArr[indexPath.item]
        let dynamicWidth = CSMemberSelectedCell().calculateCellWidth(item: item)
        return CGSize(width: dynamicWidth, height: collectionView.frame.height)
    }
}

extension EditCSMemberVC: UISearchTextFieldDelegate {
    // searchTextField에서 returnKey를 탭했을 때 인지해서 신호만 보내줌
    // 이때는 endEditing이 동작하지 않도록 하기 위함
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextFieldReturnKeyTapped.accept(())
        return false
    }
}

extension EditCSMemberVC {
    func sendConfirmToastMessage() {
        NotificationCenter.default.post(name: Notification.Name("ToeastMessage"), object: nil)
    }
}
