//
//  SJPhotoBrowerCell.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit
import Photos

class SJPhotoBrowerCell: UICollectionViewCell {
    var representedAssetIdentifier: String!
    var asset: PHAsset? {
        didSet {
            guard let asset = asset else {
                photoImageView.image = nil
                return
            }
            representedAssetIdentifier = asset.localIdentifier
            SJImageManager.requestImage(for: asset, itemSize: bounds.size) { [weak self] (image, _) in
                if self?.representedAssetIdentifier == asset.localIdentifier {
                    self?.photoImageView.image = image
                }
            }
        }
    }

    private var photoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        photoImageView.contentMode = .scaleAspectFit
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
