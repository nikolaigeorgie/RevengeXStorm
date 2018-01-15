/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Methods on the main view controller for handling virtual object loading and movement
 */

import UIKit
import SceneKit

extension ViewController {
    /**
     Adds the specified virtual object to the scene, placed using
     the focus square's estimate of the world-space position
     currently corresponding to the center of the screen.
     
     - Tag: PlaceVirtualObject
     */
    func placeVirtualObject(_ virtualObject: VirtualObject) {
        
        
        
        guard let cameraTransform = session.currentFrame?.camera.transform,
            let focusSquarePosition = focusSquare.lastPosition else {
                statusViewController.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
                return
        }
        
        virtualObjectInteraction.selectedObject = virtualObject
        virtualObject.setPosition(focusSquarePosition, relativeTo: cameraTransform, smoothMovement: false)
        
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(virtualObject)
            let personNode = self.sceneView.scene.rootNode
            self.rightShoeNode = self.sceneView.scene.rootNode.childNode(withName: "rightShoe", recursively: true)
            self.leftShoeNode = self.sceneView.scene.rootNode.childNode(withName: "leftShoe", recursively: true)
            
            self.rightShoeNode?.geometry?.material(named: "lightningBolt")?.diffuse.contents = ViewController.boltColor
            self.rightShoeNode?.geometry?.material(named: "body")?.diffuse.contents = ViewController.bodyColor
            
            
            self.leftShoeNode?.geometry?.material(named: "lightningBolt")?.diffuse.contents = ViewController.boltColor
            self.leftShoeNode?.geometry?.material(named: "body")?.diffuse.contents = ViewController.bodyColor
            
            personNode.opacity = 0
            
            SCNTransaction.begin()
            personNode.opacity = 1
            SCNTransaction.animationDuration = 2
            SCNTransaction.commit()
            
            
        }
        
    }
    
    
    func placeCharacter(_ virtualObject: VirtualObject) {
        guard let cameraTransform = session.currentFrame?.camera.transform,
            let focusSquarePosition = focusSquare.lastPosition else {
                statusViewController.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
                return
        }
        
        virtualObjectInteraction.selectedObject = characterObject.first
        characterObject.first?.setPosition(focusSquarePosition, relativeTo: cameraTransform, smoothMovement: false)
        
        
        updateQueue.async {
            
            self.sceneView.scene.rootNode.addChildNode(self.characterObject.first!)
            
            self.sceneView.scene.rootNode.addChildNode(self.characterObject.first!)
            let personNode = self.sceneView.scene.rootNode
            self.rightShoeNode = self.sceneView.scene.rootNode.childNode(withName: "rightShoe", recursively: true)
            self.leftShoeNode = self.sceneView.scene.rootNode.childNode(withName: "leftShoe", recursively: true)
            self.cigNode = self.sceneView.scene.rootNode.childNode(withName: "Cigarrella", recursively: true)
            
            self.rightShoeNode?.geometry?.material(named: "lightningBolt")?.diffuse.contents = ViewController.boltColor
            self.rightShoeNode?.geometry?.material(named: "body")?.diffuse.contents = ViewController.bodyColor
            
            
            self.leftShoeNode?.geometry?.material(named: "lightningBolt")?.diffuse.contents = ViewController.boltColor
            self.leftShoeNode?.geometry?.material(named: "body")?.diffuse.contents = ViewController.bodyColor
            
            
            if ViewController.bodyImage != UIImage() {
                self.leftShoeNode?.geometry?.material(named: "body")?.diffuse.contents = ViewController.bodyImage
                self.rightShoeNode?.geometry?.material(named: "body")?.diffuse.contents = ViewController.bodyImage
            }
            
            
            //getting the animation node... here we go
            let metaRigNode = self.sceneView.scene.rootNode.childNode(withName: "metarig", recursively: true)
            let spineNode = metaRigNode?.childNode(withName: "spine", recursively: true)
            let spineNode_001 = spineNode?.childNode(withName: "spine_001", recursively: true)
            let spineNode_002 = spineNode_001?.childNode(withName: "spine_002", recursively: true)
           let spineNode_003 = spineNode_002?.childNode(withName: "spine_003", recursively: true)
           let shoulderNode_R = spineNode_003?.childNode(withName: "shoulder_R", recursively: true)
           let upper_arm_RNode = shoulderNode_R?.childNode(withName: "upper_arm_R", recursively: true)
            let forearm_RNode = upper_arm_RNode?.childNode(withName: "forearm_R", recursively: true)
            let hand_RNode = forearm_RNode?.childNode(withName: "hand_R", recursively: true)
            let palm_01_RNode = hand_RNode?.childNode(withName: "palm_01_R", recursively: true)
            let f_index_01_RNode = palm_01_RNode?.childNode(withName: "f_index_01_R", recursively: true)
            let f_index_02_RNode = f_index_01_RNode?.childNode(withName: "f_index_02_R", recursively: true)
            let f_index_03_RNode = f_index_02_RNode?.childNode(withName: "Cigarrella", recursively: true)
            
            
            let particlesNode = SCNNode()
            let particleSystem = SCNParticleSystem(named: "Smoke", inDirectory: "")
            particlesNode.addParticleSystem(particleSystem!)
            f_index_03_RNode?.addChildNode(particlesNode)

            
         
            let spine_004Node = spineNode_003?.childNode(withName: "spine_004", recursively: true)
            let spine_005Node = spine_004Node?.childNode(withName: "spine_005", recursively: true)
            let spine_006Node = spine_005Node?.childNode(withName: "spine_006", recursively: true)
            let faceNode = spine_006Node?.childNode(withName: "face", recursively: true)
            let lip_T_LNode = faceNode?.childNode(withName: "lip_T_L", recursively: true)
            
            let lip_T_L_001Node = lip_T_LNode?.childNode(withName: "lip_T_L_001", recursively: true)
            let smokeNode = lip_T_L_001Node?.childNode(withName: "smokeNode", recursively: true)
            
            let residueNode = SCNNode()

            ViewController.residueSystem?.loops = true
            
            self.setupLoop(residueNode: residueNode, smokeNode: smokeNode!)
            
            
            
            
            
            personNode.opacity = 0
            
            SCNTransaction.begin()
            personNode.opacity = 1
            SCNTransaction.animationDuration = 2
            SCNTransaction.commit()
            
            
            //            let particleSystem = SCNParticleSystem(named: "Smoke", inDirectory: "")
            //                        let particle = SCNParticleSystem(named: "Smoke", inDirectory: "")
            //            self.leftShoeNode?.addParticleSystem(particleSystem!)
            
            
        
            //            self.sceneView.scene.rootNode.addChildNode(self.cigNode!)
            
        }
    }
    
    func waitABit(residueNode: SCNNode, smokeNode: SCNNode) {
            ViewController.residueSystem?.loops = true
        residueNode.addParticleSystem(ViewController.residueSystem!)
        smokeNode.addChildNode(residueNode)
        

        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("reset")
            ViewController.residueSystem?.loops = false
            
            let when = DispatchTime.now() + 4.5 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                residueNode.removeParticleSystem(ViewController.residueSystem!)
                self.setupLoop(residueNode: residueNode, smokeNode: smokeNode)
                
                
                
            }
        }
    }
    
    
    func setupLoop(residueNode: SCNNode, smokeNode: SCNNode) {
        let when = DispatchTime.now() + 10 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("go smoke ")
            self.waitABit(residueNode: residueNode, smokeNode: smokeNode)
        }
    }
    
    // MARK: Object Loading UI
    
    func displayObjectLoadingUI() {
        // Show progress indicator.
        spinner.startAnimating()
        
        addObjectButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])
        
        addObjectButton.isEnabled = false
        isRestartAvailable = false
    }
    
    func hideObjectLoadingUI() {
        // Hide progress indicator.
        spinner.stopAnimating()
        
        addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
        
        addObjectButton.isEnabled = true
        isRestartAvailable = true
    }
}

