//
//  SplitMethodSelectVC.swift
//  SplitIt
//
//  Created by Zerom on 2023/10/31.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Reusable

class SplitMethodSelectVC: UIViewController, Reusable {
    
    let disposeBag = DisposeBag()
    
    let viewModel = SplitMethodSelectVM()
    
    let header = SPNavigationBar()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttribute()
        setLayout()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        UserDefaults.standard.set("Create", forKey: "ShareFlow")
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .selectSplitMethod, vc: self)
        }
        
        titleLabel.do {
            $0.font = .KoreanLightTitle1
            $0.textColor = .AppColorGrayscale1000
        }
        
        subTitleLabel.do {
            $0.text = "정산 방식을 선택해주세요"
            $0.font = .KoreanLightBody
            $0.textColor = .TextSecondary
        }
        
        setCollectionView()
    }
    
    private func setCollectionView() {
        collectionView.do {
            $0.collectionViewLayout = UICollectionViewFlowLayout()
            $0.register(cellType: SplitMethodCell.self)
            $0.backgroundColor = .SurfaceBrandCalmshell
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
            $0.delaysContentTouches = false
        }
    }
    
    private func setLayout() {
        [header, titleLabel, subTitleLabel, collectionView].forEach {
            view.addSubview($0)
        }
        
        header.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(38)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setBinding() {
        let input = SplitMethodSelectVM.Input(methodBtnTapped: collectionView.rx.itemSelected)
        let output = viewModel.transform(input: input)
        
        output
            .csInfoCount
            .map{"\($0) 정산"}
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.methodList
            .bind(to: collectionView.rx.items(cellIdentifier: SplitMethodCell.reuseIdentifier)) { indexPath, item, cell in
                guard let cell = cell as? SplitMethodCell else { return }
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        output.showMethodTapped
            .asDriver()
            .drive(onNext: { indexPath in
                let splitType: SplitType = SplitType(rawValue: indexPath.row)!
                switch splitType {
                case .smart:
                    UserDefaults.standard.set("Smart", forKey: "CreateFlow")
                case .equal:
                    UserDefaults.standard.set("Equal", forKey: "CreateFlow")
                }
                let vc = CSInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SplitMethodSelectVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width - 60
        let height = width * 2/3
        return CGSize(width: width,
                      height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SplitMethodCell else { return }
        cell.isHighlighted = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SplitMethodCell else { return }
        cell.isHighlighted = false
    }
}

extension SplitMethodSelectVC {
    enum SplitType: Int {
        case smart = 0
        case equal = 1
    }
}
