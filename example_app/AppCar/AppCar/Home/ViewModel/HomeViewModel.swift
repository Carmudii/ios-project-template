//
//  HomeViewModel.swift
//  AppCar
//
//  Created by Car mudi on 12/03/24.
//

import AppCoreModule
import Foundation

final class HomeViewModel {

    internal var state: ((State) -> Void)?

    // MARK: - Private methods

    private var timer: Timer?

    // MARK: - Initializers

    init() {
        startTimer()
    }

    // MARK: - Private methods

    private func navigateToSecondScreen() {
        state?(.navigateToSecond)
    }

    private func navigateToThird() {
        state?(.navigateToThird)
    }

    private func enterPipMode() {
        state?(.enterPipMode)
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)

        // Immediately update the countdown label
        updateTimer()
    }

    @objc 
    func updateTimer() {
        let currentDate = Date()

        // Calculate the time difference
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: currentDate)

        // Update the UI
        if let hours = components.hour, let minutes = components.minute, let seconds = components.second {
            state?(.updateTimer(String(format: "%02d:%02d:%02d", hours, minutes, seconds)))
        }
    }
}

extension HomeViewModel: ViewModel {

    func onReceiveEvent(_ event: Event) {
        switch event {
        case .navigateToSecond:
            navigateToSecondScreen()

        case .navigateToThird:
            navigateToThird()

        case .enterPipMode:
            enterPipMode()
        }
    }
}
