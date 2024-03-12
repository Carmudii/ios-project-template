//
//  ViewModelManager.swift
//  AppCar
//
//  Created by Car mudi on 07/03/24.
//

import Swinject

final class ViewModelManager: Assembly {

    func assemble(container: Container) {
        container.register(HomeViewModel.self) { _ in
            return HomeViewModel()
        }
    }
}
