//
//  SJAlbumsListView.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit
import Photos

class SJAlbumsListView: UIView {
    private let reuseIdentifier = String(describing: SJAlbumsCell.self)
    var completeHandler: ((_ asset: SJCollection?) -> Void)?
    var photos: [SJCollection] = [] {
        didSet {
            albumsTableView.reloadData()
        }
    }
    let albumsTableView = UITableView(frame: CGRect.zero, style: .plain)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        albumsTableView.register(SJAlbumsListCell.self, forCellReuseIdentifier: reuseIdentifier)
        albumsTableView.rowHeight = 90
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        albumsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        addSubview(albumsTableView)
        albumsTableView.translatesAutoresizingMaskIntoConstraints = false
        albumsTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        albumsTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        albumsTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        let bottomConstraint = albumsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        bottomConstraint.priority = UILayoutPriority.defaultLow
        bottomConstraint.isActive = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        completeHandler?(nil)
    }
}

extension SJAlbumsListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SJAlbumsListCell
        cell.asset = photos[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let asset = photos[indexPath.row]
        completeHandler?(asset)
    }

}


