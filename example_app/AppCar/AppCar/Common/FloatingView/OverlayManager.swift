//
//  OverlayManager.swift
//  AppCar
//
//  Created by Car mudi on 21/06/24.
//

import UIKit

final class OverlayManager {

    // MARK: - Private components

    private let circleDragable = UIView()
    private let hiddenCircleDragable = UIView()
    private let hiddenCircleLabel = UILabel()

    // MARK: - Private properties

    private weak var window: UIWindow?
    private let transitionDelegate = CustomTransitionDelegate()

    // MARK: - Public properties

    public static let shared = OverlayManager()

    // MARK: - Public methods

    public func applyOverlay() {

        guard let window = UIApplication.shared.windows.last else {
            print("Window not found")
            return
        }

        self.window = window

        // Create the circleDragable and add to the window
        circleDragable.frame = CGRect(x: 0, y: window.center.y - 40, width: 60, height: 60) // Adjusted for center
        circleDragable.backgroundColor = .green
        circleDragable.layer.cornerRadius = circleDragable.frame.width / 2

        // Add gesture recognizer if needed
        circleDragable.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        circleDragable.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        // Add and bring to front after everything else is setup
        window.addSubview(circleDragable)

        // Configure the hiddenCircleDragable
        hiddenCircleDragable.frame = CGRect(x: 0, y: window.center.y - 30, width: 15, height: 50) // Adjusted for center
        hiddenCircleDragable.backgroundColor = .gray.withAlphaComponent(0.5)
        hiddenCircleDragable.isHidden = true
        hiddenCircleDragable.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnHiddenCircle)))

        window.addSubview(hiddenCircleDragable)

        // Configure the hiddenCircleLabel
        hiddenCircleLabel.textColor = .white
        hiddenCircleLabel.textAlignment = .center
        hiddenCircleLabel.translatesAutoresizingMaskIntoConstraints = false
        hiddenCircleLabel.font = .boldSystemFont(ofSize: 15)

        hiddenCircleDragable.addSubview(hiddenCircleLabel)

        // Center the label in hiddenCircleDragable
        NSLayoutConstraint.activate([
            hiddenCircleLabel.centerXAnchor.constraint(equalTo: hiddenCircleDragable.centerXAnchor),
            hiddenCircleLabel.centerYAnchor.constraint(equalTo: hiddenCircleDragable.centerYAnchor)
        ])
    }

    // MARK: - Private methods

    private func configureAnimation(with xOffset: CGFloat, yOffset: CGFloat) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn,
                       animations: {
            self.circleDragable.center.x = xOffset
            self.circleDragable.center.y = yOffset
        }, completion: nil)
    }

    private func hideTheCircleDragable(at position: CGPoint) {
        hiddenCircleDragable.center = position
        circleDragable.isHidden = true
        hiddenCircleDragable.isHidden = false
    }

    private func showTheCircleDragable() {
        circleDragable.isHidden = false
        hiddenCircleDragable.isHidden = true
    }

    private func configureCornerRadius(
        view: UIView,
        size: CGSize,
        corners: UIRectCorner
    ) {

        let size = CGSize(
            width: size.width / 2,
            height: size.height / 2
        )

        let path = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: corners,
            cornerRadii: size)

        let mask = CAShapeLayer()
        mask.path = path.cgPath

        view.layer.mask = mask
    }

    @objc
    private func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.window)
        let draggedView = gesture.view
        draggedView?.center = location

        guard let window = window else {
            return
        }

        if gesture.state == .ended {
            if self.circleDragable.frame.maxX >= window.layer.frame.width || self.circleDragable.frame.minX <= 0 {
                hideTheCircleDragable(at: location)

                let isHalfScreen = self.hiddenCircleDragable.frame.midX >= window.layer.frame.width / 2
                let halfWidthHiddenCircleDragable = hiddenCircleDragable.frame.width / 2

                hiddenCircleDragable.center.x = isHalfScreen
                ? window.layer.frame.width - halfWidthHiddenCircleDragable
                : halfWidthHiddenCircleDragable

                hiddenCircleLabel.text = isHalfScreen ? "<" : ">"
                let corners: UIRectCorner = isHalfScreen ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight]
                configureCornerRadius(
                    view: hiddenCircleDragable,
                    size: hiddenCircleDragable.frame.size,
                    corners: corners
                )
            }

            let isHalfXScreen = self.circleDragable.frame.midX >= window.layer.frame.width / 2
            let halfWidthCircleDragable = circleDragable.frame.width / 2

            var yOffset: CGFloat = location.y
            if circleDragable.frame.maxY > window.frame.height {
                yOffset = location.y - circleDragable.frame.height / 2
            } else if circleDragable.frame.minY < 0 {
                yOffset = location.y + circleDragable.frame.height / 2
            }

            configureAnimation(
                with: isHalfXScreen ? window.layer.frame.width - halfWidthCircleDragable : halfWidthCircleDragable,
                yOffset: yOffset
            )
        }
    }

    @objc
    private func handleTap() {
        showFloatingViewController()
    }

    @objc
    private func handleTapOnHiddenCircle() {
        showTheCircleDragable()
    }

    // MARK: - Navigation methods

    private func showFloatingViewController() {
        guard let window = window else { return }
        let vc = FloatingViewController()
        transitionDelegate.backgroundColor = .yellow
        transitionDelegate.viewRect = circleDragable.frame

        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .custom
        window.rootViewController?.present(vc, animated: true, completion: nil)
    }
}
