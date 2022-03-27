//
//  SJSelectedAlbumsCell.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit
import Photos

protocol SJSelectedAlbumsCellDelegate: class {
    func didDelete(cell: SJSelectedAlbumsCell)
}

class SJSelectedAlbumsCell: UICollectionViewCell {
    weak var delegate: SJSelectedAlbumsCellDelegate?
    private var representedAssetIdentifier: String!
    var asset: SJAsset? {
        didSet {
            guard let asset = asset else {
                photoImageView.image = nil
                return
            }
            representedAssetIdentifier = asset.asset.localIdentifier
            SJImageManager.requestImage(for: asset.asset, itemSize: bounds.size, progressHandler: nil) { [weak self] (image, _) in
                if self?.representedAssetIdentifier == asset.asset.localIdentifier {
                    self?.photoImageView.image = image
                }
            }
            photoImageView.layer.borderWidth = asset.isSelected ? 4 : 0
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private func setupUI() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(deleteButton)
        setupConstraint()
    }
    private func setupConstraint() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 54),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 27),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 4.0
        imageView.layer.borderColor = UIView().tintColor.cgColor
        return imageView
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        let minusImage = UIImage(bundleNamed: "minus_circle")
        button.setImage(minusImage, for: .normal)
        button.addTarget(self, action: #selector(deleteItem(sender:)), for: .touchUpInside)
        return button
    }()

    @objc private func deleteItem(sender: UIButton) {
        delegate?.didDelete(cell: self)
    }
}
