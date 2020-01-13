//
//  SJAsset.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import Foundation
import Photos

class SJAsset {
    var isSelected = false
    /// asset
    let asset: PHAsset
    /// number
    let index: Int

    var disabled = false
    
    init(_ asset: PHAsset, isSelected: Bool = false, index: Int) {
        self.asset = asset
        self.isSelected = isSelected
        self.index = index
    }
}
