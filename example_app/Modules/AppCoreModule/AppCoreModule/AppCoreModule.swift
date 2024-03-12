//
//  AppCoreModule.swift
//  App
//
//  Created by Car mudi on 11/07/23.
//

import Foundation
import Swinject

public final class AppCoreModule {

    public private(set) static var resourceBundle: Bundle = {
        return Bundle(for: AppCoreModule.self).resource
    }()

    public static let shared = AppCoreModule()

    public init() {
    }

}
