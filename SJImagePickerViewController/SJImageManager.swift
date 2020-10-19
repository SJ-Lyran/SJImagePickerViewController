//
//  SJImageManager.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import Foundation
import UIKit
import Photos

class SJImageManager {
    static func requestImage(
        for asset: PHAsset,
        itemSize: CGSize,
        isNetworkAccessAllowed: Bool = false,
        progressHandler: PHAssetImageProgressHandler?,
        resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) {
        let scale: CGFloat = 2
        let targetSize = CGSize(width: itemSize.width * scale, height: itemSize.height * scale)
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = isNetworkAccessAllowed
        options.progressHandler = progressHandler
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: resultHandler)
    }

    static func requestImageData(
        for asset: PHAsset,
        options: PHImageRequestOptions?,
        resultHandler: @escaping (Data?, String?, UIImage.Orientation, [AnyHashable : Any]?) -> Void) {
        PHImageManager().requestImageData(for: asset, options: options, resultHandler: resultHandler)
    }

    static func fetchAssets(
        for assets: [PHAsset],
        contentMode: PHImageContentMode = .aspectFit,
        itemSize: CGSize) -> [UIImage] {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        var images = [UIImage]()
        assets.forEach { (item) in
            imageManager.requestImage(for: item, targetSize: itemSize, contentMode: contentMode, options: options) { (image, _) in
                if let image = image {
                    images.append(image)
                }
            }
        }
        return images
    }

    static func fetchAssetsData(
        for assets: [PHAsset]) -> [Data] {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        var allData = [Data]()
        assets.forEach { (item) in
            imageManager.requestImageData(for: item, options: options) {  (data, a, orientation, info) in
                if let data = data {
                    allData.append(data)
                }
            }
        }
        return allData
    }
}
