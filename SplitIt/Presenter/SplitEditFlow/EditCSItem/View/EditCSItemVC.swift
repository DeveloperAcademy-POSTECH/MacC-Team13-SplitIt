//
//  EditCSListView.swift
//  SplitIt
//
//  Created by 주환 on 2023/10/31.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import Reusable
import Toast

class EditCSItemVC: UIViewController, SPAlertDelegate {
    
    var disposeBag = DisposeBag()
    
    let viewModel: EditCSItemVM
    
    let headerView = SPNavigationBar()
    let titleLabel = UILabel()
    let totalAmountLabel = UILabel()
    let titlePriceEditBtn = DefaultEditButton()
    let titlePriceTap = UITapGestureRecognizer()
    let subtitle = UILabel()
    let titleView = UIView()
    let memberLabel = UILabel()
    let memberEditBtn = DefaultEditButton()
    let memberTap = UITapGestureRecognizer()
    let subMember = UILabel()
    let memberView = UIView()
    let exclLabel = UILabel()
    let exclEditBtn = DefaultEditButton()
    let exclTap = UITapGestureRecognizer()
    let subExcl = UILabel()
    let exclView = UIView()
    let delButton = UILabel()
    let delBtnTap = UITapGestureRecognizer()
    let alert = SPAlertController()
    
    init(csinfoIdx: String) {
        self.disposeBag = DisposeBag()
        self.viewModel = EditCSItemVM(csinfoIdx: csinfoIdx)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SplitRepository.share.fetchCSInfoArrFromDBWithCSInfoIdx(csInfoIdx: viewModel.csInfoIdx)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setAttribute() {
        view.backgroundColor = .SurfaceBrandCalmshell
        
        let atrString = NSMutableAttributedString(string: "이 차수 삭제하기")
        atrString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: atrString.length))
        
        headerView.do {
            $0.applyStyle(style: .csEdit, vc: self)
        }
        
        subtitle.do {
            $0.text = "이름 및 총액"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        titleLabel.do {
            $0.textColor = .TextPrimary
            $0.font = .KoreanTitle3
        }
        
        titleView.do {
            $0.addSubview(titleLabel)
            $0.addSubview(totalAmountLabel)
            $0.addSubview(titlePriceEditBtn)
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            $0.backgroundColor = .SurfaceWhite
            $0.addGestureRecognizer(titlePriceTap)
        }
        
        subMember.do {
            $0.text = "함께한 멤버"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        memberView.do {
            $0.addSubview(memberLabel)
            $0.addSubview(memberEditBtn)
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            $0.backgroundColor = .SurfaceWhite
            $0.addGestureRecognizer(memberTap)
        }
        
        subExcl.do {
            $0.text = "따로 정산 항목"
            $0.font = .KoreanCaption1
            $0.textColor = .TextSecondary
        }
        
        exclView.do {
            $0.addSubview(exclLabel)
            $0.addSubview(exclEditBtn)
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.BorderSecondary.cgColor
            $0.backgroundColor = .SurfaceWhite
            $0.addGestureRecognizer(exclTap)
        }
        
        delButton.do {
            $0.attributedText = atrString
            $0.textAlignment = .center
            $0.font = .KoreanButtonText
            $0.textColor = .SurfaceWarnRed
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(self.delBtnTap)
        }
    }
    
    func setLayout() {

        [headerView, subtitle, titleView, subMember, memberView, subExcl, exclView, delButton].forEach {
            view.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        subtitle.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(36)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titleView).inset(12)
            $0.leading.equalTo(titleView).inset(16)
        }
        
        totalAmountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9.5)
            $0.leading.equalTo(titleLabel)
        }
        
        titlePriceEditBtn.snp.makeConstraints {
            $0.top.equalTo(totalAmountLabel)
            $0.trailing.equalTo(titleView).inset(16)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(subtitle.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(81)
        }
        
        subMember.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(16)
            $0.leading.equalTo(subtitle)
        }
        
        memberView.snp.makeConstraints {
            $0.top.equalTo(subMember.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleView)
            $0.height.equalTo(43)
        }
        
        memberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        memberEditBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        subExcl.snp.makeConstraints {
            $0.top.equalTo(memberView.snp.bottom).offset(16)
            $0.leading.equalTo(subtitle)
        }
        
        exclView.snp.makeConstraints {
            $0.top.equalTo(subExcl.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleView)
            $0.height.equalTo(43)
        }
        
        exclLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        exclEditBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        delButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
    }
    
    func setBinding() {
        let input = EditCSItemVM.Input(viewDidAppear: self.rx.viewDidAppear,
                                       titlePriceEditTapped: titlePriceTap.rx.event,
                                       memberEditTapped: memberTap.rx.event,
                                       exclItemEditTapped: exclTap.rx.event,
                                       delButtonTapped: delBtnTap.rx.event)
        
        let output = viewModel.transform(input: input)
        
        Driver.just(true)
            .drive(headerView.buttonState)
            .disposed(by: disposeBag)
        
        output.csTitle
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.csTotalAmount
            .drive(onNext: { [weak self] attriString in
                guard let self = self else { return }
                self.totalAmountLabel.attributedText = attriString
            })
            .disposed(by: disposeBag)
        
        output.csMember
            .drive(onNext: { [weak self] attriString in
                guard let self = self else { return }
                self.memberLabel.attributedText = attriString
            })
            .disposed(by: disposeBag)
        
        output.csExclItemString
            .drive(onNext: { [weak self] attriString in
                guard let self = self else { return }
                self.exclLabel.attributedText = attriString
            })
            .disposed(by: disposeBag)
        
        output.pushCSEditTitlePriceView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vc = EditCSInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.pushCSMemberEditView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vc = EditCSMemberVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.pushCSExclItemEditView
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vc = EditExclItemInputVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.popDeleteCSInfo
            .drive(onNext: { [weak self]_ in
                guard let self = self else { return }
                showAlert(view: self.alert,
                          type: .warnWithItem(item: self.titleLabel.text ?? ""),
                          title: "차수를 삭제할까요?",
                          descriptions: "이 작업은 돌이킬 수 없어요",
                          leftButtonTitle: "취 소",
                          rightButtonTitle: "삭제하기")
            })
            .disposed(by: disposeBag)
        
        output.deleteBtnHidden
            .drive(delButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        headerView.leftButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        alert.rightButtonTapSubject
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                SplitRepository.share.deleteCSInfoAndRelatedData(csInfoIdx: self.viewModel.csInfoIdx)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        headerView.rightButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.viewControllers.forEach {
                    if let vc = $0 as? SplitShareVC {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedToeastMessage), name: Notification.Name("ToeastMessage"), object: nil)
        
    }
}

extension EditCSItemVC {
    @objc func receivedToeastMessage() {
        var style = ToastStyle()
        style.messageFont = .KoreanCaption1
        self.view.makeToast("  ✓  수정 완료되었습니다!  ", duration: 3.0, position: .bottom, style: style)
    }
}
