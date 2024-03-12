//
//  AppNavigation.swift
//  App
//
//  Created by Car mudi on 07/03/24.
//

import Foundation
import UIKit

///
/// This protocol represents a navigation app.
///
public protocol AppNavigationService {

    /// The app's window.
    var window: UIWindow? { get set }

    /// The app's navigation controller.
    var navigation: UINavigationController? { get set }

    /// Pops the top view controller from the navigation stack.
    ///
    /// - Parameter animated: A Boolean value indicating whether the transition should be animated.
    ///
    func back(animated: Bool)

    /// Replaces the root view controller of the app's window with the specified view controller.
    ///
    /// - Parameter viewController: The view controller to be set as the new root view controller.
    ///
    func replaceRootViewController(with anyViewController: Any)

    /// Pushes a view controller onto the navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to push onto the stack.
    ///   - animated: A Boolean value indicating whether the transition should be animated.
    ///
    func pushViewController(_ anyViewController: Any, animated: Bool)
}

public final class AppNavigation: AppNavigationService {

    public var window: UIWindow?

    public var navigation: UINavigationController?

    public init(window: UIWindow? = nil, navigation: UINavigationController? = nil) {
        self.window = window
        self.navigation = navigation
    }

    public func back(animated: Bool) {
        guard let navigation = navigation else {
            print("DEBUG -> Failed to pop view controller, navigation: \(String(describing: navigation))")
            return
        }

        navigation.popViewController(animated: animated)
    }

    public func replaceRootViewController(with anyViewController: Any) {

        guard let window = window, let viewController = anyViewController as? UIViewController else {
            print("DEBUG -> Failed to replace root view controller, window: \(String(describing: window)), viewController: \(anyViewController)")
            return
        }

        let navigationViweController = UINavigationController(rootViewController: viewController)
        navigation = navigationViweController
        window.rootViewController = navigationViweController
    }

    public func pushViewController(_ anyViewController: Any, animated: Bool) {

        guard let viewController = anyViewController as? UIViewController else {
            print("DEBUG -> Failed to push view controller viewController: \(anyViewController)")
            return
        }

        navigation?.pushViewController(viewController, animated: animated)
    }

}

/// This protocol represents a view controller that can be presented.
public protocol RepresentableViewController {
    func viewController() -> UIViewController
}

/// Extension for `RepresentableViewController` protocol that provides a default implementation for presenting the view controller.
public extension RepresentableViewController where Self: UIViewController {
    func viewController() -> UIViewController {
        return self
    }
}
