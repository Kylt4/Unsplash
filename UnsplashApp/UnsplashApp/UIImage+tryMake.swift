//
//  UIImage+tryMake.swift
//  UnsplashFeediOS
//
//  Created by Christophe Bugnon on 24/06/2025.
//

import UIKit

public extension UIImage {
    struct InvalidImageData: Error {}

    static func tryMake(data: Data) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let source = CGImageSourceCreateWithData(data as CFData, nil),
                      let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, nil) else {
                    continuation.resume(throwing: InvalidImageData())
                    return
                }

                let image = UIImage(cgImage: cgImage)
                continuation.resume(returning: image)
            }
        }
    }

    static func tryMakeThumbnail(data: Data) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                    continuation.resume(throwing: InvalidImageData())
                    return
                }

                let options: [NSString: Any] = [
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceThumbnailMaxPixelSize: 300,
                    kCGImageSourceCreateThumbnailWithTransform: true
                ]

                guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
                    continuation.resume(throwing: InvalidImageData())
                    return
                }

                let image = UIImage(cgImage: cgImage)
                continuation.resume(returning: image)
            }
        }
    }
}
