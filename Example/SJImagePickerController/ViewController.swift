//
//  ViewController.swift
//  SJImagePickerController
//
//  Copyright © 2019 sheng. All rights reserved.
//

import UIKit

import Photos

class ViewController: UIViewController {
    @IBOutlet weak var demoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openCamera(_ sender: UIButton) {
        let imagePicker = SJImagePickerController(delegate: self)
//        imagePicker.albumRowCellCount = 4
        imagePicker.maximumSelectedPhotoCount = 30
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: SJImagePickerControllerDelegate {
    func imagePickerController(_ picker: SJImagePickerController, didFinishPickingMediaWithInfo info: [SJImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        if let images = info[.metaData] as? [Data], !images.isEmpty {
            print(images)
            demoImageView.image = UIImage(data: images[0])
        } else {
            print("--------images")
        }
    }

    func imagePickerControllerDidCancel(_ picker: SJImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

