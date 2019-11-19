//
//  ViewController.swift
//  DrawSignature
//
//  Created by Manjeet kumar on 19/11/19.
//  Copyright © 2019 ManjeetKumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var canvas: SignatureCanvasViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.currentImage = UIImage(named:"sampleImage")
    }
    
    @IBAction func signatureDone(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: String(describing: ShowSignedImageViewController.self)) as! ShowSignedImageViewController
        controller.currentImage = canvas.mainImageView.image
        present(controller, animated: true, completion: nil)
    }
    

}

