//
//  __MODULE_PREFIX__NavigationRoute.swift
//  __MODULE_PREFIX__
//
//  Created by Car mudi on 07/03/24.
//

import Swinject
/// `NOTE:` - This file is generated by script don't forget to import your CoreModule here
///  Because the file is sperated in CoreModule. if you want to use your own code you can delete this file

public protocol __MODULE_PREFIX__NavigationService {

    var resolver: Resolver { get }

    var app: __MODULE_PREFIX__NavigationService { get }

    // TODO: - ADd our navigation here
}

public class __MODULE_PREFIX__Navigation: __MODULE_PREFIX__NavigationService {

    public var resolver: Resolver

    public var app: __MODULE_PREFIX__NavigationService

    public init(resolver: Resolver) {
        self.resolver = resolver
        self.app = resolver.receive(__MODULE_PREFIX__NavigationService.self)
    }
}