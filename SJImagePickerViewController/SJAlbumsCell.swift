//
//  SJAlbumsCell.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit
import Photos

protocol SJAlbumsCellDelegate: class {
    func tap(item: SJAlbumsCell, asset: PHAsset)
}

private let thumbnailNormalColor = UIColor(white: 0, alpha: 0.5).cgColor
private let thumbnailDisabledColor = UIColor(white: 1, alpha: 0.5).cgColor

class SJAlbumsCell: UICollectionViewCell {
    weak var delegate: SJAlbumsCellDelegate?
    var asset: SJAsset? {
        didSet {
            guard let asset = asset else {
                thumbnailImageView.image = nil
                indexButton.isSelected = false
                return
            }
            representedAssetIdentifier = asset.asset.localIdentifier
            SJImageManager.requestImage(for: asset.asset, itemSize: bounds.size, progressHandler: nil) { [weak self] (image, _) in
                guard self?.representedAssetIdentifier == asset.asset.localIdentifier else { return }
                self?.thumbnailImageView.image = image
            }
            indexButton.setTitle(asset.index >= 0 ? "\(asset.index+1)" : nil, for: .selected)
            indexButton.isSelected = asset.isSelected
            let cellHalfW = (bounds.width/2).rounded(.awayFromZero)
            let thumbnailBorderColor: CGColor
            let thumbnailBorderWidth: CGFloat
            if asset.disabled {
                thumbnailBorderColor = asset.isSelected ? thumbnailNormalColor : thumbnailDisabledColor
                thumbnailBorderWidth = asset.isSelected ? (indexButton.isSelected ? cellHalfW : 0) : cellHalfW
            } else {
                thumbnailBorderColor = thumbnailNormalColor
                thumbnailBorderWidth = indexButton.isSelected ? cellHalfW : 0
            }
            thumbnailImageView.layer.borderColor = thumbnailBorderColor
            thumbnailImageView.layer.borderWidth = thumbnailBorderWidth
        }
    }

    private var thumbnailImageView = UIImageView()
    private var representedAssetIdentifier: String!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    /// 选择按钮
    lazy var indexButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(nil, for: .normal)
        button.setTitle("", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.isUserInteractionEnabled = false
        button.setBackgroundImage(UIImage(bundleNamed: "circle"), for: .normal)
        button.setBackgroundImage(UIImage(bundleNamed: "circle.fill"), for: .selected)
        return button
    }()

    /// 触摸view
    lazy var tapView: UIView = {
        let tapView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapView.addGestureRecognizer(tapGesture)
        tapView.addSubview(indexButton)
        return tapView
    }()

    @objc private func tap() {
        guard let asset = asset else { return }
        delegate?.tap(item: self, asset: asset.asset)
    }

    private func setupUI() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.borderColor = thumbnailNormalColor
        thumbnailImageView.layer.borderWidth = 0
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(tapView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailImageView.frame = bounds
        tapView.frame = CGRect(x: bounds.width - 50, y: 0, width: 50, height: 50)
        indexButton.frame = CGRect(x: tapView.bounds.width - 2-24, y: 2, width: 24, height: 24)
    }

}
