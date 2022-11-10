//
//  LoadAnimation.swift
//  Carita
//
//  Created by Kathleen Febiola Susanto on 10/11/22.
//

import Foundation
import SceneKit

func animationFromSceneNamed(path: String) -> CAAnimation? {
    let scene  = SCNScene(named: path)
    var animation:CAAnimation?
    scene?.rootNode.enumerateChildNodes({ child, stop in
        if let animKey = child.animationKeys.first {
            animation = child.animation(forKey: animKey)
            stop.pointee = true
        }
    })
    return animation
}
