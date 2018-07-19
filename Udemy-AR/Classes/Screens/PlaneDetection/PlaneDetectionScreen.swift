//
//  PlaneDetectionScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class PlaneDetectionScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
}

// MARK: - Lifecycle
extension PlaneDetectionScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration.planeDetection = [.horizontal] //.vertical on iOS 11.2
        sceneView.delegate = self
        sceneView.session.run(configuration)
    }
}

// MARK: - Private
extension PlaneDetectionScreen {
    private func addNode(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        node.position = SCNVector3(CGFloat(planeAnchor.center.x),
                                   CGFloat(planeAnchor.center.y),
                                   CGFloat(planeAnchor.center.z))
        node.geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                                 height: CGFloat(planeAnchor.extent.z))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.opacity = 0.5
        return node
    }
}

// MARK: - ARSCNViewDelegate
extension PlaneDetectionScreen: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node.addChildNode(addNode(planeAnchor: planeAnchor))
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        node.enumerateChildNodes { child, _ in
            child.removeFromParentNode()
        }

        if let planeAnchor = anchor as? ARPlaneAnchor {
            node.addChildNode(addNode(planeAnchor: planeAnchor))
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        node.enumerateChildNodes { child, _ in
            child.removeFromParentNode()
        }
    }
}
