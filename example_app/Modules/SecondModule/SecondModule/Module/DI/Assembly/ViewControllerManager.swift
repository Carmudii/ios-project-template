//
//  ViewControllerManager.swift
//  SecondModule
//
//  Created by Car mudi on 25/06/23.
//

import Swinject
import AppCoreModule

final class ViewControllerManager: Assembly {

    func assemble(container: Container) {
        container.register(SecondPresentableScreen.self) { resolver in
            let viewModel = AnyViewModel(resolver.receive() as SecondViewModel)
            return SecondViewController(resolver: resolver, viewModel: viewModel)
        }
    }
}
