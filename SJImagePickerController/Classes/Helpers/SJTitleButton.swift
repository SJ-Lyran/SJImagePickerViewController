//
//  SJTitleButton.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit

private let SJMargin: CGFloat = 5
private let SJTitleFixedWidth: CGFloat = 50
class SJTitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private func setupUI() {
        if #available(iOS 13.0, *) {
            tintColor = .label
            setTitleColor(.label, for: .normal)
        } else {
            tintColor = .black
            setTitleColor(.black, for: .normal)
        }
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        let normalImage = UIImage(bundleNamed: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(bundleNamed: "chevron.up")?.withRenderingMode(.alwaysTemplate)
        setImage(normalImage, for: .normal)
        setImage(selectedImage, for: .selected)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if frame.width > SJTitleFixedWidth + SJMargin {
            titleLabel?.frame.origin.x = 0
        } else {
            let titleW = titleLabel?.frame.width ?? 0
            let imageW = imageView?.frame.width ?? 0
            titleLabel?.frame.origin.x = (frame.width-titleW-imageW-SJMargin)/2.0
        }
        imageView?.frame.origin.x = (titleLabel?.frame.origin.x ?? 0) + (titleLabel?.frame.width ?? 0) + SJMargin
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        let size = sizeThatFits(CGSize.zero)
        let buttonW = size.width > SJTitleFixedWidth ? size.width : SJTitleFixedWidth
        frame.size = CGSize(width: buttonW + SJMargin, height: frame.size.height)
    }

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        let size = sizeThatFits(CGSize.zero)
        let buttonW = size.width > SJTitleFixedWidth ? size.width : SJTitleFixedWidth
        frame.size = CGSize(width: buttonW + SJMargin, height: frame.size.height)
    }
}
