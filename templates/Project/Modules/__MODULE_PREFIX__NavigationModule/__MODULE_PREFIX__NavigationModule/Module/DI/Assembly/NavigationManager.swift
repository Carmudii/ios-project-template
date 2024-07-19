//
//  __MODULE_PREFIX__NavigationManager.swift
//  __MODULE_PREFIX__
//
//  Created by Car mudi on 07/03/24.
//

import Foundation
import Swinject
import __MODULE_PREFIX__CoreModule

final class NavigationManager: Assembly {

    func assemble(container: Container) {
        container.register(AppNavigationService.self) { resolver in
            let navigation: UINavigationController = resolver.receive()
            return AppNavigation(navigation: navigation)
        }.inObjectScope(.container)

        /// Registers `FeatureANavigationService` in the dependency injection container.
        /// This service is responsible for handling navigation related to `FeatureA`.
        // container.register(FeatureANavigationService.self) { resolver in
        //     return FeatureANavigation(resolver: resolver, appNavigation: resolver.receive())
        // }.inObjectScope(.container)
    }
}
