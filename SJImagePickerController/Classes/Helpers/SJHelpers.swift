//
//  Helpers.swift
//  SJImagePickerController
//
//  Copyright © 2020 sheng. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    var sjIPC: SJImagePickerController {
        if let nav = self as? SJImagePickerController {
            return nav
        } else {
            fatalError("need SJImagePickerController")
        }
    }
}

extension UIAlertController {
    static func present(in viewController: UIViewController,
                        title: String?,
                        message: String?,
                        style: UIAlertController.Style = .alert,
                        actions: [UIAlertAction]) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: style)
        actions.forEach(alert.addAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension Bundle {
    static let resourceBundle: Bundle = {
        let bundle: Bundle
#if SWIFT_PACKAGE
        bundle = Bundle.module
#else
        bundle = Bundle(for: SJImageManager.self)
        guard let path = bundle.path(forResource: "SJImagePickerController", ofType: "bundle"), let bundle = Bundle(path: path) else {
            fatalError("check SJImagePickerController.bundle")
        }
#endif
        return bundle
    }()
}
enum Localization {
    static func string(_ key: String) -> String {
        return NSLocalizedString(key, bundle: .resourceBundle, comment: "")
    }
    static func string(_ key: String, number: Int) -> String {
        return String.localizedStringWithFormat(string(key), number)
    }
}

extension UIImage {
    convenience init?(bundleNamed name: String, compatibleWith trait: UITraitCollection? = nil) {
        self.init(named: name, in: .resourceBundle, compatibleWith: trait)
    }
}

extension String {
    static let SJIgnoreLimitedKey = "com.sheng.SJImagePickerController.SJIgnoreLimitedKey"
}




