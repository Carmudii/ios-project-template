//
//  PictureInPictureView.swift
//  AppCar
//
//  Created by Car Mudi on 23/06/24.
//

import UIKit
import AVKit
import CoreMedia

final class PictureInPictureView: UIView {

    // MARK: - Properties

    private var frameSizeObservation: NSKeyValueObservation?
    private var pipController: AVPictureInPictureController?
    private var displayLink: CADisplayLink?
    private let displayLayer = AVSampleBufferDisplayLayer()

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public Methods

    public func togglePictureInPictureMode() {
        guard let pipController = pipController else {
            return
        }

        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
        } else {
            pipController.startPictureInPicture()
        }
    }

    public func setup() {
        if AVPictureInPictureController.isPictureInPictureSupported(), #available(iOS 15.0, *) {
            let pipVideoCallViewController = AVPictureInPictureVideoCallViewController()
            pipVideoCallViewController.preferredContentSize = CGSize(width: 1080, height: 1920)
            pipVideoCallViewController.view.layer.addSublayer(displayLayer)
            pipVideoCallViewController.view.backgroundColor = backgroundColor
            pipVideoCallViewController.view.layer.backgroundColor = backgroundColor?.cgColor
            displayLayer.backgroundColor = backgroundColor?.cgColor

            displayLayer.frame = pipVideoCallViewController.view.bounds
            displayLayer.videoGravity = .resize

            let pipContentSource = AVPictureInPictureController.ContentSource(
                activeVideoCallSourceView: self,
                contentViewController: pipVideoCallViewController)

            pipController = AVPictureInPictureController(contentSource: pipContentSource)
            
            pipController?.canStartPictureInPictureAutomaticallyFromInline = true
            pipController?.delegate = self

            // Add observation for the frame change
            frameSizeObservation = pipVideoCallViewController.view
                .observe(\.frame, options: [.new, .old]) { [weak self] view, change in
                    self?.frameDidChange(newFrame: change.newValue, oldFrame: change.oldValue)
                }
        } else {
            print("Picture in Picture is not supported on this device.")
        }
    }

    // MARK: - Private Methods

    private func updateSnapshot() {
        guard let sampleBuffer = self.makeSampleBuffer() else {
            return
        }

        if displayLayer.status == .failed {
            displayLayer.flush()
        }

        displayLayer.enqueue(sampleBuffer)
    }

    private func startDisplayLink() {
        stopDisplayLink() // Ensure any existing display link is stopped first
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplayLink))
        displayLink?.add(to: .main, forMode: .default)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc
    private func updateDisplayLink() {
        updateSnapshot()
    }

    private func frameDidChange(newFrame: CGRect?, oldFrame: CGRect?) {
        guard let newFrame = newFrame else { return }
        displayLayer.frame = newFrame
    }

    deinit {
        frameSizeObservation?.invalidate()
        stopDisplayLink()
    }
}

// MARK: - AVPictureInPictureControllerDelegate

extension PictureInPictureView: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        updateSnapshot()
    }

    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        startDisplayLink()
    }

    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        stopDisplayLink()
    }
}
