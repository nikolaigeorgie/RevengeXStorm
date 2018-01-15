//
//  Products.swift
//  RevengeXStorm
//
//  Created by Nikolas Andryuschenko on 11/25/17.
//  Copyright © 2017 Nikolas Andryuschenko. All rights reserved.
//



import Foundation

public struct Products {
    
    public static let Textures = "com.Andryuschenko.RevengeXStorm.Textures"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Products.Textures]
    
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
