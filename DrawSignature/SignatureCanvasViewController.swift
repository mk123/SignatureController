//
//  SignatureCanvasViewController.swift
//  DrawSignature
//
//  Created by Manjeet kumar on 19/11/19.
//  Copyright © 2019 ManjeetKumar. All rights reserved.
//

import UIKit

class SignatureCanvasViewController: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var cvColorPallete: UICollectionView!
    
    var colorsArray = [UIColor.black, UIColor.red, UIColor.gray, UIColor.green, UIColor.blue]
    var currentImage:UIImage?{
        didSet{
            mainImageView.image = currentImage
        }
    }
    
    private var selectedColorIndex = 0
    private var lastPoint = CGPoint.zero
    private var color = UIColor.black
    private var brushWidth: CGFloat = 5
    private var opacity: CGFloat = 1.0
    private var swiped = false
    private var isCanvasBlank = true

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        color = colorsArray.first ?? .black
        cvColorPallete.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        cvColorPallete.dataSource = self
        cvColorPallete.delegate = self
        mainImageView.image = currentImage
    }

      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }
        swiped = false
        lastPoint = touch.location(in: self.contentView)
      }
      
      override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }

        // 6
        swiped = true
        let currentPoint = touch.location(in: self.contentView)
        drawLine(from: lastPoint, to: currentPoint)
          
        // 7
        lastPoint = currentPoint
      }
      
      func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(self.contentView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
          return
        }
        tempImageView.image?.draw(in: self.contentView.bounds)
          
        // 2
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        // 3
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        // 4
        context.strokePath()
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
      }

      override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
          // draw a single point
          drawLine(from: lastPoint, to: lastPoint)
        }
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: self.contentView.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: self.contentView.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil
        isCanvasBlank = false
      }
      
      @IBAction func resetPressed(_ sender: Any) {
        mainImageView.image = currentImage
        self.isCanvasBlank = true
    }
    
}

    extension SignatureCanvasViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return colorsArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
            cell.contentView.backgroundColor = colorsArray[indexPath.row]
            cell.contentView.layer.cornerRadius = cell.frame.size.width/2
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (indexPath.row == selectedColorIndex) ? 60 : 50, height: (indexPath.row == selectedColorIndex) ? 60 : 50)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            color = colorsArray[indexPath.row]
            selectedColorIndex = indexPath.row
            collectionView.reloadData()
        }

    }
