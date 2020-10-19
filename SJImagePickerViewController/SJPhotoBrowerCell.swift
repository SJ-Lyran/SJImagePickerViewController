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
            SJImageManager.requestImage(for: asset, itemSize: bounds.size, isNetworkAccessAllowed: true) { [weak self] (progress, error, _, _) in
                DispatchQueue.main.sync {
                    self?.progressView.isHidden = false
                    self?.progressView.progress = CGFloat(progress)
                }
            } resultHandler: { [weak self] (image, info) in
                self?.progressView.isHidden = true
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
        contentView.addSubview(progressView)
        progressView.isHidden = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = contentView.safeAreaLayoutGuide.topAnchor
        } else {
            topAnchor = contentView.topAnchor
        }
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 32),
            progressView.heightAnchor.constraint(equalToConstant: 32),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: 14)
        ])
    }
    lazy var progressView = SJLoadingIndicator()
}
