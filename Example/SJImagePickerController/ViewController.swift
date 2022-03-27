//
//  ViewController.swift
//  SJImagePickerController
//
//  Created by sj-lyran on 03/26/2022.
//  Copyright (c) 2022 sj-lyran. All rights reserved.
//

import UIKit
import SJImagePickerController

class ViewController: UIViewController {
    
    @IBOutlet weak var demoImageView: UIImageView!
    
    @IBAction func present(_ sender: Any) {
        let imagePicker = SJImagePickerController(delegate: self)
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: SJImagePickerControllerDelegate {
    func imagePickerController(_ picker: SJImagePickerController, didFinishPickingMediaWithInfo info: [SJImagePickerController.InfoKey : Any]) {
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

