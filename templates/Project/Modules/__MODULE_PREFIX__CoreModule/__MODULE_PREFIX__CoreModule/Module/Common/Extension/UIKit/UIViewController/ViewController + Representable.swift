//
//  ViewController + Representable.swift
//  MOSTBaseModule
//
//  Created by Car mudi on 10/03/24.
//

import UIKit

/// This protocol represents a view controller that can be presented.
public protocol RepresentableViewController {
    func viewController() -> BaseViewController
}

/// Extension for `RepresentableViewController` protocol that provides a default implementation for presenting the view controller.
public extension RepresentableViewController where Self: BaseViewController {
    func viewController() -> BaseViewController {
        return self
    }
}
