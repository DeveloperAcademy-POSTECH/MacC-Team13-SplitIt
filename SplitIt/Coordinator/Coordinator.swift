//
//  Coordinator.swift
//  SplitIt
//
//  Created by Zerom on 2/12/24.
//

import Foundation

// MARK: - 기본적으로 Coordinator들은 자신이 연 VC는 자신이 모두 닫을 책임이 있음 - VC를 다 닫고 해당 coordinator가 필요없을경우 앞에 remove를 붙여 상위 Coordinator의 childCoordinator를 없애줄 것을 요청해야됨
// MARK: - 자신이 연 VC 중 상위 Coordinator의 다른 VC와 연관이 있어 상위뷰에서 다른 뷰와 함께 제거해야될 경우 메서드 앞에 request를 붙여 자신의 VC들을 상위뷰에 닫아줄 것을 요청하는 표시로 해둘 것.
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
