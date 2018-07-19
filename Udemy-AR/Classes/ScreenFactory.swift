//
//  Navigator.swift
//  Udemy-AR
//
//  Created by Bruno Muniz on 7/18/18.
//  Copyright © 2018 Bruno Muniz. All rights reserved.
//

import UIKit

final class ScreenFactory {
    public func screenFor(_ screenName: String) -> UIViewController? {
        var screen: UIViewController?

        switch screenName {
        case "World tracking":
            screen = WorldTrackingScreen(nibName: String(describing: WorldTrackingScreen.self),
                                         bundle: nil)
            break
        case "Nodes":
            screen = NodesScreen(nibName: String(describing: NodesScreen.self),
                                 bundle: nil)
            break
        case "Actions":
            screen = ActionsScreen(nibName: String(describing: ActionsScreen.self),
                                   bundle: nil)
            break
        case "External models":
            screen = ExternalModelsScreen(nibName: String(describing: ExternalModelsScreen.self),
                                          bundle: nil)
            break
        case "Drawing":
            screen = DrawingScreen(nibName: String(describing: DrawingScreen.self),
                                   bundle: nil)
            break
        case "Hit testing":
            screen = HitTestingScreen(nibName: String(describing: HitTestingScreen.self),
                                      bundle: nil)
            break
        case "Plane detection":
            screen = PlaneDetectionScreen(nibName: String(describing: PlaneDetectionScreen.self),
                                          bundle: nil)
            break
        case "Scaling":
            screen = ScalingScreen(nibName: String(describing: ScalingScreen.self),
                                   bundle: nil)
            break
        case "Vehicle":
            screen = VehicleScreen(nibName: String(describing: VehicleScreen.self),
                                   bundle: nil)
            break
        case "Measurements":
            screen = MeasurementsScreen(nibName: String(describing: MeasurementsScreen.self),
                                        bundle: nil)
            break
        case "Portal":
            screen = PortalScreen(nibName: String(describing: PortalScreen.self),
                                  bundle: nil)
            break
        case "Projectiles":
            screen = ProjectilesScreen(nibName: String(describing: ProjectilesScreen.self),
                                       bundle: nil)
            break
        case "Collisions":
            screen = CollisionsScreen(nibName: String(describing: CollisionsScreen.self),
                                      bundle: nil)
            break
        case "Reflections":
            screen = ReflectionsScreen(nibName: String(describing: ReflectionsScreen.self),
                                       bundle: nil)
            break
        default:
            return nil
        }

        return screen
    }
}
