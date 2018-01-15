//
//  CarCell.swift
//  MyCarByWestCoastCustoms
//
//  Created by Nikolas Andryuschenko on 10/4/17.
//  Copyright © 2017 Nikolas Andryuschenko. All rights reserved.
//

import UIKit
import SDWebImage

protocol CarListDelegate {
    func virtualObjectAddDelete(for cell: CarCell)
}

class CarCell: UICollectionViewCell {
    
    
    var model : VirtualObject? {
        didSet {
        }
    }
    
    var modelName = "" {
        didSet {
            //            carModelNameLabel.text = modelName.capitalized
            //            objectImageView.image = UIImage(named: modelName)
        }
    }
    
    var characterURLS = "" {
        didSet {
            characterImageView.sd_setImage(with: URL(string: characterURLS), placeholderImage: UIImage())
            
        }
    }
    
    var characters = "" {
        didSet {
            characterNameLabel.text = characters
        }
    }
    
    
    let characterNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
//    let characterImageView : UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.contentMode = .scaleAspectFit
//        return image
//    }()
    
    let indexLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let backgroundContentView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "templateBackground")
        //        view.alpha = 0.5
        return view
    }()
    
    let characterImageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundContentView)
        backgroundContentView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        self.addSubview(characterImageView)
        characterImageView.anchor(backgroundContentView.topAnchor, left: backgroundContentView.leftAnchor, bottom: backgroundContentView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: backgroundContentView.frame.width / 2, heightConstant: 0)
        
        self.addSubview(characterNameLabel)
        characterNameLabel.anchor(backgroundContentView.topAnchor, left: characterImageView.rightAnchor, bottom: nil, right: backgroundContentView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: backgroundContentView.frame.width / 2, heightConstant: 0)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addObject))
        self.addGestureRecognizer(gesture)
        
        
        
    }
    
    var delegate: CarListDelegate?
    
    @objc func addObject() {
        delegate?.virtualObjectAddDelete(for: self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

