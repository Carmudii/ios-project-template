//
//  ViewControllerManager.swift
//  __TEMPLATE__
//
//  Created by Car mudi on 07/03/24.
//

import Swinject

final class ViewControllerManager: Assembly {

    func assemble(container: Container) {
        container.register(ViewController.self) { resolver in
            return ViewController()
        }.inObjectScope(.transient)
    }
}
