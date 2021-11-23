//
//  AppCoordinator.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow
    
    // MARK: - Initializer
    
    init(_ window: UIWindow,
         _ appModule: AppModule = DefaultAppModule(),
         _ router: RouterProtocol = Router(navigationController: UINavigationController())) {
        self.window = window
        super.init(appModule: appModule, router: router)
        configureWindow()
    }
    
    // MARK: - Configurations
    
    private func configureWindow() {
        window.rootViewController = router.toPresentable()
        window.makeKeyAndVisible()
    }
    
    // MARK: - Actions
    
    override func start() {
        goToContents()
    }
    
    private func goToContents() {
        let contentsViewModel = ContentsViewModel(contentUseCase: appModule.contentUseCase)
        let contentsViewController: ContentsViewController = .instantiate()
        contentsViewController.viewModel = contentsViewModel
        router.setRootModule(contentsViewController, hideBar: true)
    }
}
