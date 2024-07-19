//
//  __MODULE_PREFIX__NavigationModuleAssembler.swift
//  __MODULE_PREFIX__NavigationModule
//
//  Created by Car mudi on 10/07/23.
//

import Swinject
import __MODULE_PREFIX__CoreModule

final class __MODULE_PREFIX__NavigationModuleAssembler: ModuleAssembler {

    private(set) var assembler: Assembler

    init(in assembler: Assembler) {
        self.assembler = assembler
        registerManagers()
    }

    public func registerManagers() {
        let assembly: [Assembly] = [
            NavigationManager()
        ]

        assembler.apply(assemblies: assembly)
    }
}
