//
//  ProjectilesScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class ProjectilesScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
    private var power: Float = 1.0
    private var basketAdded: Bool {
        return sceneView.scene.rootNode.childNode(withName: "Basket", recursively: false) != nil
    }
}

// MARK: - Lifecycle
extension ProjectilesScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if basketAdded {
            guard let pointOfView = sceneView.pointOfView else {
                return
            }

            power = 10

            let transform = pointOfView.transform
            let location = SCNVector3(transform.m41, transform.m42, transform.m43)
            let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
            let position = location + orientation
            let ball = SCNNode(geometry: SCNSphere(radius: 0.3))

            ball.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            ball.position = position

            let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball))
            ball.physicsBody = body
            ball.physicsBody?.applyForce(SCNVector3(orientation.x * power, orientation.y * power, orientation.z * power),
                                         asImpulse: true)
            sceneView.scene.rootNode.addChildNode(ball)
        }
    }
}

// MARK: - Private
extension ProjectilesScreen {
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let scene = sender.view as? ARSCNView else {
            return
        }

        let touchLocation = sender.location(in: scene)
        let hitTestResult = scene.hitTest(touchLocation, types: [.existingPlaneUsingExtent])
        if !hitTestResult.isEmpty {
            addBasket(hitTestResult: hitTestResult.first!)
        }
    }

    private func addBasket(hitTestResult: ARHitTestResult) {
        let basketScene = SCNScene(named: "art.scnassets/Basketball.scn")
        let basketNode = basketScene?.rootNode.childNode(withName: "Basket", recursively: false)
        let positionOfPlane = hitTestResult.worldTransform.columns.3
        let xPosition = positionOfPlane.x
        let yPosition = positionOfPlane.y
        let zPosition = positionOfPlane.z

        basketNode?.position = SCNVector3(xPosition, yPosition, zPosition)
        basketNode?.physicsBody
            = SCNPhysicsBody(type: .static,
                             shape: SCNPhysicsShape(node: basketNode!,
                                                    options: [SCNPhysicsShape.Option.keepAsCompound: true,
                                                              SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
        sceneView.scene.rootNode.addChildNode(basketNode!)
    }
}
