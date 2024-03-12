//
//  NavigationManager.swift
//  SecondModule
//
//  Created by Car mudi on 07/03/24.
//

import Swinject

final class NavigationManager: Assembly {

    func assemble(container: Container) {
        container.register(SecondNavigationService.self) { resolver in
            return SecondNavigation(resolver: resolver)
        }.inObjectScope(.container)
    }
}
