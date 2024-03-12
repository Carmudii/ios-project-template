//
//  ViewModel.swift
//  App
//
//  Created by Car mudi on 11/03/24.
//

import Foundation

public protocol ViewModel: AnyObject {
    associatedtype State: ViewModelState
    associatedtype Event: ViewModelEvent

    var state: ((State) -> Void)? { get set } // Change to closure

    func onReceiveEvent(_ event: Event)
}

public protocol ViewModelState {
}

public protocol ViewModelEvent {
}

public class AnyViewModel<State: ViewModelState, Event: ViewModelEvent>: ViewModel {

    // MARK: - Public Properties

    public var state: ((State) -> Void)? {
        didSet {
            stateDidChange(state)
        }
    }

    // MARK: - Private Properties

    private let eventHandler: (Event) -> Void
    private var stateDidChange: (((State) -> Void)?) -> Void // Adjusted

    // MARK: - Initialization

    public init<WrappedViewModel: ViewModel>(
        _ wrappedViewModel: WrappedViewModel
    ) where WrappedViewModel.State == State, WrappedViewModel.Event == Event {

        self.state = wrappedViewModel.state // No longer a direct assignment
        self.eventHandler = wrappedViewModel.onReceiveEvent

        // Adjusted to store closure instead of property
        self.stateDidChange = { stateClosure in
            wrappedViewModel.state = stateClosure // Set state closure of wrapped ViewModel
        }
    }

    // MARK: - Public Methods

    public func onReceiveEvent(_ event: Event) {
        eventHandler(event)
    }

    // MARK: - Public Methods

    public func bindStateDidChange(_ closure: @escaping (State) -> Void) {
        stateDidChange(closure)
    }
}
