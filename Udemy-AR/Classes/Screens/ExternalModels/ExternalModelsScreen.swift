//
//  ExternalModelsScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class ExternalModelsScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
}

// MARK: - Lifecycle
extension ExternalModelsScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.session.run(configuration)
        addNode()
    }
}

// MARK: - Private
extension ExternalModelsScreen {
    private func addNode() {
        let jellyfishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyfishNode = jellyfishScene?.rootNode.childNode(withName: "Jelly", recursively: false)
        jellyfishNode?.position = SCNVector3(0, 0, -1)
        sceneView.scene.rootNode.addChildNode(jellyfishNode!)
    }
}
