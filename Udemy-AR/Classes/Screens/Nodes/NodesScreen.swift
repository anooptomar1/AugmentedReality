//
//  Nodes.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class NodesScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
}

// MARK: - Lifecycle
extension NodesScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.autoenablesDefaultLighting = true
        sceneView.session.run(configuration)
        addNode()
    }
}

// MARK: - Private
extension NodesScreen {
    private func addNode() {
        let node = SCNNode()
        node.position = SCNVector3(0.0, 0.0, -0.2)

        node.geometry = SCNSphere(radius: 0.05)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.geometry?.firstMaterial?.specular.contents = UIColor.white

        sceneView.scene.rootNode.addChildNode(node)
    }
}

