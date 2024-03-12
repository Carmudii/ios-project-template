//
//  ViewModelManager.swift
//  ThirdModule
//
//  Created by Car mudi on 25/06/23.
//

import Swinject
import SwinjectAutoregistration

final class ViewModelManager: Assembly {
    func assemble(container: Container) {
        container.register(ThirdScreenViewModel.self) { _ in
            return ThirdScreenViewModel()
        }
    }
}
