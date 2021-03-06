//
//  ReflectionsScreen.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import ARKit

final class ReflectionsScreen: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Properties
    private let configuration = ARWorldTrackingConfiguration()
}

// MARK: - Lifecycle
extension ReflectionsScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.session.run(configuration)
    }
}
