//
//  SJAlbumsViewController.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit
import Photos

final class SJAlbumsViewController: UIViewController {
    private var selectedAssets = SJAssetStore()
    private let photosManager = SJAssetCollection()
    private let albumslist = SJAlbumsListView()
    private var albumslistHeightConstraintLow: NSLayoutConstraint!
    private var albumslistHeightConstraintHight: NSLayoutConstraint!
    private var selectedDisabled = false

    var fetchResult: PHFetchResult<PHAsset> = PHFetchResult() {
        didSet {
            if fetchResult != oldValue {
                collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupUI()
        checkAuthorizationStatus()
    }

    private func start() {
        fetchResult = SJAssetCollection().allPhotos
        setupAlbumsList()
        setupObserver()
    }

    private func askPermission() {
        let cancelAction = UIAlertAction(title: Localization.string("ok"), style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        let settingAction = UIAlertAction(title: Localization.string("settings"), style: .default) { (_) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        UIAlertController.present(in: self, title: nil, message: Localization.string("privacy.photoLibrary.message"), actions: [cancelAction, settingAction])
    }

    private func checkAuthorizationStatus() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized: start()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.start()
                    } else {
                        self.askPermission()
                    }
                }
            }
        default: self.askPermission()
        }
    }

    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAssets(_:)), name: SJAssetStore.changedNotification, object: nil)
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    @objc private func handleAssets(_ notification: Notification) {
        guard let assets = notification.object as? SJAssetStore else { return }
        if !assets.assets.isEmpty {

            doneItem.title = "(\(assets.assets.count))\(Localization.string("done"))"
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            doneItem.title = Localization.string("done")
            navigationItem.rightBarButtonItem?.isEnabled = false
        }

        guard let reason = notification.userInfo?[SJAssetStore.changeReasonKey] as? String, let asset = notification.userInfo?[SJAssetStore.valueKey] as? PHAsset else { return }
        let index = fetchResult.index(of: asset)
        selectedDisabled = false
        switch (reason) {
        case SJAssetStore.appendKey:
            if assets.assets.count >= navigationController?.sjIPC.maximumSelectedPhotoCount ?? 0 {
                selectedDisabled = true
                collectionView.reloadData()
            } else {
                collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        case SJAssetStore.removeKey:
            if assets.assets.count + 1 ==   navigationController?.sjIPC.maximumSelectedPhotoCount {
                collectionView.reloadData()
            } else {
                var paths = selectedAssets.assets.map{ IndexPath(item: fetchResult.index(of: $0), section: 0) }
                paths.append(IndexPath(item: index, section: 0))
                collectionView.reloadItems(at: paths)
            }
        default:
            collectionView.reloadData()
        }
    }
    private func setupAlbumsList() {
        albumslist.photos = photosManager.assets
        albumslist.completeHandler = { [weak self] asset in
            guard let strongSelf = self else { return }
            if let asset = asset {
                strongSelf.fetchResult = asset.assetResult
                strongSelf.titleButton.setTitle(asset.albumTitle, for: .normal)
            }
            strongSelf.titleAction(sender: strongSelf.titleButton)
        }
        view.addSubview(albumslist)
        albumslist.translatesAutoresizingMaskIntoConstraints = false
        albumslist.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        albumslist.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        albumslist.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        albumslistHeightConstraintHight = albumslist.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        albumslistHeightConstraintLow = albumslist.bottomAnchor.constraint(equalTo: view.topAnchor)
        albumslistHeightConstraintLow.isActive = true
    }

    lazy var doneItem = UIBarButtonItem(title: Localization.string("done"), style: .done, target: self, action: #selector(doneAction))

    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localization.string("cancel"), style: .done, target: self, action: #selector(cancelPick))
        titleButton.setTitle(Localization.string("allPhotos"), for: .normal)
        navigationItem.titleView = titleButton
        navigationItem.rightBarButtonItem = doneItem
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    @objc private func doneAction() {
        navigationController?.sjIPC.didFinishPicking(selectedAssets.assets)
    }

    @objc private func cancelPick() {
        guard let nav = navigationController?.sjIPC else {
            fatalError("need SJImagePickerController")
        }
        nav.pickerDelegate?.imagePickerControllerDidCancel(nav)
    }

    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor =  .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        let identifier = String(describing: SJAlbumsCell.self)
        collectionView.register(SJAlbumsCell.self, forCellWithReuseIdentifier: identifier)
        return collectionView
    }()

    lazy var flowLayout: UICollectionViewFlowLayout = {
        guard let nav = navigationController?.sjIPC else {
            fatalError("need SJImagePickerController")
        }
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = nav.albumMinimumLineSpacing
        flowLayout.minimumInteritemSpacing = nav.albumMinimumInteritemSpacing
        flowLayout.itemSize = nav.albumItemSize
        flowLayout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        return flowLayout
    }()

    lazy var titleButton: SJTitleButton = {
        let button = SJTitleButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.addTarget(self, action: #selector(titleAction(sender:)), for: .touchUpInside)
        return button
    }()

    func clickAlbumsList(isSelected: Bool) {
        albumslistHeightConstraintLow.isActive = false
        albumslistHeightConstraintHight.isActive = false
        albumslistHeightConstraintLow.isActive = !isSelected
        albumslistHeightConstraintHight.isActive = isSelected
    }

    @objc private func titleAction(sender: SJTitleButton) {
        sender.isSelected.toggle()
        clickAlbumsList(isSelected: sender.isSelected)
    }
}

extension SJAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = fetchResult.object(at: indexPath.item)
        let identifier = String(describing: SJAlbumsCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SJAlbumsCell else {
            fatalError("Unexpected cell in collection view")
        }
        let index = selectedAssets.assets.firstIndex(of: asset) ?? -1
        let model = SJAsset(asset, isSelected: index >= 0, index: index)
        model.disabled = selectedDisabled
        cell.delegate = self
        cell.asset = model
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let photoBrower = SJPhotoBrowerViewController(index: indexPath.item, assets: fetchResult, selectedAssets: selectedAssets)
        navigationController?.pushViewController(photoBrower, animated: true)
    }

}

extension SJAlbumsViewController: SJAlbumsCellDelegate {
    func tap(item: SJAlbumsCell, asset: PHAsset) {
        if selectedAssets.contains(asset) {
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


