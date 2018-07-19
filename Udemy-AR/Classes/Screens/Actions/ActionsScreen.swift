//
//  ActionsScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class ActionsScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
}

// MARK: - Lifecycle
extension ActionsScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.session.run(configuration)

        let (nodeA, nodeB) = addNodes()
        addActionAndAnimation(nodeA, nodeB)
    }
}

// MARK: - Private
extension ActionsScreen {
    private func addNodes() -> (SCNNode, SCNNode) {
        let nodeA = SCNNode()
        nodeA.position = SCNVector3(0.0, 0.0, -0.2)
        nodeA.geometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 1)
        nodeA.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        nodeA.geometry?.firstMaterial?.specular.contents = UIColor.white
        sceneView.scene.rootNode.addChildNode(nodeA)

        let nodeB = SCNNode()
        nodeB.position = SCNVector3(0.0, 0.0, -0.5)
        nodeB.geometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 1)
        nodeB.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        nodeB.geometry?.firstMaterial?.specular.contents = UIColor.blue
        nodeA.addChildNode(nodeB)

        return (nodeA, nodeB)
    }

    private func addActionAndAnimation(_ nodeA: SCNNode, _ nodeB: SCNNode) {
        let rotation = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(Double.pi) * 5, duration: 3)
        nodeA.runAction(rotation)
        nodeB.runAction(SCNAction.repeatForever(rotation))
    }
}
