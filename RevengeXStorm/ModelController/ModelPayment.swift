//
//  ModelPayment.swift
//  RevengeXStorm
//
//  Created by Nikolas Andryuschenko on 12/1/17.
//  Copyright © 2017 Nikolas Andryuschenko. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import FirebaseAnalytics

    extension ModelController {
        
        func checkIfPurchased() {
            
            SwiftyStoreKit.retrieveProductsInfo(["com.Andryuschenko.RevengeXStorm.Textures"]) { result in
                if let product = result.retrievedProducts.first {
                    let priceString = product.localizedPrice!
                    print("Product: \(product.localizedDescription), price: \(priceString)")
                    
                    if self.texturesPurchase == false {
                        var alertController = UIAlertController(title: "Custom Texture Purchase", message: "Purchase texture manipulation for $0.99?", preferredStyle: .alert)
                        
                        switch UIDevice.current.userInterfaceIdiom {
                        case .phone:
                            // It's an iPhone
                            alertController = UIAlertController(title: "Custom Texture Purchase", message: "Purchase texture manipulation for $0.99?", preferredStyle: .actionSheet)
                            
                        case .pad:
                            alertController = UIAlertController(title: "Custom Texture Purchase", message: "Purchase texture manipulation for $0.99?", preferredStyle: .alert)
                            
                        // It's an iPad
                        case .unspecified:
                            break
                        // Uh, oh! What could it be?
                        case .tv:
                            break
                        case .carPlay:
                            break
                        }
                        

                        self.present(alertController, animated: true, completion: nil)
                        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                            NetworkActivityIndicatorManager.networkOperationStarted()
                            SwiftyStoreKit.purchaseProduct("com.Andryuschenko.RevengeXStorm.Textures", atomically: true) { result in
                                NetworkActivityIndicatorManager.networkOperationFinished()
                                
                                if case .success(let purchase) = result {
                                    // Deliver content from server, then:
                                    if purchase.needsFinishTransaction {
                                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                                    }
                                }
                                if let alert = self.alertForPurchaseResult(result) {
                                    self.showAlert(alert)
                                }
                                
                            }
                        }))
                        alertController.addAction(UIAlertAction(title: "Restore Purchase", style: .default, handler: { (_) in
                            
                            SwiftyStoreKit.restorePurchases(atomically: true) { results in
                                if results.restoreFailedPurchases.count > 0 {
                                    print("Restore Failed: \(results.restoreFailedPurchases)")
                                } else if results.restoredPurchases.count > 0 {
                                    print("Restore Success: \(results.restoredPurchases)")
                                    UserDefaults.standard.set(true, forKey: "TexturesPurchase")
                                } else {
                                    print("Nothing to Restore")
                                }
                            }
                        }))
                        
                        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        
                    }
                    
                }
                else if let invalidProductId = result.invalidProductIDs.first {
                    return print("Could not retrieve product info", "Invalid product identifier: \(invalidProductId)")
                }
                else {
                    print("Error: \(result.error)")
                }
            }
            
        }
        
        // swiftlint:disable cyclomatic_complexity
        func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                UserDefaults.standard.set(true, forKey: "TexturesPurchase")
                return alertWithTitle("Thank You", message: "Purchase completed")
                //Here
            case .error(let error):
                print("Purchase Failed: \(error)")
                switch error.code {
                case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
                case .clientInvalid: // client is not allowed to issue the request, etc.
                    return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
                case .paymentCancelled: // user cancelled the request, etc.
                    return nil
                case .paymentInvalid: // purchase identifier was invalid, etc.
                    return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
                case .paymentNotAllowed: // this device is not allowed to make the payment
                    return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
                case .storeProductNotAvailable: // Product is not available in the current storefront
                    return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
                case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                    return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                    return alertWithTitle("Purchase failed", message: "Could not connect to the network")
                case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                    return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
                }
            }
        }
        
        func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
            
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
            } else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                UserDefaults.standard.set(true, forKey: "TexturesPurchase")
                return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
            } else {
                print("Nothing to Restore")
                return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
            }
        }
        
        func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {
            
            switch result {
            case .success(let receipt):
                print("Verify receipt Success: \(receipt)")
                return alertWithTitle("Receipt verified", message: "Receipt verified remotely")
            case .error(let error):
                print("Verify receipt Failed: \(error)")
                switch error {
                case .noReceiptData:
                    return alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
                case .networkError(let error):
                    return alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
                default:
                    return alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
                }
            }
        }
        
        func alertForVerifySubscription(_ result: VerifySubscriptionResult) -> UIAlertController {
            
            switch result {
            case .purchased(let expiryDate):
                print("Product is valid until \(expiryDate)")
                return alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate)")
            case .expired(let expiryDate):
                print("Product is expired since \(expiryDate)")
                return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
            case .notPurchased:
                print("This product has never been purchased")
                return alertWithTitle("Not purchased", message: "This product has never been purchased")
            }
        }
        
        func alertForVerifyPurchase(_ result: VerifyPurchaseResult) -> UIAlertController {
            
            switch result {
            case .purchased:
                print("Product is purchased")
                        UserDefaults.standard.set(true, forKey: "TexturesPurchase")
                return alertWithTitle("Product is purchased", message: "Product will not expire")
            case .notPurchased:
                print("This product has never been purchased")
                return alertWithTitle("Not purchased", message: "This product has never been purchased")
            }
        }
    }
    
    
    
    // MARK: User facing alerts
    extension ModelController {
        
        func alertWithTitle(_ title: String, message: String) -> UIAlertController {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alert
        }
        
        func showAlert(_ alert: UIAlertController) {
            guard self.presentedViewController != nil else {
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
            
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
            } else if let invalidProductId = result.invalidProductIDs.first {
                return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
            } else {
                let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
                return alertWithTitle("Could not retrieve product info", message: errorString)
            }
        }
        
        
    }
    

