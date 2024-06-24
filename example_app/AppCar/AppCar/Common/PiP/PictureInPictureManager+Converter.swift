//
//  PictureInPictureManager+Converter.swift
//  AppCar
//
//  Created by Car mudi on 23/06/24.
//

import UIKit
import CoreMedia
import CoreVideo

extension UIView {

    /// Make CMSampleBuffer from UIView
    /// https://soranoba.net/programming/uiview-to-cmsamplebuffer
    func makeSampleBuffer() -> CMSampleBuffer? {
        let scale = UIScreen.main.scale
        let size = CGSize(
            width: (bounds.width * scale),
            height: (bounds.height * scale))

        var pixelBuffer: CVPixelBuffer?
        var status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(size.width),
                                         Int(size.height),
                                         kCVPixelFormatType_32ARGB,
                                         [
                                            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
                                            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!,
                                            kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary,
                                         ] as CFDictionary, &pixelBuffer)

        if status != kCVReturnSuccess {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, [])
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer!, []) }

        let context = CGContext(
            data: CVPixelBufferGetBaseAddress(pixelBuffer!),
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)!

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: scale, y: -scale)
        layer.render(in: context)

        var formatDescription: CMFormatDescription?
        status = CMVideoFormatDescriptionCreateForImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: pixelBuffer!,
            formatDescriptionOut: &formatDescription)

        if status != kCVReturnSuccess {
            return nil
        }

        let now = CMTime(seconds: CACurrentMediaTime(), preferredTimescale: 60)
        let timingInfo = CMSampleTimingInfo(
            duration: .init(seconds: 1, preferredTimescale: 60),
            presentationTimeStamp: now,
            decodeTimeStamp: now)

        do {
            if #available(iOS 13.0, *) {
                return try CMSampleBuffer(
                    imageBuffer: pixelBuffer!,
                    formatDescription: formatDescription!,
                    sampleTiming: timingInfo)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
