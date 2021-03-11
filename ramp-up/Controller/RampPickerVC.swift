//
//  RampPickerVSViewController.swift
//  ramp-up
//
//  Created by Artur Zarzecki on 11/03/2021.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController {
    
    var sceneView: SCNView!
    var size: CGSize!
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        
        preferredContentSize = size
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        var obj = SCNScene(named: "art.scnassets/pipe.scn")
        var node = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        node?.scale = SCNVector3(0.002, 0.002, 0.002)
        node?.position = SCNVector3Make(0, 0.7, 0)
        scene.rootNode.addChildNode(node!)
        
        
        obj = SCNScene(named: "art.scnassets/pyramid.scn")
        node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)!
        node?.scale = SCNVector3Make(0.005, 0.005, 0.005)
        node?.position = SCNVector3Make(0, -0.1, 0)
        scene.rootNode.addChildNode(node!)
        
        obj = SCNScene(named: "art.scnassets/quarter.scn")
        node = obj?.rootNode.childNode(withName: "quarter", recursively: true)!
        node?.scale = SCNVector3Make(0.005, 0.005, 0.005)
        node?.position = SCNVector3Make(0, -1.3, 0)
        scene.rootNode.addChildNode(node!)
    }
    
    

    

}
