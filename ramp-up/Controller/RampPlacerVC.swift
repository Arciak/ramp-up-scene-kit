//
//  ViewController.swift
//  ramp-up
//
//  Created by Artur Zarzecki on 11/03/2021.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerVC: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controls: UIStackView!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    var selectedRampName: String?
    var selectedRamp: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        rotateBtn.addGestureRecognizer(gesture1)
        upBtn.addGestureRecognizer(gesture2)
        downBtn.addGestureRecognizer(gesture3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // if do not return .none it will go full screen (our pop vc)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            print("touch")
            return }
        
        
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        
//        guard let query = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .estimatedPlane, alignment: .any) else { return }
//
//        let results = sceneView.session.raycast(query)
 
        guard let hitFeature = results.last else {
            print("hitFeature")
            return }
        
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        placeRamp(possition: hitPosition)
    }
    
    @IBAction func onRampBtnPressed(_ sender: UIButton) {
        let rampPickerVC = RampPickerVC(size: CGSize(width: 250, height: 500))
        rampPickerVC.rampPlacerVC = self
        rampPickerVC.modalPresentationStyle = .popover
        rampPickerVC.popoverPresentationController?.delegate = self
        present(rampPickerVC, animated: true, completion: nil)
        rampPickerVC.popoverPresentationController?.sourceView = sender
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    func onRampSelected(_ rampName: String) {
        selectedRampName = rampName
    }
    
    func placeRamp(possition: SCNVector3) {
        if let rampName = selectedRampName {
            controls.isHidden = false
            let ramp = Ramp.getRampForName(rampName: rampName)
            selectedRamp = ramp
            ramp.position = possition
            ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(ramp)
            print("Should place a ramp")
        }
    }
    
    @IBAction func onRemoveBtnPressed(_ sender: Any) {
        if let ramp = selectedRamp {
            ramp.removeFromParentNode()
            selectedRamp = nil
            controls.isHidden = true
        }
    }
    
    @objc func onLongPress(_ gesture: UIGestureRecognizer) {
        if let ramp = selectedRamp {
            if gesture.state == .ended {
                ramp.removeAllActions()
            } else if gesture.state == .began {
                if gesture.view === rotateBtn { // === checking a referance
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                } else if gesture.view === upBtn {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                } else if gesture.view === downBtn {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                }
            }
        }
    }
    
    
}
