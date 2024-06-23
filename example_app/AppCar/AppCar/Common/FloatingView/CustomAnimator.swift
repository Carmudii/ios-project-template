//  CustomAnimator.swift
//  AppCar
//
//  Created by Car mudi on 21/06/24.
//

import UIKit

final class CustomAnimator: NSObject {

    private let identifierView = 743
    private let view = UIView()

    var viewRect: CGRect = .zero

    var viewColor = UIColor.white

    var duration = 0.4

    enum CircularTransitionMode: Int {
        case present, dismiss, pop
    }

    var transitionMode: CircularTransitionMode = .present

    // MARK: - Private methods

    private func center() -> CGPoint {
        return CGPoint(x: viewRect.midX, y: viewRect.midY)
    }

    private func encompassingFrameFor(
        withViewCenter viewCenter: CGPoint,
        size viewSize: CGSize,
        startPoint: CGPoint
    ) -> CGRect {

        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)

        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)

        return CGRect(
            origin: CGPoint(
                x: startPoint.x - offsetVector / 2,
                y: startPoint.y - offsetVector / 2
            ),
            size: size
        )
    }
}

extension CustomAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size

                view.frame = viewRect
                view.layer.cornerRadius = view.frame.size.height / 2
                view.backgroundColor = viewColor
                view.tag = identifierView
                containerView.addSubview(view)

                presentedView.center = center()
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)

                UIView.animate(withDuration: duration, animations: {
                    self.view.frame = self.encompassingFrameFor(
                        withViewCenter: viewCenter,
                        size: viewSize,
                        startPoint: self.center()
                    )
                    self.view.layer.cornerRadius = self.view.frame.size.height / 2

                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter

                }, completion: { (success: Bool) in
                    transitionContext.completeTransition(success)
                })
            }

        } else {
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from

            if 
                let returningView = transitionContext.view(forKey: transitionModeKey),
                let view = containerView.subviews.filter({ $0.tag == identifierView }).first
            {
                UIView.animate(withDuration: duration, animations: {
                    view.frame = self.viewRect
                    view.layer.cornerRadius = view.frame.size.height / 2
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.alpha = 0

                    returningView.center = self.center()

                }, completion: { (success: Bool) in
                    returningView.removeFromSuperview()
                    view.removeFromSuperview()
                    transitionContext.completeTransition(success)
                })
            }
        }
    }
}
