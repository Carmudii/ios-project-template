//
//  __MODULE_PREFIX__NavigationModule.swift
//  __MODULE_PREFIX__NavigationModule
//
//  Created by Car mudi on 11/07/23.
//

import Swinject
import __MODULE_PREFIX__CoreModule

public final class __MODULE_PREFIX__NavigationModuleConfiguration {

    public private(set) static var resourceBundle: Bundle = {
        return Bundle(for: __MODULE_PREFIX__NavigationModuleConfiguration.self).resource
    }()

    public static let shared = __MODULE_PREFIX__NavigationModuleConfiguration()

    public init() {
    }

    @discardableResult
    public static func configureAssembler(in assembler: Assembler) -> ModuleAssembler {
        let assembler: ModuleAssembler = __MODULE_PREFIX__NavigationModuleAssembler(in: assembler)

        return assembler
    }
}
