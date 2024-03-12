//
//  SecondViewModel.swift
//  SecondModule
//
//  Created by Car mudi on 12/03/24.
//

import AppCoreModule

final class SecondViewModel {

    // MARK: - Private properties

    internal var state: ((State) -> Void)?

    init() {
    }

    // MARK: - Private methods

    private func navigateToThirdScreen() {
        state?(.navigateToThird)
    }

}

extension SecondViewModel: ViewModel {

    func onReceiveEvent(_ event: Event) {
        switch event {
        case .goBack:
            state?(.goBack)

        case .navigateToThird:
            navigateToThirdScreen()
        }
    }
}
