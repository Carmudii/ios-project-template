//
//  AppNavigationService.swift
//  __MODULE_CLASS_PREFIX__NavigationModule
//
//  Created by Car mudi on 07/03/24.
//

import Foundation
import Swinject

///
/// This protocol represents a navigation app.
///
public protocol AppNavigationService {

    /// The app's navigation controller.
    var navigation: UINavigationController { get }

    /// Back to previous view controller
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
