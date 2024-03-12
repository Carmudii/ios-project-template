//
//  ViewControllerManager.swift
//  AppCar
//
//  Created by Car mudi on 07/03/24.
//

import Swinject
import AppCoreModule

final class ViewControllerManager: Assembly {

    func assemble(container: Container) {
        container.register(HomeViewController.self) { resolver in
            let viewModel = AnyViewModel(resolver.receive() as HomeViewModel)
            return HomeViewController(resolver: resolver, viewModel: viewModel)
        }
    }
}
