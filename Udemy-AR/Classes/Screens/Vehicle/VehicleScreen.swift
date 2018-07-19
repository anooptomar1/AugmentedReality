//
//  VehicleScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit
import CoreMotion

final class VehicleScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
    private let motionManager = CMMotionManager()
    private var vehicle = SCNPhysicsVehicle()
    private var accelerationValues = [UIAccelerationValue(0), UIAccelerationValue(0)]
    private var orientation: CGFloat = 0.0
    private var touched: Int = 0
}

// MARK: - Lifecycle
extension VehicleScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccelerometer()
        configuration.planeDetection = [.horizontal]
        sceneView.delegate = self
        sceneView.session.run(configuration)
    }

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let _ = touches.first else {
            return
        }

        touched += touches.count
    }

    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        touched = 0
    }
}

// MARK: - Private
extension VehicleScreen {
    private func addNode(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        node.position = SCNVector3(CGFloat(planeAnchor.center.x),
                                   CGFloat(planeAnchor.center.y),
                                   CGFloat(planeAnchor.center.z))

        node.geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                                 height: CGFloat(planeAnchor.extent.z))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        node.opacity = 0.5

        let staticBody = SCNPhysicsBody.static() // won't move, but collides. (are not affected by forces)
        node.physicsBody = staticBody
        return node
    }

    private func setupAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                self.accelerometerDidChange(acceleration: data!.acceleration)
            }
        }
    }

    private func accelerometerDidChange(acceleration: CMAcceleration) {
        accelerationValues[1] = filtered(currentAcceleration: accelerationValues[1],
                                         updatedAcceleration: acceleration.y)
        accelerationValues[0] = filtered(currentAcceleration: accelerationValues[0],
                                         updatedAcceleration: acceleration.x)

        if accelerationValues[0] > 0 {
            orientation = -CGFloat(accelerationValues[1])
        } else {
            orientation = CGFloat(accelerationValues[1])
        }
    }

    private func filtered(currentAcceleration: Double, updatedAcceleration: Double) -> Double {
        let kFilteringFactor = 0.5
        return updatedAcceleration * kFilteringFactor + currentAcceleration * (1 - kFilteringFactor)
    }
}

// MARK: - Actions
extension VehicleScreen {
    @IBAction private func addCar(_ sender: UIButton) {
        guard let pointOfView = sceneView.pointOfView else {
            return
        }

        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location

        let scene = SCNScene(named: "Vehicle.scn")
        let chassis = (scene?.rootNode.childNode(withName: "frame", recursively: false))!
        chassis.position = currentPositionOfCamera

        let frontLeftWheel = chassis.childNode(withName: "frontLeftParent", recursively: false)
        let frontRightWheel = chassis.childNode(withName: "frontRightParent", recursively: false)
        let rearLeftWheel = chassis.childNode(withName: "rearLeftParent", recursively: false)
        let rearRightWheel = chassis.childNode(withName: "rearRightParent", recursively: false)

        let v_frontLeftWheel = SCNPhysicsVehicleWheel(node: frontLeftWheel!)
        let v_frontRightWheel = SCNPhysicsVehicleWheel(node: frontRightWheel!)
        let v_rearLeftWheel = SCNPhysicsVehicleWheel(node: rearLeftWheel!)
        let v_rearRightWheel = SCNPhysicsVehicleWheel(node: rearRightWheel!)

        let body = SCNPhysicsBody(type: .dynamic,
                                  shape: SCNPhysicsShape(node: chassis,
                                                         options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        body.mass = 1
        chassis.physicsBody = body
        vehicle = SCNPhysicsVehicle(chassisBody: chassis.physicsBody!,
                                    wheels: [v_rearLeftWheel,
                                             v_rearRightWheel,
                                             v_frontLeftWheel,
                                             v_frontRightWheel])
        sceneView.scene.physicsWorld.addBehavior(vehicle)
        sceneView.scene.rootNode.addChildNode(chassis)
    }
}

// MARK: - ARSCNViewDelegate
extension VehicleScreen: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer,
                  didAdd node: SCNNode,
                  for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }

        node.addChildNode(addNode(planeAnchor: planeAnchor))
    }

    func renderer(_ renderer: SCNSceneRenderer,
                  didUpdate node: SCNNode,
                  for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }

        node.enumerateChildNodes { child, _ in
            child.removeFromParentNode()
        }

        node.addChildNode(addNode(planeAnchor: planeAnchor))
    }

    func renderer(_ renderer: SCNSceneRenderer,
                  didRemove node: SCNNode,
                  for anchor: ARAnchor) {
        node.enumerateChildNodes { child, _ in
            child.removeFromParentNode()
        }
    }

    func renderer(_ renderer: SCNSceneRenderer,
                  didSimulatePhysicsAtTime time: TimeInterval) {
        var engineForce: CGFloat = 0.0
        vehicle.setSteeringAngle(-orientation, forWheelAt: 2)
        vehicle.setSteeringAngle(-orientation, forWheelAt: 3)

        var brakingForce: CGFloat = 0

        if touched == 1 {
            engineForce = 5.0
        } else if touched == 2 {
            engineForce = -5.0
        } else if touched == 3 {
            brakingForce = 100.0
        } else {
            engineForce = 0.0
        }

        vehicle.applyEngineForce(engineForce, forWheelAt: 0)
        vehicle.applyEngineForce(engineForce, forWheelAt: 1)
        vehicle.applyBrakingForce(brakingForce, forWheelAt:0)
        vehicle.applyBrakingForce(brakingForce, forWheelAt:1)
    }
}
