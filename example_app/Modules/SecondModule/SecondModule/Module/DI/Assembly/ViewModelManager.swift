//
//  ViewModelManager.swift
//  SecondModule
//
//  Created by Car mudi on 25/06/23.
//

import Swinject
import SwinjectAutoregistration

final class ViewModelManager: Assembly {
    func assemble(container: Container) {
        container.register(SecondViewModel.self) { _ in
            return SecondViewModel()
        }
    }
}
