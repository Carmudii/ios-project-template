//
//  App.swift
//  SecondModule
//
//  Created by Car mudi on 11/07/23.
//

import Swinject
import AppCoreModule

public final class SecondModule {

    public private(set) static var resourceBundle: Bundle = {
        return Bundle(for: SecondModule.self).resource
    }()

    public static let shared = SecondModule()

    public init() {
    }

    @discardableResult
    public static func configureAssembler(in assembler: Assembler) -> ModuleAssembler {
        let assembler: ModuleAssembler = SecondModuleAssembler(in: assembler)

        return assembler
    }
}
