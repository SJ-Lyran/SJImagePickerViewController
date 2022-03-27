//
//  SJAssetStore.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import Foundation
import Photos

class SJCollection {
    var albumTitle: String
    var assetResult: PHFetchResult<PHAsset>
    init(albumTitle: String, assetResult: PHFetchResult<PHAsset>) {
        self.albumTitle = albumTitle
        self.assetResult = assetResult
    }
}
