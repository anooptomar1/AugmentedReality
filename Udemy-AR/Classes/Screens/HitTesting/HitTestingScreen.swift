//
//  HitTestingScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class HitTestingScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
}

// MARK: - Lifecycle
extension HitTestingScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.session.run(configuration)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleTap(sender:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        addNode()
    }
}

// MARK: - Private
extension HitTestingScreen {
    private func addNode() {
        let node = SCNNode()
        node.position = SCNVector3(0.0, 0.0, -0.2)

        node.geometry = SCNSphere(radius: 0.05)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.geometry?.firstMaterial?.specular.contents = UIColor.white

        sceneView.scene.rootNode.addChildNode(node)
    }

    @objc private func handleTap(sender: UITapGestureRecognizer) {
        let tappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: tappedOn)
        let hitTest = tappedOn.hitTest(touchCoordinates)

        if !hitTest.isEmpty {
            let results = hitTest.first!
            let geometry = results.node.geometry
            print(geometry ?? "")
        }
    }
}


