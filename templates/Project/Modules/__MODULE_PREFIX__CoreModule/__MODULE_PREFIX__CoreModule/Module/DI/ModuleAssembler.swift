//
//  ModuleAssembler.swift
//  __MODULE_PREFIX__
//
//  Created by Car mudi on 25/06/23.
//

import Swinject

/// This class represents a module assembler, which is responsible for providing dependencies to a module.
public protocol ModuleAssembler {
    /// The underlying assembler instance.
    var assembler: Assembler { get }

    /// Creates an instance of the assembler.
    func registerManagers()

    /// Retrieves a dependency of type `T` from the assembler.
    ///
    /// - Returns: An instance of type `T`.
    func resolve<T>() -> T

    /// Retrieves a dependency of type `T` with the specified registration name from the assembler.
    ///
    /// - Parameter registrationName: The registration name of the dependency.
    /// - Returns: An instance of type `T`.
    func resolve<T>(registrationName: String?) -> T

    /// Resolves a dependency of type `T` with the specified argument from the assembler.
    ///
    /// - Parameter argument: The argument used to resolve the dependency.
    /// - Returns: An instance of type `T`.
    func resolve<T, Arg>(argument: Arg) -> T

    /// Retrieves a dependency of type `T` with the specified arguments from the assembler.
    ///
    /// - Parameters:
    ///   - arg1: The first argument used to resolve the dependency.
    ///   - arg2: The second argument used to resolve the dependency.
    /// - Returns: An instance of type `T`.
    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T

    /// Retrieves a dependency of type `T` with the specified registration name and argument from the assembler.
    ///
    /// - Parameters:
    ///   - name: The registration name of the dependency.
    ///   - argument: The argument used to resolve the dependency.
    /// - Returns: An instance of type `T`.
    func resolve<T, Arg>(name: String?, argument: Arg) -> T

    /// Retrieves a dependency of type `T` with the specified registration name and arguments from the assembler.
    ///
    /// - Parameters:
    ///   - name: The registration name of the dependency.
    ///   - arg1: The first argument used to resolve the dependency.
    ///   - arg2: The second argument used to resolve the dependency.
    /// - Returns: An instance of type `T`.
    func resolve<T, Arg1, Arg2>(name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> T

}

public extension ModuleAssembler {

    /// This default implementation resolves a dependency of type `T` from the assembler.
    ///
    /// - Returns: An instance of type `T`.
    func resolve<T>() -> T {
        guard let dependency = assembler.resolver.resolve(T.self) else {
            fatalError("Failed to resolve \(T.self) in \(self).")
        }
        return dependency
    }

    /// This default implementation resolves a dependency of type `T` with the specified registration name from the assembler.
    ///
    /// - Parameter registrationName: The registration name of the dependency.
    /// - Returns: An instance of type `T`.
    func resolve<T>(registrationName: String?) -> T {
        guard let dependency = assembler.resolver.resolve(T.self, name: registrationName) else {
            fatalError("Failed to resolve \(T.self) in \(self).")
        }
        return dependency
    }

    /// This default implementation resolves a dependency of type `T` with the specified argument from the assembler.
    ///
    /// - Parameter argument: The argument used to resolve the dependency.
    /// - Returns: An instance of type `T`.
    func resolve<T, Arg>(argument: Arg) -> T {
        guard let dependency = assembler.resolver.resolve(T.self, argument: argument) else {
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
    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let dependency = assembler.resolver.resolve(T.self, arguments: arg1, arg2) else {
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
    func resolve<T, Arg>(name: String?, argument: Arg) -> T {
        guard let dependency = assembler.resolver.resolve(T.self, name: name, argument: argument) else {
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
    func resolve<T, Arg1, Arg2>(name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let dependency = assembler.resolver.resolve(T.self, name: name, arguments: arg1, arg2) else {
            fatalError("Failed to resolve \(T.self) in \(self).")
        }
        return dependency
    }

}
