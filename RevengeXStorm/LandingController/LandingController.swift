//
//  ViewController.swift
//  MyCarByWestCoastCustoms
//
//  Created by Nikolas Andryuschenko on 10/4/17.
//  Copyright © 2017 Nikolas Andryuschenko. All rights reserved.
//

import UIKit
import SDWebImage

class LandingController: UIViewController {
    
    let landingBackgroundImageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let frameImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "frame")
        iv.contentMode = .scaleToFill
        return iv
    }()

    
    let revengeXStormLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "revengeLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "start"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(enterAppButtonHit), for: .touchUpInside)
        return button
    }()
    
    @objc func enterAppButtonHit() {
        let arController = ModelController()
//        let arController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.present(arController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        landingBackgroundImageView.sd_setImage(with: URL(string: "https://firebasestorage.googleapis.com/v0/b/genzi-7ed81.appspot.com/o/BACKGROUND%20.gif?alt=media&token=defefe62-c899-47c6-b602-47fc00f05a8e"), placeholderImage: #imageLiteral(resourceName: "landingBackground"))

        setupFrameView()

   

        //    setupOriginalView()
     
    }
    
    
    func setupFrameView() {
        
        
        
        
        view.addSubview(landingBackgroundImageView)
        landingBackgroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        landingBackgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enterAppButtonHit)))
        
        
        view.addSubview(frameImageView)
        frameImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        view.addSubview(revengeXStormLogoImageView)
        revengeXStormLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant:150).isActive = true
        revengeXStormLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        revengeXStormLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        revengeXStormLogoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        revengeXStormLogoImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        startButton.alpha = 1
        view.addSubview(startButton)
        startButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 180, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let copyRightButton = UIButton()
        copyRightButton.setImage(#imageLiteral(resourceName: "© 2017 GENZI"), for: .normal)
        
        
        view.addSubview(copyRightButton)
        copyRightButton.translatesAutoresizingMaskIntoConstraints = false
        copyRightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyRightButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        copyRightButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        copyRightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        copyRightButton.addTarget(self, action: #selector(handleGenziWebOpen), for: .touchUpInside)
        
        
        DispatchQueue.main.async {
            self.animateOff()
        }
    }
    
    func animateOff() {
        UIView.animate(withDuration: 0.3, animations: {
            self.arrowButton.alpha = 0
        }) { (finished) in
            DispatchQueue.main.async {
                self.animateOn()
            }
        }
    }
    
    func animateOn() {
        UIView.animate(withDuration: 0.3, animations: {
           self.arrowButton.alpha = 1
        }) { (finished) in
            DispatchQueue.main.async {
                self.animateOff()
            }
        }
    }
    
    
    
    
    let arrowButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)

        view.addSubview(arrowButton)

        arrowButton.alpha = 1
        
        arrowButton.centerYAnchor.constraint(equalTo: startButton.centerYAnchor).isActive = true
        arrowButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 105).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
    }
    
    @objc func handleGenziWebOpen() {
        if let url = URL(string: "www.genzi.io") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}
 
