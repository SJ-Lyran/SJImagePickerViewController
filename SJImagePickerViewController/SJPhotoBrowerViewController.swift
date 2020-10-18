//
//  SJPhotoBrowerViewController.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit
import Photos

class SJPhotoBrowerViewController: UIViewController {

    private var currentIndex: Int = 0 {
        didSet {
            guard currentIndex != oldValue else { return }
            updateUI(assets: selectedAssets.assets)
        }
    }
    private var selectedAssets = SJAssetStore()
    private var selectedDisabled = false

    convenience init(index: Int, assets: PHFetchResult<PHAsset>, selectedAssets: SJAssetStore) {
        self.init()
        fetchResult = assets
        currentIndex = index
        self.selectedAssets = selectedAssets
    }

    var fetchResult: PHFetchResult<PHAsset>! {
        didSet {
            if fetchResult != oldValue {
                collectionView.reloadData()
            }
        }
    }

    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAssets(_:)), name: SJAssetStore.changedNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleAssets(_ notification: Notification) {
        guard let assets = notification.object as? SJAssetStore else { return }
        if !assets.assets.isEmpty {
            importItem.title = "(\(assets.assets.count))\(Localization.string("done"))"
        } else {
            importItem.title = Localization.string("done")
        }
        updateUI(assets: assets.assets)
    }

    private func updateUI(assets: [PHAsset]) {
        navigationItem.title = "( \(currentIndex + 1) / \(fetchResult.count) )"
        let currentAsset = fetchResult.object(at: currentIndex)
        var fetchResult = [SJAsset]()
        bottomSelectButton.isSelected = false
        assets.forEach { (asset) in
            let sjAsset = SJAsset(asset, isSelected: currentAsset == asset, index: 0)
            fetchResult.append(sjAsset)
            if currentAsset == asset {
                bottomSelectButton.isSelected = true
            }
        }
        selectedAlbumsView.selectedAsset = fetchResult
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupUI()
        setupDataSourece()
        setupObserver()
        setupGestureRecognizer()
    }

    private func setupGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        collectionView.addGestureRecognizer(gesture)
    }

    @objc private func handleTap(sender: UIGestureRecognizer) {
        let isHidden = navigationController?.navigationBar.isHidden ?? false
        navigationController?.setNavigationBarHidden(!isHidden, animated: false)
        bottomSelectView.isHidden = !isHidden
        selectedAlbumsView.isHidden = !isHidden
    }

    lazy var importItem = UIBarButtonItem(title: Localization.string("done"), style: .done, target: self, action: #selector(importPhoto))

    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = importItem
        let isEmpty = selectedAssets.assets.isEmpty
        let title = isEmpty ? "" : "(\(selectedAssets.assets.count))"
        importItem.title = isEmpty ? Localization.string("done") : "\(title)\(Localization.string("done"))"
    }

    @objc private func importPhoto() {
        let asset = selectedAssets.assets.isEmpty ? [fetchResult.object(at: currentIndex)] : selectedAssets.assets
        navigationController?.sjIPC.didFinishPicking(asset)
    }

    private func setupDataSourece() {
        updateUI(assets: selectedAssets.assets)
        updateContentOffset(currentIndex)
    }

    private func updateContentOffset(_ index: Int) {
        collectionView.performBatchUpdates({ [weak self] in
            let size = UIScreen.main.bounds.size
            let shouldOffsetPoint = CGPoint(x: CGFloat(index) * (size.width + 20), y: 0)
            self?.collectionView.setContentOffset(shouldOffsetPoint, animated: false)
        }, completion: nil)
    }

    private func setupUI() {
        view.backgroundColor = .black
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(collectionView)
        view.addSubview(bottomSelectView)
        view.addSubview(selectedAlbumsView)
        setupConstraints()
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        bottomSelectView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchorConstraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            topAnchorConstraint = bottomSelectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        } else {
            topAnchorConstraint = bottomSelectView.heightAnchor.constraint(equalToConstant: 40)
        }
        NSLayoutConstraint.activate([
            bottomSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSelectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topAnchorConstraint
        ])
        selectedAlbumsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedAlbumsView.bottomAnchor.constraint(equalTo: bottomSelectView.topAnchor),
            selectedAlbumsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedAlbumsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedAlbumsView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    lazy var selectedAlbumsView: SJSelectedAlbumsView = {
        let albumsView = SJSelectedAlbumsView()
        albumsView.delegate = self
        return albumsView
    }()

    lazy var bottomSelectView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        bottomView.addSubview(bottomSelectButton)
        bottomSelectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSelectButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            bottomSelectButton.topAnchor.constraint(equalTo: bottomView.topAnchor),
            bottomSelectButton.widthAnchor.constraint(equalToConstant: 80),
            bottomSelectButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        return bottomView
    }()

    lazy var bottomSelectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(bundleNamed: "circle"), for: .normal)
        button.setImage(UIImage(bundleNamed: "circle.fill"), for: .selected)
        button.setTitle(Localization.string("select"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(selectPhoto(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        let identifier = String(describing: SJPhotoBrowerCell.self)
        collectionView.register(SJPhotoBrowerCell.self, forCellWithReuseIdentifier: identifier)
        return collectionView
    }()

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        layout.itemSize = view.frame.size
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return layout
    }()

    @objc private func selectPhoto(sender: UIButton) {
        let asset = fetchResult.object(at: currentIndex)
        if sender.isSelected {
            selectedAssets.remove(asset)
        } else {
            let maximum = navigationController?.sjIPC.maximumSelectedPhotoCount ?? 0
            if selectedAssets.assets.count >= maximum {
                let cancelAction = UIAlertAction(title: Localization.string("ok"), style: .cancel, handler: nil)
                UIAlertController.present(in: self, title: nil, message:
                    Localization.string("select.maximum", number: maximum), actions: [cancelAction])
            } else {
                selectedAssets.append(asset)
            }
        }
    }
}

extension SJPhotoBrowerViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x/scrollView.frame.width
        currentIndex = Int(index + 0.5)
    }
}

extension SJPhotoBrowerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = fetchResult.object(at: indexPath.item)
        let identifier = String(describing: SJPhotoBrowerCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SJPhotoBrowerCell else {
            fatalError("Unexpected cell in collection view")
        }
        cell.asset = asset
        return cell
    }
}

extension SJPhotoBrowerViewController: SJSelectedAlbumsViewDelegate {
    func didSelect(item: PHAsset) {
        let index = fetchResult.index(of: item)
        updateContentOffset(index)
    }

    func didDelete(item: PHAsset) {
        guard selectedAssets.contains(item) else { return }
        selectedAssets.remove(item)
    }
}
