//
//  SJAssetStore.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import Foundation
import Photos

class SJAssetStore {
    static let changedNotification = Notification.Name("sjAssets.changedNotification")
    private(set) var assets = [PHAsset]()
    func append(_ asset: PHAsset) {
        guard !contains(asset) else { return }
        assets.append(asset)
        NotificationCenter.default.post(name: SJAssetStore.changedNotification, object: self, userInfo: [SJAssetStore.changeReasonKey: SJAssetStore.appendKey, SJAssetStore.valueKey : asset])
    }

    func remove(_ asset: PHAsset) {
        guard contains(asset) else { return }
        assets = assets.filter({$0 != asset})
        NotificationCenter.default.post(name: SJAssetStore.changedNotification, object: self, userInfo: [SJAssetStore.changeReasonKey: SJAssetStore.removeKey, SJAssetStore.valueKey : asset])
    }

    func contains(_ asset: PHAsset) -> Bool {
        return assets.contains(asset)
    }
}

extension SJAssetStore {
    static let changeReasonKey = "reason"
    static let valueKey = "value"
    static let appendKey = "append"
    static let removeKey = "remove"
}



