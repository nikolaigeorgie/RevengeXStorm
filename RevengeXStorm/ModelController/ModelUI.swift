//
//  ModelUI.swift
//  RevengeXStorm
//
//  Created by Nikolas Andryuschenko on 12/1/17.
//  Copyright © 2017 Nikolas Andryuschenko. All rights reserved.
//

import UIKit
import ChromaColorPicker
import ARKit

extension ModelController {
    
    func setupColorPicker() {
        /* Calculate relative size and origin in bounds */
        
        print("here is the width", self.view.frame.width)
        var pickerSize = CGSize()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
         pickerSize = CGSize(width: view.frame.width / 1.5, height: view.frame.width / 1.5)
            
        case .pad:
     pickerSize = CGSize(width: view.frame.width / 2, height: view.frame.width / 2)
            
        // It's an iPad
        case .unspecified:
            break
        // Uh, oh! What could it be?
        case .tv:
            break
        case .carPlay:
            break
        }
        
        
        3333
        
        
        
        let pickerOrigin = CGPoint(x: view.bounds.midX - pickerSize.width/2, y: view.bounds.maxY - pickerSize.width / 0.95)
        
        /* Create Color Picker */
        colorPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        
        //        colorPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        colorPicker.delegate = self
        
        /* Customize the view (optional) */
        colorPicker.padding = 10
        colorPicker.stroke = 3 //stroke of the rainbow circle
        colorPicker.currentAngle = Float.pi
        colorPicker.alpha = 0
        /* Customize for grayscale (optional) */
        colorPicker.supportsShadesOfGray = true // false by default
        //colorPicker.colorToggleButton.grayColorGradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor] // You can also override gradient colors
        
        //        colorPicker.addTarget(self, action: #selector(handeTheColor), for: .valueChanged)
        
        colorPicker.hexLabel.textColor = UIColor.white
        colorPicker.isHidden = false
        
        /* Don't want an element like the shade slider? Just hide it: */
        //colorPicker.shadeSlider.hidden = true
        
        
        
        self.view.addSubview(colorPicker)
    
        
    }
    
    
    
    func setupFrameView() {
        
        view.backgroundColor = .black
        frameImageView.backgroundColor = .black
        view.addSubview(frameImageView)
        frameImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        view.addSubview(sceneViewer)
        
//        sceneViewer.allowsCameraControl = true
        //        sceneViewer.autoenablesDefaultLighting = true
        
                sceneViewer.scene = SCNScene(named: "Shoes.scnassets/RevengeXStormShoe.scn")!
//                sceneViewer.scene = SCNScene(named: "Shoes.scnassets/Cube.scn")!
        sceneViewer.backgroundColor = .clear
        
        sceneViewer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:))))
        sceneViewer.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(sender:))))
        
        
        sceneViewer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        sceneViewer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        sceneViewer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        sceneViewer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
        sceneViewer.layer.cornerRadius = self.view.frame.height / 2
        
        
        self.containerShoeNode = self.sceneViewer.scene?.rootNode.childNode(withName: "shoeContainer", recursively: true)
        
        self.shoeNode = containerShoeNode?.childNode(withName: "shoe", recursively: true)
        
        containerShoeNode?.scale = SCNVector3Make(0.0300000038, 0.0300000038, 0.0300000038)

        //        shoeNode?.scale = SCNVector3Make(0.06, 0.06, 0.06)
        //        shoeNode?.rotation = SCNVector4Make(-100.0, 100.0, 200.0, 300.0)

//                shoeNode?.position = SCNVector3Make(-0.004, -0.01, -0.02)
        
        view.addSubview(revengeXStormLogoImageView)
        //        revengeXStormLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        revengeXStormLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
        revengeXStormLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        revengeXStormLogoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.60).isActive = true
        revengeXStormLogoImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        view.addSubview(stackView)
        
        stackView = UIStackView(arrangedSubviews: [bodyButton, lightingBoltButton])
        
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: sceneViewer.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: revengeXStormLogoImageView.bottomAnchor, constant: 0).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //        stackView.setCustomSpacing(20.0, after: bodyButton)
        
        lightingBoltButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bodyButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lightingBoltButton.layer.cornerRadius = 20
        bodyButton.layer.cornerRadius = 20
        
        lightingBoltButton.sd_setImage(with: URL(string: lightningBolt), placeholderImage: #imageLiteral(resourceName: "lightningBolt"))
        lightingBoltButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLightingSelection)))
        
        lightingBoltButton.isUserInteractionEnabled = true
        
        //        view.addSubview(selectShoeTextureButton)
        //        selectShoeTextureButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        shoeNode?.geometry?.material(named: "Body")?.diffuse.contents = UIColor.black
        ViewController.bodyColor = UIColor.black
        bodyButton.backgroundColor = UIColor.black
        ViewController.bodyImage = UIImage()
        ViewController.boltImage = UIImage()
        
        setupColorPicker()
        
        view.addSubview(doneButton)
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        ViewController.bodyImage = #imageLiteral(resourceName: "FIRE")
        shoeNode?.geometry?.material(named: "Body")?.diffuse.contents = ViewController.bodyImage
    }
}



extension ModelController: ChromaColorPickerDelegate {
    func didUpdateColorSlider(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
        if selectedItem == "light" {
            shoeNode?.geometry?.material(named: "lightingBolt")?.diffuse.contents = color
            ViewController.boltColor = color
            ViewController.boltImage = UIImage()
        } else {
            shoeNode?.geometry?.material(named: "Body")?.diffuse.contents = color
            ViewController.bodyColor = color
            bodyButton.backgroundColor = color
            ViewController.bodyImage = UIImage()
        }

    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
        texturesPurchase = UserDefaults.standard.bool(forKey: "TexturesPurchase")
        
        if texturesPurchase == true {
            presentPicker()
        } else {
            checkIfPurchased()
        }
    
    }
    
    
}


