//
//  DIContainer.swift
//  __TEMPLATE__
//
//  Created by Car mudi on 21/06/23.
//

import Swinject
import __MODULE_PREFIX__NavigationModule
import __MODULE_PREFIX__CoreModule

/// The protocol for managing and resolving dependencies in the application.
protocol DIContainerProtocol {

    /// The `Assembler` responsible for managing the registration and resolution of services.
    var assembler: Assembler { get }

    /// The `Container` that holds all the service registrations.
    var container: Container { get }

    /// Sets up a module in the container.
    func registerAllModules()

    /// Resolves a service from the container.
    ///
    /// - Parameter serviceType: The type of the service to be resolved.
    /// - Returns: An instance of the resolved service.
    func resolve<Service>(_ serviceType: Service.Type) -> Service
}

extension DIContainerProtocol {
    /// Resolves a service from the container.
    /// - Parameter serviceType: The type of the service to be resolved.
    /// hgxsz
    /// - Returns: An instance of the resolved service.
    func resolve<Service>(_ serviceType: Service.Type = Service.self) -> Service {
        guard let service = assembler.resolver.resolve(serviceType) else {
            fatalError("Failed to resolve \(serviceType) in \(self).")
        }

        return service
    }
}

/// The `DependencyContainer` class is responsible for managing and resolving dependencies in the application.
final class DIContainer: DIContainerProtocol {

    /// The shared instance of the `DependencyContainer`.
    static let shared = DIContainer()

    /// The `Assembler` used for managing the registration and resolution of services.
    internal let assembler: Assembler

    /// The `Container` that holds all the service registrations.
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
            AppNavigationModuleConfiguration.configureAssembler(in: assembler)
            // Add more module assemblers here
        ]

        // Register your application managers here
        assembler.apply(assemblies: [
            AppNavigationManager(),
            ViewControllerManager(),
            ViewModelManager()
        ])

        modules.forEach { module in
            container.register(ModuleAssembler.self) { [module] _ in
                return module
            }.inObjectScope(.container)
        }
    }
}
