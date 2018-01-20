//
//  ModelController.swift
//  RevengeXStorm
//
//  Created by Nikolas Andryuschenko on 11/7/17.
//  Copyright © 2017 Nikolas Andryuschenko. All rights reserved.
//


import UIKit
import SceneKit
import ModelIO
import SceneKit.ModelIO
import ColorSlider
import SDWebImage
import MobileCoreServices
import SwiftyStoreKit
import ChromaColorPicker
import AudioToolbox
import FirebaseAnalytics
import ARKit

class ModelController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedItem = ""
    var imagePicker = UIImagePickerController()
    
    
    var colorPicker: ChromaColorPicker!

    let generator = UIImpactFeedbackGenerator(style: .heavy)

    let lightningBolt = "https://firebasestorage.googleapis.com/v0/b/genzi-7ed81.appspot.com/o/bolt-transparent-crop.gif?alt=media&token=3e500a0a-91f1-4bf1-8e59-6e3374a75a4f"
    
    let sceneViewer: SCNView = {
        let sv = SCNView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var shoeNode : SCNNode?
    var containerShoeNode: SCNNode?
    var stackView = UIStackView()
    
    
    let frameImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "frame")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let bodyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(handleBodySelection), for: .touchUpInside)
        return button
    }()
    
    var texturesPurchase = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shoeNode?.scale = SCNVector3(0.77992680557, 0.77992680557, 0.77992680557)

    }
    
    func presentPicker() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        handleImageSelectedForInfo(info as [String : AnyObject])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {            
            if selectedItem == "light" {
                shoeNode?.geometry?.material(named: "lightingBolt")?.diffuse.contents = selectedImage
                ViewController.boltImage = selectedImage
            
            } else {
                ViewController.bodyImage = selectedImage
                shoeNode?.geometry?.material(named: "Body")?.diffuse.contents = selectedImage
                
            }
            
        }
    }
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let lightingBoltButton: FLAnimatedImageView = {
        let button = FLAnimatedImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let revengeXStormLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "revengeLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Done"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentModelViewController), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFrameView()
        //setupOriginalView()
        
    }
    
 
    
    @objc func presentModelViewController() {
        if ARConfiguration.isSupported == false {
            let alertController = UIAlertController(title: "AR NOT SUPPORTED", message: "Your phone does not support AR functionality", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            alertController.addAction(UIAlertAction(title: "Fasho", style: .default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            
        } else {

        let arController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(arController, animated: true, completion: nil)
        }
    }
    
    var isAnimating = false
    
    @objc func handleBodySelection() {
        
        generator.impactOccurred()
        
        if isAnimating == true {
            return
        }
        
        if selectedItem == "" {
            selectedItem = "body"
                self.isAnimating = true
            
            UIView.animate(withDuration: 0.4, animations: {
                self.doneButton.alpha = 0
                
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.colorPicker.alpha = 1
                }, completion: {(completed) in
                       self.isAnimating = false
                })
            })
            
        } else if selectedItem == "light" {
            selectedItem = "body"
            
        } else if selectedItem == "body" {
            selectedItem = ""
             self.isAnimating = true
            UIView.animate(withDuration: 0.4, animations: {
                self.colorPicker.alpha = 0
                
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.doneButton.alpha = 1
                }, completion: {(completed) in
                    self.isAnimating = false
                })
            })
            
        }
        
        
    }
    
    @objc func handleLightingSelection() {

        generator.impactOccurred()
        
        if selectedItem == "" {
            selectedItem = "light"
            UIView.animate(withDuration: 0.4, animations: {
                self.doneButton.alpha = 0
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.colorPicker.alpha = 1
                })
            })
            
            
        } else if selectedItem == "light" {
            selectedItem = ""
            UIView.animate(withDuration: 0.4, animations: {
                self.colorPicker.alpha = 0
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.doneButton.alpha = 1
                })
            })
            
            
        } else if selectedItem == "body" {
            selectedItem = "light"
            
        }
        
    }
    
    var currentAngleY: Float = 0.0
    var currentAngleX: Float = 0.0
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
        
        let translation = sender.translation(in: sender.view!)
        
        var newAngleX = (Float)(translation.x)*(Float)(M_PI)/180.0
        newAngleX += currentAngleX
//        var newAngleY = (Float)(translation.y)*(Float)(M_PI)/180.0
//        newAngleY += currentAngleY
        
        containerShoeNode?.eulerAngles.x = newAngleX
//        containerShoeNode?.eulerAngles.y = newAngleY
        
        if(sender.state == UIGestureRecognizerState.ended) {
            currentAngleX = newAngleX
//            currentAngleY = newAngleY
        }
    
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
        
            if sender.scale > 1.08873755624198 || sender.scale < 0.472778022621543 {
                return
            } else {
                shoeNode?.scale = SCNVector3(sender.scale, sender.scale, sender.scale)
            }
            
        }
        
    }

}




