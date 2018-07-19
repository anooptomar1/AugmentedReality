//
//  DrawingScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class DrawingScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var drawButton: UIButton!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
}

// MARK: - Lifecycle
extension DrawingScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.run(configuration)
        addNode()
    }
}

// MARK: - Private
extension DrawingScreen {
    private func addNode() {

    }
}

extension DrawingScreen: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer,
                  willRenderScene scene: SCNScene,
                  atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {
            return
        }

        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location
        print(orientation.x, orientation.y, orientation.z)

        DispatchQueue.main.async {
            if self.drawButton.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = currentPositionOfCamera

                self.sceneView.scene.rootNode.enumerateChildNodes { child, _ in
                    if child.name == "pointer" {
                        child.removeFromParentNode()
                    }
                }

                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
