//
//  SJSelectedAlbumsView.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit
import Photos

protocol SJSelectedAlbumsViewDelegate: class {
    func didSelect(item: PHAsset)
    func didDelete(item: PHAsset)
}

class SJSelectedAlbumsView: UIView {
    weak var delegate: SJSelectedAlbumsViewDelegate?
    var selectedAsset: [SJAsset] = [] {
        didSet {
            isHidden = selectedAsset.isEmpty
            selectedCollectionView.reloadData()
            let index = selectedAsset.firstIndex(where: {$0.isSelected})
            if let index = index {
                selectedCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
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
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(selectedCollectionView)
        selectedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedCollectionView.topAnchor.constraint(equalTo: topAnchor),
            selectedCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        let lineView = UIView()
        lineView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    lazy var selectedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        let identifier = String(describing: SJSelectedAlbumsCell.self)
        collectionView.register(SJSelectedAlbumsCell.self, forCellWithReuseIdentifier: identifier)
        return collectionView
    }()

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 70, height: 80)
        return layout
    }()
}

extension SJSelectedAlbumsView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAsset.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = selectedAsset[indexPath.item]
        let identifier = String(describing: SJSelectedAlbumsCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SJSelectedAlbumsCell else {
            fatalError("Unexpected cell in collection view")
        }
        cell.delegate = self
        cell.asset = asset
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedItem = selectedAsset[indexPath.item]
        delegate?.didSelect(item: selectedItem.asset)
    }

}

extension SJSelectedAlbumsView: SJSelectedAlbumsCellDelegate {
    func didDelete(cell: SJSelectedAlbumsCell) {
        guard let indexPath = selectedCollectionView.indexPath(for: cell) else { return }
        let selectedItem = selectedAsset[indexPath.item]
        delegate?.didDelete(item: selectedItem.asset)
    }

}
