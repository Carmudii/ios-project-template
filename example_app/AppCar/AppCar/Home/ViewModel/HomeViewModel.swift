//
//  HomeViewModel.swift
//  AppCar
//
//  Created by Car mudi on 12/03/24.
//

import AppCoreModule

final class HomeViewModel {

    internal var state: ((State) -> Void)?

    init(){
    }

    // MARK: - Private methods

    private func navigateToSecondScreen() {
        state?(.navigateToSecond)
    }

    private func navigateToThird() {
        state?(.navigateToThird)
    }
}

extension HomeViewModel: ViewModel {

    func onReceiveEvent(_ event: Event) {
        switch event {
        case .navigateToSecond:
            navigateToSecondScreen()

        case .navigateToThird:
            navigateToThird()
        }
    }
}
