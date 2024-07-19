//
//  BondsNavigation.swift
//  NavigationModule
//
//  Created by Car mudi on 17/07/24.
//

import Swinject
import BondsModule

final class BondsNavigation: BondsNavigationService {

    private let appNavigation: AppNavigationService
    private let resolver: Resolver

    init(resolver: Resolver, appNavigation: AppNavigationService) {
        self.resolver = resolver
        self.appNavigation = appNavigation
    }

    func openBondsScreen() {
        let bondsPage: BondsPagePresentable = resolver.receive()
        appNavigation.pushViewController(bondsPage.viewController(), animated: true)
    }

    func openBondsProductList() {
        let productList: BondsProductListPresentable = resolver.receive()
        appNavigation.pushViewController(productList.viewController(), animated: true)
    }

    func openTestPage(with product: ProductListModel) {
        let testPage: TestPagePresentable = resolver.receive(argument: product)
        appNavigation.pushViewController(testPage.viewController(), animated: true)
    }
}
