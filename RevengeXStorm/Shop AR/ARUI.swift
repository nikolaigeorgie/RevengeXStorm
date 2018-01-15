//
//  ARUI.swift
//  MyCarByWestCoastCustoms
//
//  Created by Nikolas Andryuschenko on 10/5/17.
//  Copyright © 2017 Nikolas Andryuschenko. All rights reserved.
//

import UIKit
import ColorSlider

extension ViewController {
    
    
    @objc func loadCharacter() {
        
        if currentPersonLabel.text != "Ian Connor" {
            return
        }
        
        
        self.characterIsLoaded = false
        
        characterObject.removeAll()
        
        characterObject.append(VirtualObject.IanLoader)
        characterObject.append(VirtualObject.ArielLoader)
        characterObject.append(VirtualObject.LalaLoader)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.currentPersonLabel.alpha = 0
            self.stackView.alpha = 0
            self.leftArrowButton.alpha = 0
            self.rightArrowButton.alpha = 0
            self.IanImageView.alpha = 0
            self.ArielImageView.alpha = 0
            self.LalaImageView.alpha = 0
            self.currentPersonLabelImageView.alpha = 0
            
        }, completion: { (done) in
            self.currentPersonLabel.isHidden = true
            self.stackView.isHidden = true
            self.IanImageView.isHidden = true
            self.ArielImageView.isHidden = true
            self.LalaImageView.isHidden = true
            self.leftArrowButton.isHidden = true
            self.rightArrowButton.isHidden = true
            self.currentPersonLabelImageView.isHidden = true
        })
        
        if currentPersonLabel.text == "Ian Connor" {
            ViewController.selectedModel = "IanConnor"
        } else if currentPersonLabel.text == "Ariel Pink" {
            ViewController.selectedModel = "ArielPink"
            characterObject.remove(at: 0)
            
        } else if currentPersonLabel.text == "Lala" {
            ViewController.selectedModel = "Lala"
            characterObject.remove(at: 0)
            characterObject.remove(at: 0)
        }
        
        
        var characterToLoad = characterObject.first
        
        
        virtualObjectLoader.loadVirtualObject(characterToLoad!, loadedHandler: { [unowned self] loadedObject in
            DispatchQueue.main.async {
                self.placeCharacter(loadedObject)
            }
        })
        
        
        //        let modelScene = SCNScene(named:
        //            "Models.scnassets/IanTest.dae")!
        //
        //        var nodeModel:SCNNode!
        //        //    let nodeName = "cherub"
        //        let nodeName = "IanTest"
        //
        //        nodeModel =  modelScene.rootNode.childNode(withName: nodeName, recursively: true)
        //        nodeModel.position = SCNVector3Make(0, 0, 0)
        //        self.sceneView.scene.rootNode.addChildNode(nodeModel)
        //
    }
    
    @objc func handleRightButtonHit() {
        
        if currentUser == "Ian Connor" {
            selectButton.setTitle("COMING SOON", for: .normal)
            currentPersonLabel.text = "???"
            currentUser = "Ariel Pink"
            ViewController.selectedModel = "Ariel Pink"
            IanImageView.isUserInteractionEnabled = false
            ArielImageView.isUserInteractionEnabled = true
            LalaImageView.isUserInteractionEnabled = false
            
            sceneView.bringSubview(toFront: ArielImageView)
            sceneView.bringSubview(toFront: IanImageView)
            sceneView.sendSubview(toBack: LalaImageView)
            
            self.IanHorizontalConstraint.constant -= 100
            self.IanBottomConstraint.constant -= 60
            self.IanWidthConstraint.constant = 200
            self.IanHeightConstraint.constant = 250
            
            self.ArielHorizontalConstraint.constant = 0
            self.ArielBottomConstraint.constant = 0
            self.ArielWidthConstraint.constant = 250
            self.ArielHeightConstraint.constant = 300
            
            self.LalaHorizontalConstraint.constant += 200
            
            UIView.animate(withDuration: 1) {
                self.currentPersonLabelImageView.image = #imageLiteral(resourceName: "ARIEL PINK")
                self.view.layoutIfNeeded()
            }
            
        } else if currentUser == "Ariel Pink" {
            selectButton.setTitle("COMING SOON", for: .normal)
            currentUser = "Lala"
            currentPersonLabel.text = "???"
            ViewController.selectedModel = "Lala"
            IanImageView.isUserInteractionEnabled = false
            ArielImageView.isUserInteractionEnabled = false
            LalaImageView.isUserInteractionEnabled = true
            
            sceneView.bringSubview(toFront: ArielImageView)
            sceneView.bringSubview(toFront: LalaImageView)
            sceneView.sendSubview(toBack: IanImageView)
            
            self.ArielHorizontalConstraint.constant -= 100
            self.ArielBottomConstraint.constant -= 60
            self.ArielWidthConstraint.constant = 200
            self.ArielHeightConstraint.constant = 250
            
            self.LalaHorizontalConstraint.constant = 0
            self.LalaBottomConstraint.constant = 0
            self.LalaWidthConstraint.constant = 250
            self.LalaHeightConstraint.constant = 300
            
            self.IanHorizontalConstraint.constant += 200
            
            UIView.animate(withDuration: 1) {
                self.currentPersonLabelImageView.image = #imageLiteral(resourceName: "LALA")
                self.view.layoutIfNeeded()
                
            }
        } else if currentUser == "Lala" {
            selectButton.setTitle("SELECT", for: .normal)
            currentPersonLabel.text = "Ian Connor"
            currentUser = "Ian Connor"
            ViewController.selectedModel = "IanConnor"
            IanImageView.isUserInteractionEnabled = true
            ArielImageView.isUserInteractionEnabled = false
            LalaImageView.isUserInteractionEnabled = false
            
            sceneView.bringSubview(toFront: IanImageView)
            sceneView.bringSubview(toFront: LalaImageView)
            sceneView.sendSubview(toBack: ArielImageView)
            
            self.LalaHorizontalConstraint.constant -= 100
            self.LalaBottomConstraint.constant -= 60
            self.LalaWidthConstraint.constant = 200
            self.LalaHeightConstraint.constant = 250
            
            self.IanHorizontalConstraint.constant = 0
            self.IanBottomConstraint.constant = 0
            self.IanWidthConstraint.constant = 250
            self.IanHeightConstraint.constant = 300
            
            self.ArielHorizontalConstraint.constant += 200
            
            UIView.animate(withDuration: 1) {
                self.currentPersonLabelImageView.image = #imageLiteral(resourceName: "IAN CONNOR")
                self.view.layoutIfNeeded()
            }
        } else {
            return
        }
    }
    
    
    @objc func handleLeftButtonHit() {
        
        if currentUser == "Ian Connor" {
            selectButton.setTitle("COMING SOON", for: .normal)
            currentPersonLabel.text = "???"
            currentUser = "Lala"
            ViewController.selectedModel = "Lala"
            IanImageView.isUserInteractionEnabled = false
            ArielImageView.isUserInteractionEnabled = false
            LalaImageView.isUserInteractionEnabled = true
            
            sceneView.bringSubview(toFront: LalaImageView)
            sceneView.bringSubview(toFront: IanImageView)
            sceneView.sendSubview(toBack: ArielImageView)
            
            self.IanHorizontalConstraint.constant += 100
            self.IanBottomConstraint.constant -= 60
            self.IanWidthConstraint.constant = 200
            self.IanHeightConstraint.constant = 250
            
            self.LalaHorizontalConstraint.constant = 0
            self.LalaBottomConstraint.constant = 0
            self.LalaWidthConstraint.constant = 250
            self.LalaHeightConstraint.constant = 300
            
            self.ArielHorizontalConstraint.constant -= 200
            
            UIView.animate(withDuration: 1) {
                self.currentPersonLabelImageView.image = #imageLiteral(resourceName: "LALA")
                self.view.layoutIfNeeded()
            }
            
        } else if currentUser == "Ariel Pink" {
            selectButton.setTitle("SELECT", for: .normal)
            currentPersonLabel.text = "Ian Connor"
            currentUser = "Ian Connor"
            ViewController.selectedModel = "IanConnor"
            IanImageView.isUserInteractionEnabled = true
            ArielImageView.isUserInteractionEnabled = false
            LalaImageView.isUserInteractionEnabled = false
            
            sceneView.bringSubview(toFront: ArielImageView)
            sceneView.bringSubview(toFront: IanImageView)
            sceneView.sendSubview(toBack: LalaImageView)
            
            self.ArielHorizontalConstraint.constant += 100
            self.ArielBottomConstraint.constant -= 60
            self.ArielWidthConstraint.constant = 200
            self.ArielHeightConstraint.constant = 250
            
            self.IanHorizontalConstraint.constant = 0
            self.IanBottomConstraint.constant = 0
            self.IanWidthConstraint.constant = 250
            self.IanHeightConstraint.constant = 300
            
            self.LalaHorizontalConstraint.constant -= 200
            
            UIView.animate(withDuration: 1) {
                self.currentPersonLabelImageView.image = #imageLiteral(resourceName: "IAN CONNOR")
                self.view.layoutIfNeeded()
            }
        } else if currentUser == "Lala" {
            selectButton.setTitle("COMING SOON", for: .normal)
            currentPersonLabel.text = "???"
            currentUser = "Ariel Pink"
            ViewController.selectedModel = "ArielPink"
            IanImageView.isUserInteractionEnabled = false
            ArielImageView.isUserInteractionEnabled = true
            LalaImageView.isUserInteractionEnabled = false
            
            
            sceneView.bringSubview(toFront: ArielImageView)
            sceneView.bringSubview(toFront: LalaImageView)
            sceneView.sendSubview(toBack: IanImageView)
            
            self.LalaHorizontalConstraint.constant += 100
            self.LalaBottomConstraint.constant -= 60
            self.LalaWidthConstraint.constant = 200
            self.LalaHeightConstraint.constant = 250
            
            self.ArielHorizontalConstraint.constant = 0
            self.ArielBottomConstraint.constant = 0
            self.ArielWidthConstraint.constant = 250
            self.ArielHeightConstraint.constant = 300
            
            self.IanHorizontalConstraint.constant -= 200
            
            UIView.animate(withDuration: 1) {
                self.currentPersonLabelImageView.image = #imageLiteral(resourceName: "ARIEL PINK")
                self.view.layoutIfNeeded()
            }
        } else {
            return
        }
    }
    
    
    func setupFrameView() {
        view.layoutIfNeeded()
        sceneView.layoutIfNeeded()
        
        sceneView.addSubview(carCollectionView)
        carCollectionView.frame = CGRect(x: 0, y: view.frame.minY + 100, width: sceneView.frame.width, height: view.frame.height - 100)
        //        let width = sceneView.frame.width / 5
        //        carCollectionView.contentInset = UIEdgeInsetsMake(0, width, 0, width)
        carCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        carCollectionView.isPagingEnabled = true
        
        
        
        view.addSubview(backButton)
        backButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 40, bottomConstant: 25, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        view.addSubview(resetButton)
        resetButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 65, leftConstant: 0, bottomConstant: 0, rightConstant: 45, widthConstant: 30, heightConstant: 25)
        
        carCollectionView.register(CarCell.self, forCellWithReuseIdentifier: carCellId)
        carCollectionView.delegate = self
        carCollectionView.dataSource = self
        
        sceneView.addSubview(switchCharacterButton)
        switchCharacterButton.anchor(nil, left: nil, bottom: sceneView.bottomAnchor, right: sceneView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 45, widthConstant: 43, heightConstant: 40)
        
        
        
        sceneView.addSubview(stackView)
        
        stackView = UIStackView(arrangedSubviews: [leftArrowButton, selectButton, rightArrowButton])
        stackView.alpha = 0
        stackView.isHidden = true
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        //        stackView.setCustomSpacing(150.0, after: leftArrowButton)
        
        leftArrowButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        selectButton.layer.cornerRadius = 5
        
        rightArrowButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        //        view.addSubview(currentPersonLabel)
        //        currentPersonLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -50).isActive = true
        //        currentPersonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        currentPersonLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        //        currentPersonLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //        currentPersonLabel.textAlignment = .center
        //
        
//        view.addSubview(currentPersonLabelImageView)
//        currentPersonLabelImageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -30).isActive = true
//        currentPersonLabelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        currentPersonLabelImageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
//        currentPersonLabelImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        
        view.addSubview(currentPersonLabel)
        currentPersonLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -30).isActive = true
        currentPersonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentPersonLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        currentPersonLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true

        
        
        IanImageView.sd_setImage(with: URL(string: "https://firebasestorage.googleapis.com/v0/b/cybershop-f4213.appspot.com/o/IanConnor.gif?alt=media&token=a64d415e-225d-46ab-958b-39f08a4e54e9"), placeholderImage: UIImage())
        
        ArielImageView.sd_setImage(with: URL(string: "https://firebasestorage.googleapis.com/v0/b/revengexs-7792e.appspot.com/o/mysteryone.gif?alt=media&token=9583616d-ad1c-4275-9606-524b813aea76"), placeholderImage: UIImage())
        
        LalaImageView.sd_setImage(with: URL(string: "https://firebasestorage.googleapis.com/v0/b/revengexs-7792e.appspot.com/o/mysterytwo.gif?alt=media&token=38f9d030-4909-499b-add1-97c68a549e95"), placeholderImage: UIImage())
        
        
        
        
        sceneView.addSubview(ArielImageView)
        ArielHorizontalConstraint = ArielImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ArielBottomConstraint = ArielImageView.bottomAnchor.constraint(equalTo: currentPersonLabel.topAnchor)
        ArielWidthConstraint = ArielImageView.widthAnchor.constraint(equalToConstant: 200)
        ArielHeightConstraint = ArielImageView.heightAnchor.constraint(equalToConstant: 250)
        self.ArielHorizontalConstraint.constant += 100
        self.ArielBottomConstraint.constant -= 60
        
        sceneView.addSubview(LalaImageView)
        LalaHorizontalConstraint = LalaImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        LalaBottomConstraint = LalaImageView.bottomAnchor.constraint(equalTo: currentPersonLabel.topAnchor)
        LalaWidthConstraint = LalaImageView.widthAnchor.constraint(equalToConstant: 200)
        LalaHeightConstraint = LalaImageView.heightAnchor.constraint(equalToConstant: 250)
        self.LalaHorizontalConstraint.constant -= 100
        self.LalaBottomConstraint.constant -=  60
        
        sceneView.addSubview(IanImageView)
        IanHorizontalConstraint = IanImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        IanBottomConstraint = IanImageView.bottomAnchor.constraint(equalTo: currentPersonLabel.topAnchor)
        IanWidthConstraint = IanImageView.widthAnchor.constraint(equalToConstant: 250)
        IanHeightConstraint = IanImageView.heightAnchor.constraint(equalToConstant: 300)
        
        
        NSLayoutConstraint.activate([IanHorizontalConstraint, IanBottomConstraint, IanWidthConstraint, IanHeightConstraint])
        NSLayoutConstraint.activate([ArielHorizontalConstraint, ArielBottomConstraint, ArielWidthConstraint, ArielHeightConstraint])
        NSLayoutConstraint.activate([LalaHorizontalConstraint, LalaBottomConstraint, LalaWidthConstraint, LalaHeightConstraint])
        
        IanImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadCharacter)))
        
        view.addSubview(frameImageView)
        frameImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

