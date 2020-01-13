//
//  Helpers.swift
//  SJImagePickerController
//
//  Copyright © 2020 sheng. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        if let url = Bundle.main.url(forResource: "SJImageResource", withExtension: "bundle"), let bundle = Bundle(url: url) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        } else {
            fatalError("check SJImageResource.bundle Localizable.strings")
        }
    }

    func localized(with argument: Int) -> String {
        String.localizedStringWithFormat(localized, argument)
    }
}

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



