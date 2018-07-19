//
//  PortalScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class PortalScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
}

// MARK: - Lifecycle
extension PortalScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration.planeDetection = [.horizontal]
        sceneView.delegate = self
        sceneView.session.run(configuration)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - Private
extension PortalScreen {
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let scene = sender.view as? ARSCNView else {
            return
        }

        let touchLocation = sender.location(in: scene)
        let hitTestResult = scene.hitTest(touchLocation,
                                          types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            addPortal(hitTestResult: hitTestResult.first!)
        }
    }

    private func addPortal(hitTestResult: ARHitTestResult) {
        let portalScene = SCNScene(named: "art.scnassets/Portal.scn")
        let portalNode = portalScene?.rootNode.childNode(withName: "Portal", recursively: false)
        let transform = hitTestResult.worldTransform
        let planeXPosition = transform.columns.3.x
        let planeYPosition = transform.columns.3.y
        let planeZPosition = transform.columns.3.z
        portalNode?.position = SCNVector3(planeXPosition, planeYPosition, planeZPosition)
        sceneView.scene.rootNode.addChildNode(portalNode!)
        addPlane(nodeName: "roof", portalNode: portalNode!, imageName: "top")
        addPlane(nodeName: "floor", portalNode: portalNode!, imageName: "bottom")
        addWall(nodeName: "sideDoorA", portalNode: portalNode!, imageName: "bottom")
        addWall(nodeName: "sideDoorB", portalNode: portalNode!, imageName: "bottom")
        addWall(nodeName: "leftWall", portalNode: portalNode!, imageName: "bottom")
        addWall(nodeName: "rightWall", portalNode: portalNode!, imageName: "bottom")
        addWall(nodeName: "backWall", portalNode: portalNode!, imageName: "bottom")
    }

    private func addPlane(nodeName: String,
                          portalNode: SCNNode,
                          imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/\(imageName).png")
        child?.renderingOrder = 200
    }

    private func addWall(nodeName: String,
                         portalNode: SCNNode,
                         imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/\(imageName).png")
        child?.renderingOrder = 200 // IF A TRANSLUCENT IS RENDERED FIRST WITH AN OPAQUE BEHIND - COLORS GET MIXED

        if let mask = child?.childNode(withName: "mask", recursively: false) {
            mask.geometry?.firstMaterial?.transparency = 0.000001 // translucent = rendering order
        }
    }
}

// MARK: - ARSCNViewDelegate
extension PortalScreen: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {
            return
        }
    }
}
