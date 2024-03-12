//
//  Resolver + Receive.swift
//  App
//
//  Created by Car mudi on 10/03/24.
//

import Swinject

public extension Resolver {

    /// Resolves a service from the container.
    /// - Parameter serviceType: The type of the service to be resolved.
    /// - Returns: An instance of the resolved service.
    func receive<T>(_ serviceType: T.Type = T.self) -> T {
        guard let service = self.resolve(T.self) else {
            fatalError("Failed to resolve \(serviceType) in \(self).")
        }

        return service
    }

    /// This default implementation resolves a dependency of type `T` with the specified registration name from the assembler.
    ///
    /// - Parameter registrationName: The registration name of the dependency.
    /// - Returns: An instance of type `T`.
    func receive<T>(registrationName: String?) -> T {
        guard let dependency = self.resolve(T.self, name: registrationName) else {
            fatalError("Failed to resolve \(T.self) in \(self).")
        }
        return dependency
    }

    /// This default implementation resolves a dependency of type `T` with the specified argument from the assembler.
    ///
    /// - Parameter argument: The argument used to resolve the dependency.
    /// - Returns: An instance of type `T`.
    func receive<T, Arg>(argument: Arg) -> T {
        guard let dependency = self.resolve(T.self, argument: argument) else {
            fatalError("Failed to resolve \(T.self) in \(self).")
        }
        return dependency
    }

    /// This default implementation resolves a dependency of type `T` with the specified arguments from the assembler.
    ///
    /// - Parameters:
    ///   - arg1: The first argument used to resolve the dependency.
    ///   - arg2: The second argument used to resolve the dependency.
    /// - Returns: An instance of type `T`.
    func receive<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let dependency = self.resolve(T.self, arguments: arg1, arg2) else {
            fatalError("Failed to resolve \(T.self) in \(self).")
        }
        return dependency
    }

    /// This default implementation resolves a dependency of type `T` with the specified name and argument from the assembler.
    ///
    /// - Parameters:
    ///   - name: The name of the dependency.
    ///   - argument: The argument used to resolve the dependency.
    /// - Returns: An instance of type `T`.
    func receive<T, Arg>(name: String?, argument: Arg) -> T {
        guard let dependency = self.resolve(T.self, name: name, argument: argument) else {
            fatalError("Failed to resolve \(T.self) in \(self).")
        }
        return dependency
    }

    /// This default implementation resolves a dependency of type `T` with the specified name and arguments from the assembler.
    ///
    /// - Parameters:
    ///   - name: The name of the dependency.
    ///   - arg1: The first argument used to resolve the dependency.
    ///   - arg2: The second argument used to resolve the dependency.
    /// - Returns: An instance of type `T`.
    func receive<T, Arg1, Arg2>(name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let dependency = self.resolve(T.self, name: name, arguments: arg1, arg2) else {
            fatalError("Failed to resolve \(T.self) in \(self).")
        }
        return dependency
    }
}
