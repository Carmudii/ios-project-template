//
//  NavigationManager.swift
//  AppCar
//
//  Created by Car mudi on 07/03/24.
//

import Swinject
import AppCoreModule

final class NavigationManager: Assembly {

    func assemble(container: Container) {
        container.register(AppNavigationService.self) { _ in
            return AppNavigation()
        }.inObjectScope(.container)
    }
}
