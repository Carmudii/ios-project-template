//
//  ViewControllerManager.swift
//  ThirdModule
//
//  Created by Car mudi on 25/06/23.
//

import Swinject
import AppCoreModule

final class ViewControllerManager: Assembly {

    func assemble(container: Container) {
        container.register(ThirdPresentableScreen.self) { resolver in
            let viewModel = AnyViewModel(resolver.receive() as ThirdScreenViewModel)
            return ThirdViewController(resolver: resolver, viewModel: viewModel)
        }
    }
}
