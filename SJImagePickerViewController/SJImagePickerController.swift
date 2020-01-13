//
//  SJImagePickerController.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit
import Photos

extension SJImagePickerController {
    public struct InfoKey : Hashable, Equatable, RawRepresentable {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension SJImagePickerController.InfoKey {
    public static let exportImage = SJImagePickerController.InfoKey(rawValue: "exportImage")
    public static let metaData = SJImagePickerController.InfoKey(rawValue: "metaData")
    public static let phAsset = SJImagePickerController.InfoKey(rawValue: "phAsset")
}

public protocol SJImagePickerControllerDelegate: class {
    func imagePickerController(_ picker: SJImagePickerController, didFinishPickingMediaWithInfo info: [SJImagePickerController.InfoKey : Any])
    func imagePickerControllerDidCancel(_ picker: SJImagePickerController)
}
extension SJImagePickerControllerDelegate {
    func imagePickerController(_ picker: SJImagePickerController, didFinishPickingMediaWithInfo info: [SJImagePickerController.InfoKey : Any]) {}
    func imagePickerControllerDidCancel(_ picker: SJImagePickerController) {}
}

open class SJImagePickerController: UINavigationController {
    weak var pickerDelegate: SJImagePickerControllerDelegate?
    open var exportPhotoSize: CGSize = CGSize(width: 600, height: 800)
    open var exportContentMode: PHImageContentMode = .aspectFit
    open var isExportOriginalImage = false

    open var albumMinimumLineSpacing: CGFloat = 2
    open var albumMinimumInteritemSpacing: CGFloat = 2
    open var albumRowCellCount: CGFloat = 3

    open var maximumSelectedPhotoCount = 9

    var albumItemSize: CGSize {
        let itemW = (UIScreen.main.bounds.width - (albumRowCellCount-1)*albumMinimumLineSpacing)/albumRowCellCount
        return CGSize(width: itemW, height: itemW)
    }

    internal func didFinishPicking(_ assets: [PHAsset]) {
        let mode: PHImageContentMode = isExportOriginalImage ? .default : exportContentMode
        let itemSize: CGSize = isExportOriginalImage ? PHImageManagerMaximumSize : exportPhotoSize
        let images = SJImageManager.fetchAssets(for: assets, contentMode: mode, itemSize: itemSize)
        let metaData = SJImageManager.fetchAssetsData(for: assets)
        let info: [SJImagePickerController.InfoKey : Any] =
            [SJImagePickerController.InfoKey.exportImage : images,
        SJImagePickerController.InfoKey.metaData : metaData,
        SJImagePickerController.InfoKey.phAsset : assets]
        pickerDelegate?.imagePickerController(self, didFinishPickingMediaWithInfo: info)
    }

    public convenience init(delegate: SJImagePickerControllerDelegate) {
        self.init()
        pickerDelegate = delegate
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [SJAlbumsViewController()]
    }
}



