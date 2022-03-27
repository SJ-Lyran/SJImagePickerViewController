//
//  SJPhotosManager.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import Foundation
import UIKit
import Photos

final class SJAssetCollection {
    private(set) var assets = [SJCollection]()
    init() { getAlbumsList() }
    private func getAlbumsList() {
        let photos = SJCollection(albumTitle: Localization.string("allPhotos"), assetResult: allPhotos)
        assets = [photos]
        userCollections.enumerateObjects { [weak self] (collection, idx, stop) in
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: allPhotosOptions)
            if let localizedTitle = collection.localizedTitle {
                self?.assets.append(SJCollection(albumTitle: localizedTitle, assetResult: fetchResult))
            }
        }
    }

    public func refreshAssets() {
        getAlbumsList()
    }

    lazy var allPhotos: PHFetchResult<PHAsset> = {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }()

    lazy var smartAlbums: PHFetchResult<PHAssetCollection> = {
        return PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
    }()

    lazy var userCollections: PHFetchResult<PHCollection> = {
        return PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }()
}
