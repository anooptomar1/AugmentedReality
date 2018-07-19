//
//  ScalingScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class ScalingScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
}

// MARK: - Lifecycle
extension ScalingScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.session.run(configuration)

        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self,
                                                              action: #selector(pinched))

        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        addNode()
    }
}

// MARK: - Private
extension ScalingScreen {
    private func addNode() {
        let node = SCNNode()
        node.position = SCNVector3(0.0, 0.0, -0.2)

        node.geometry = SCNSphere(radius: 0.05)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.geometry?.firstMaterial?.specular.contents = UIColor.white

        sceneView.scene.rootNode.addChildNode(node)
    }

    @objc private func pinched(sender: UIPinchGestureRecognizer) {
        let scene = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: scene)
        let hitTest = scene.hitTest(pinchLocation)

        if !hitTest.isEmpty {
            let results = hitTest.first!
            let node = results.node
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            node.runAction(pinchAction)
            sender.scale = 1.0
        }
    }
}
