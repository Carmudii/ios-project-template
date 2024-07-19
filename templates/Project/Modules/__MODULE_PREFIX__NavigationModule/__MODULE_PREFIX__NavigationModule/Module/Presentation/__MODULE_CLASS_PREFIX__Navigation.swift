//
//  AppNavigation.swift
//  __MODULE_CLASS_PREFIX__NavigationModule
//
//  Created by Car mudi on 18/07/24.
//

import Foundation
import Swinject
import __MODULE_PREFIX__CoreModule

public final class AppNavigation: AppNavigationService {

    public var navigation: UINavigationController

    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    public func back(animated: Bool) {
        navigation.popViewController(animated: animated)
    }

    public func replaceRootViewController(with anyViewController: Any) {

        guard let viewController = anyViewController as? UIViewController else {
            #if Dev
                print("DEBUG -> Failed to replace root view controller viewController: \(anyViewController)")
            #endif
            return
        }

        navigation.setViewControllers([viewController], animated: true)
    }

    public func pushViewController(_ anyViewController: Any, animated: Bool) {

        guard let viewController = anyViewController as? UIViewController else {
            #if Dev
                print("DEBUG -> Failed to push view controller viewController: \(anyViewController)")
            #endif
            return
        }

        navigation.pushViewController(viewController, animated: animated)
    }

}
