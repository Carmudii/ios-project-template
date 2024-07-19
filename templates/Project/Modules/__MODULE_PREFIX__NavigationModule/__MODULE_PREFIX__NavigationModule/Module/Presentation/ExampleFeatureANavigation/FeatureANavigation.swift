//
//  FeatureANavigation.swift
//  __MODULE_CLASS_PREFIX__NavigationModule
//
//  Created by Car mudi on 17/07/24.
//

/// `FeatureANavigation` provides navigation functionalities for Feature A.
/// It uses dependency injection to resolve instances and utilizes an app-wide navigation service to manage screen transitions.
//import Swinject
//import FeatureAModule
//
//final class FeatureANavigation: FeatureANavigationService {
//
//    private let appNavigation: AppNavigationService
//    private let resolver: Resolver
//
//    /// Initializes a new instance of `FeatureANavigation`.
//    /// - Parameters:
//    ///   - resolver: A `Resolver` to resolve dependencies.
//    ///   - appNavigation: An `AppNavigationService` to handle app-wide navigation.
//    init(resolver: Resolver, appNavigation: AppNavigationService) {
//        self.resolver = resolver
//        self.appNavigation = appNavigation
//    }
//
//    /// Opens `ScreenA` using the app's navigation service.
//    func openScreenA() {
//        let AScreen: AScreenPresentable = resolver.receive()
//        appNavigation.pushViewController(AScreen.viewController(), animated: true)
//    }
//}
