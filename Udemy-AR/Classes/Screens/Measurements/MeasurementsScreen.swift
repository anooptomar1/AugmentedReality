//
//  MeasurementsScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class MeasurementsScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var xLabel: UILabel!
    @IBOutlet private weak var yLabel: UILabel!
    @IBOutlet private weak var zLabel: UILabel!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
    private var startingPosition: SCNNode?
}

// MARK: - Lifecycle
extension MeasurementsScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.run(configuration)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleTap(sender:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - Private
extension MeasurementsScreen {
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let scene = sender.view as? ARSCNView,
                let currentFrame = scene.session.currentFrame else {
            return
        }

        if startingPosition != nil {
            startingPosition?.removeFromParentNode()
            startingPosition = nil
            return
        }

        let camera = currentFrame.camera
        let transform = camera.transform
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.z = -0.1

        let modifiedMatrix = simd_mul(transform, translationMatrix) // Put the sphere a bit ahead
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
        sphere.simdTransform = modifiedMatrix

        sceneView.scene.rootNode.addChildNode(sphere)
        startingPosition = sphere
    }
}

// MARK: - ARSCNViewDelegate
extension MeasurementsScreen: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer,
                  updateAtTime time: TimeInterval) {
        guard let startingPosition = startingPosition,
                let pointOfView = sceneView.pointOfView else {
            return
        }

        let transform = pointOfView.transform
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let xDistance = location.x - startingPosition.position.x
        let yDistance = location.y - startingPosition.position.y
        let zDistance = location.z - startingPosition.position.z

        DispatchQueue.main.async {
            self.xLabel.text = String(format: "%.2f", xDistance)
            self.yLabel.text = String(format: "%.2f", yDistance)
            self.zLabel.text = String(format: "%.2f", zDistance)
            self.distanceLabel.text = String(format: "%.2f", self.distanceTravelled(x: xDistance,
                                                                                    y: yDistance,
                                                                                    z: zDistance))
        }
    }
}

// MARK: - Utilities
extension MeasurementsScreen {
    private func distanceTravelled(x: Float, y: Float, z: Float) -> Float {
        return sqrtf(x*x + y*y + z*z)
    }
}
