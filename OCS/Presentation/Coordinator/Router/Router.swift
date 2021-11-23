//
//  Router.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

import UIKit

// MARK: - RouterProtocol
protocol RouterProtocol: AnyObject, Presentable {
    
    var isNavigationBarHidden: Bool { get set }
    
    func present(_ module: Presentable, animated: Bool)
    func dismissModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    func push(_ module: Presentable, animated: Bool)
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable, transition: UIViewControllerAnimatedTransitioning?, animated: Bool)
    func push(_ module: Presentable,
              transition: UIViewControllerAnimatedTransitioning?,
              animated: Bool,
              completion: (() -> Void)?)
    func popModule(animated: Bool)
    func popModule(transition: UIViewControllerAnimatedTransitioning?, animated: Bool)
    
    func popToRootModule(animated: Bool)
    func popToModule(module: Presentable, animated: Bool)
}

// MARK: - Router
class Router: NSObject, RouterProtocol {
    
    var isNavigationBarHidden: Bool {
        get {
            navigationController.isNavigationBarHidden
        }
        set {
            navigationController.isNavigationBarHidden = newValue
        }
    }
    
    private let navigationController: UINavigationController
    private var completions: [UIViewController : () -> Void]
    private var transition: UIViewControllerAnimatedTransitioning?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    func present(_ module: Presentable, animated: Bool) {
        navigationController.present(module.toPresentable(), animated: animated, completion: nil)
    }
    
    func dismissModule(animated: Bool) {
        dismissModule(animated: animated, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        isNavigationBarHidden = hideBar
        
        if module == nil {
            navigationController.viewControllers = []
            return
        }
        
        if let viewController = module?.toPresentable(), !(viewController is UINavigationController) {
            navigationController.viewControllers = [viewController]
        }
    }
    
    func push(_ module: Presentable, animated: Bool) {
        push(module, transition: nil, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?) {
        push(module, transition: nil, animated: animated, completion: completion)
    }
    
    func push(_ module: Presentable, transition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        push(module, transition: transition, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable,
              transition: UIViewControllerAnimatedTransitioning?,
              animated: Bool,
              completion: (() -> Void)?) {
        
        let viewController = module.toPresentable()
        
        guard !(viewController is UINavigationController) else {
            return
        }
        
        self.transition = transition
        
        if let completion = completion {
            completions[viewController] = completion
        }
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func popModule(animated: Bool) {
        popModule(transition: nil, animated: animated)
    }
    
    func popModule(transition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        if let viewController = navigationController.popViewController(animated: animated) {
            self.transition = transition
            self.runCompletion(for: viewController)
        }
    }
    
    func popToRootModule(animated: Bool) {
        if var viewControllers = navigationController.popToRootViewController(animated: animated) {
            viewControllers.reverse()
            viewControllers.forEach { runCompletion(for: $0) }
        }
    }
    
    func popToModule(module: Presentable, animated: Bool) {
        if var viewControllers = navigationController.popToViewController(module.toPresentable(), animated: animated) {
            viewControllers.reverse()
            viewControllers.forEach { runCompletion(for: $0) }
        }
    }
    
    private func runCompletion(for viewController: UIViewController) {
        guard let completion = completions[viewController] else {
            return
        }
        
        completion()
        completions.removeValue(forKey: viewController)
    }
}

// MARK: - Presentable
extension Router: Presentable {
    
    func toPresentable() -> UIViewController {
        navigationController
    }
}

// MARK: - UINavigationControllerDelegate
extension Router: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(poppedViewController)
        else {
            return
        }
        
        runCompletion(for: poppedViewController)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition
    }
}
