//
//  CustomTransitionDelegate.swift
//  AppCar
//
//  Created by Car mudi on 21/06/24.
//

import UIKit

final class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - Public properties

    public var viewRect: CGRect = .zero
    public var backgroundColor: UIColor = .white

    // MARK: - Public methods

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        let transition = CustomAnimator()
        transition.transitionMode = .present
        transition.viewColor = backgroundColor
        transition.viewRect = viewRect

        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = CustomAnimator()
        transition.transitionMode = .dismiss
        transition.viewColor = backgroundColor
        transition.viewRect = viewRect

        return transition
    }
}
