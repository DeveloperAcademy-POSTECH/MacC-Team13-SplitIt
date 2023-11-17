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
    }
    
    private func setAttribute() {
        view.backgroundColor = .SurfacePrimary
        
        header.do {
            $0.applyStyle(style: .selectSplitMethod, vc: self)
        }
     
        titleLabel.do {
            $0.text = "1차 정산"
            $0.font = .KoreanTitle1
            $0.textColor = .AppColorGrayscale1000
        }
        
        subTitleLabel.do {
            $0.text = "정산 방식을 선택해주세요"
            $0.font = .KoreanBody
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
        
        output.methodList
            .bind(to: collectionView.rx.items(cellIdentifier: SplitMethodCell.reuseIdentifier)) { indexPath, item, cell in
                guard let cell = cell as? SplitMethodCell else { return }
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        output.showMethodTapped
            .asDriver()
            .drive(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
//        output.showSmartSplitCSInfoView
//            .asDriver()
//            .drive(onNext: {
//                let vc = CSInfoVC()
//                self.navigationController?.pushViewController(vc, animated: true)
//                SplitRepository.share.isSmartSplit = true
//            })
//            .disposed(by: disposeBag)
//
//        output.showEqualSplitCSInfoView
//            .asDriver()
//            .drive(onNext: {
//                let vc = CSInfoVC()
//                self.navigationController?.pushViewController(vc, animated: true)
//                SplitRepository.share.isSmartSplit = false
//            })
//            .disposed(by: disposeBag)
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
}
