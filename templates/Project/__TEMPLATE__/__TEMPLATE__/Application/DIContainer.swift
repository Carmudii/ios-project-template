//
//  DIContainer.swift
//  __TEMPLATE__
//
//  Created by Car mudi on 21/06/23.
//

import Swinject
import __MODULE_PREFIX__CoreModule

/// The protocol for managing and resolving dependencies in the application.
protocol DIContainerService {

    /// This class represents a dependency container that is responsible for managing and resolving dependencies.
    ///
    /// It contains an `assembler` object that is used to configure the container with the necessary dependencies,
    /// and a `container` object that holds the resolved dependencies.
    var assembler: Assembler { get }
    var container: Container { get }

    /// Sets up a module in the container.
    func registerAllModules()

    /// Resolves a service from the container.
    ///
    /// - Parameter serviceType: The type of the service to be resolved.
    /// - Returns: An instance of the resolved service.
    func resolve<Service>(_ serviceType: Service.Type) -> Service
}

extension DIContainerService {
    /// Resolves a service from the container.
    /// - Parameter serviceType: The type of the service to be resolved.
    /// - Returns: An instance of the resolved service.
    func resolve<Service>(_ serviceType: Service.Type = Service.self) -> Service {
        guard let service = assembler.resolver.resolve(serviceType) else {
            fatalError("Failed to resolve \(serviceType) in \(self).")
        }

        return service
    }
}

/// The `DependencyContainer` class is responsible for managing and resolving dependencies in the application.
final class DIContainer: DIContainerService {

    /// The shared instance of the `DependencyContainer`.
    static let shared = DIContainer()

    /// This class represents a dependency container that is responsible for managing and resolving dependencies.
    ///
    /// It contains an `assembler` object that is used to configure the container with the necessary dependencies,
    /// and a `container` object that holds the resolved dependencies.
    internal let assembler: Assembler
    internal let container: Container

    /// Initializes a new instance of `DependencyContainer`.
    ///
    /// - Parameter container: The container to use for dependency injection. Defaults to a new instance of `Container`.
    init(container: Container = Container()) {
        self.assembler = Assembler(container: container)
        self.container = container
        registerAllModules()
    }

    // MARK: - Private methods

    /// Sets up the modules in the container.
    internal func registerAllModules() {
        let modules: [ModuleAssembler] = [
            // Add more module assemblers here
        ]

        // Register your application managers here
        assembler.apply(assemblies: [
            NavigationManager(),
            ViewControllerManager(),
            ViewModelManager()
        ])

        modules.forEach { module in
            container.register(ModuleAssembler.self) { _ in
                return module
            }.inObjectScope(.container)
        }
    }
}
