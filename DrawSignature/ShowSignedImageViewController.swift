//
//  ShowSignedImageViewController.swift
//  DrawSignature
//
//  Created by Manjeet kumar on 19/11/19.
//  Copyright © 2019 ManjeetKumar. All rights reserved.
//

import UIKit

class ShowSignedImageViewController: UIViewController {
    @IBOutlet public weak var imvSignedImage: UIImageView!
    
    var currentImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imvSignedImage.image = currentImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
