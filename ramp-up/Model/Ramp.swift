//
//  Ramp.swift
//  ramp-up
//
//  Created by Artur Zarzecki on 11/03/2021.
//

import Foundation
import SceneKit

class Ramp {
    
    class func getRampForName(rampName: String) -> SCNNode {
        switch rampName {
        case "pipe":
            return Ramp.getPipe()
        case "quarter":
            return Ramp.getQuarter()
        case "pyramid":
            return Ramp.getPyramide()
        default:
            return Ramp.getPipe()
        }
    }
    
    class func getPipe() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/pipe.scn")
        let node = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        node?.scale = SCNVector3(0.002, 0.002, 0.002)
        node?.position = SCNVector3Make(0, 0.7, 0)
        return node!
    }
    
    class func getPyramide() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/pyramid.scn")
        let node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)!
        node?.scale = SCNVector3Make(0.005, 0.005, 0.005)
        node?.position = SCNVector3Make(0, -0.1, 0)
        return node!
    }
    
    class func getQuarter() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/quarter.scn")
        let node = obj?.rootNode.childNode(withName: "quarter", recursively: true)!
        node?.scale = SCNVector3Make(0.005, 0.005, 0.005)
        node?.position = SCNVector3Make(0, -1.3, 0)
        return node!
    }
    
    class func startRotation(node: SCNNode) {
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        node.runAction(rotate)
    }
}
