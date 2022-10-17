//
//  NewOperation.swift
//  icu
//
//  Created by Kathleen Febiola Susanto on 04/10/22.
//

import Foundation
import SceneKit
import RealityKit

func +(left: SCNVector3, right:  SCNVector3) -> SCNVector3
{
    return SCNVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func +(left: SIMD3<Float>, right: SIMD3<Float>) -> SIMD3<Float>
{
    return SIMD3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func +=(left: inout SCNVector3, right: SCNVector3)
{
    left = left + right
}

func +=(left: inout SIMD3<Float>, right: SIMD3<Float>)
{
    left = left + right
}
