//
//  AppNavigationManager.swift
//  __TEMPLATE__
//
//  Created by Car mudi on 07/03/24.
//

import Swinject
import __MODULE_PREFIX__CoreModule

final class AppNavigationManager: Assembly {
    func assemble(container: Container) {
        container.register(UINavigationController.self) { _ in
            // You can replace this with your own navigation controller
            // in case you want to disable the reotation
            return UINavigationController()
        }
    }
}
