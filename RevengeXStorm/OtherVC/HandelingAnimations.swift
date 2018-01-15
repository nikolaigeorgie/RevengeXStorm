////
////  HandelingAnimations.swift
////  RevengeXStorm
////
////  Created by Nikolas Andryuschenko on 12/2/17.
////  Copyright © 2017 Nikolas Andryuschenko. All rights reserved.
////
//
//import Foundation
//
//var animations = [String: CAAnimation]()
//var idle:Bool = true
//
//
//func loadInitial() {
//    // Load the character in the idle animation
//    let idleScene = SCNScene(named: "Models.scnassets/spinRight.dae")!
//    
//    // This node will be parent of all the animation models
//    let node = SCNNode()
//    
//    // Add all the child nodes to the parent node
//    for child in idleScene.rootNode.childNodes {
//        node.addChildNode(child)
//    }
//    
//    // Set up some properties
//    node.position = SCNVector3(0, -1, -2)
//    node.scale = SCNVector3(0.2, 0.2, 0.2)
//    
//    // Add the node to the scene
//    sceneView.scene.rootNode.addChildNode(node)
//    
//    // Load all the DAE animations
//    loadAnimation(withKey: "left", sceneName: "Models.scnassets/sprinleft", animationIdentifier: "sprinleft-1")
//    
//}
//
//func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
//    let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
//    let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
//    
//    if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
//        // The animation will only play once
//        animationObject.repeatCount = 1
//        // To create smooth transitions between animations
//        animationObject.fadeInDuration = CGFloat(1)
//        animationObject.fadeOutDuration = CGFloat(0.5)
//        
//        // Store the animation for later use
//        animations[withKey] = animationObject
//    }
//}
//override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    let location = touches.first!.location(in: sceneView)
//    
//    // Let's test if a 3D Object was touch
//    var hitTestOptions = [SCNHitTestOption: Any]()
//    hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
//    
//    let hitResults: [SCNHitTestResult]  = sceneView.hitTest(location, options: hitTestOptions)
//    
//    if hitResults.first != nil {
//        if(idle) {
//            playAnimation(key: "left")
//        } else {
//            stopAnimation(key: "left")
//        }
//        idle = !idle
//        return
//    }
//}
//
//func playAnimation(key: String) {
//    // Add the animation to start playing it right away
//    sceneView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
//}
//
//func stopAnimation(key: String) {
//    // Stop the animation with a smooth transition
//    sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
//}
//
