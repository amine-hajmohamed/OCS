//
//  BaseCoordinator.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import UIKit

class BaseCoordinator: Coordinator {
    
    let appModule: AppModule
    let router: RouterProtocol
    var childCoordinators: [Coordinator]
    
    var onCompletion: (() -> Void)?
    
    init(appModule: AppModule, router: RouterProtocol) {
        self.appModule = appModule
        self.router = router
        self.childCoordinators = []
    }
    
    func start() {
    }
    
    final func addChildCoordinator(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        
        childCoordinators.append(coordinator)
    }

    final func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

extension BaseCoordinator: Presentable {
    
    func toPresentable() -> UIViewController {
        router.toPresentable()
    }
}
