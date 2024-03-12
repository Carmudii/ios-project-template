//
//  NavigationManager.swift
//  ThirdModule
//
//  Created by Car mudi on 07/03/24.
//

import Swinject

final class NavigationManager: Assembly {

    func assemble(container: Container) {
        container.register(ThirdNavigationService.self) { resolver in
            return ThirdNavigation(resolver: resolver)
        }.inObjectScope(.container)
    }
}
