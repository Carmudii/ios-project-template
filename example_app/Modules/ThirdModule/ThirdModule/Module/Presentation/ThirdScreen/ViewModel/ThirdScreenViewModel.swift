//
//  ThirdScreenViewModel.swift
//  ThirdModule
//
//  Created by Car mudi on 12/03/24.
//

import AppCoreModule

final class ThirdScreenViewModel {

    internal var state: ((State) -> Void)?

    init() {
    }

    // MARK: - Private methods

    private func navigateToSecondScreen() {
        state?(.navigateToSecond)
    }
}

extension ThirdScreenViewModel: ViewModel {

    func onReceiveEvent(_ event: Event) {
        switch event {
        case .goBack:
            state?(.goBack)

        case .navigateToSecond:
            navigateToSecondScreen()
        }
    }
}
