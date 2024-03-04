//
//  EditCoordinator.swift
//  SplitIt
//
//  Created by Zerom on 2/29/24.
//

import UIKit

protocol EditCoordinatorDelegate {
    
}

class EditCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var delegate: EditCoordinatorDelegate?
    private var currentSplitIdx: String
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController,
         currentSplitIdx: String
    ) {
        self.currentSplitIdx = currentSplitIdx
        self.navigationController = navigationController
    }
    
    func start() {
        // EditView 시작
    }
}
