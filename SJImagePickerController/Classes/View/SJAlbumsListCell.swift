//
//  SJAlbumsListCell.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit

final class SJAlbumsListCell: UITableViewCell {

    var asset: SJCollection? {
        didSet {
            albumTitle.text = asset?.albumTitle
            guard let firstAsset = asset?.assetResult.firstObject else {
                albumImageView.image = nil
                return
            }
            SJImageManager.requestImage(for: firstAsset, itemSize: contentView.frame.size, progressHandler: nil) { [weak self] (image, _) in
                self?.albumImageView.image = image
            }
        }
    }

    private let albumImageView = UIImageView()
    private let albumTitle = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        albumImageView.backgroundColor = .gray
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.clipsToBounds = true
        contentView.addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            albumImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumImageView.widthAnchor.constraint(equalTo: albumImageView.heightAnchor),
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])

        if #available(iOS 13.0, *) {
            albumTitle.textColor = .label
        } else {
            albumTitle.textColor = .black
        }
        albumTitle.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(albumTitle)
        albumTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumTitle.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 18),
            albumTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumTitle.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -15)
        ])
    }

}
