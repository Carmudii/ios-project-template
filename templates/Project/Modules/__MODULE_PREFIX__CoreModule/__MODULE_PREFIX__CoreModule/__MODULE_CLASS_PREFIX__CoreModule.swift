//
//  __MODULE_PREFIX__CoreModule.swift
//  __MODULE_PREFIX__
//
//  Created by Car mudi on 11/07/23.
//

import Foundation
import Swinject

public final class __MODULE_PREFIX__CoreModule {

    public private(set) static var resourceBundle: Bundle = {
        return Bundle(for: __MODULE_PREFIX__CoreModule.self).resource
    }()

    public static let shared = __MODULE_PREFIX__CoreModule()

    public init() {
    }

}
