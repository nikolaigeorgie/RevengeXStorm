//
//  DetailViewController.swift
//  RevengeXStorm
//
//  Created by Nikolas Andryuschenko on 11/29/17.
//  Copyright © 2017 Nikolas Andryuschenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView?
    
    var image: UIImage? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        imageView?.image = image
    }
}

