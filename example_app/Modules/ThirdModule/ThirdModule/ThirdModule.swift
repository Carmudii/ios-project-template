//
//  App.swift
//  ThirdModule
//
//  Created by Car mudi on 11/07/23.
//

import Swinject
import AppCoreModule

public final class ThirdModule {

    public private(set) static var resourceBundle: Bundle = {
        return Bundle(for: ThirdModule.self).resource
    }()

    public static let shared = ThirdModule()

    public init() {
    }

    @discardableResult
    public static func configureAssembler(in assembler: Assembler) -> ModuleAssembler {
        let assembler: ModuleAssembler = ThirdModuleAssembler(in: assembler)

        return assembler
    }

}
