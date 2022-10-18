//
//  MotionHelper.swift
//  icu
//
//  Created by Kathleen Febiola Susanto on 04/10/22.
//

import Foundation
import CoreMotion

class MotionHelper
{
    let motionManager = CMMotionManager()

    init()
    {
        
    }
    
    func getAccelerometerData(interval: TimeInterval = 0.1, motionDataResults: ((_ x: Float, _ y: Float, _ z: Float) -> ())? )
    {
        if motionManager.isAccelerometerAvailable
        {
            motionManager.accelerometerUpdateInterval = interval
            
            motionManager.startAccelerometerUpdates(to: OperationQueue()) { (data, error) in
                if motionDataResults != nil
                {
                    motionDataResults!(Float(data!.acceleration.x), Float(data!.acceleration.y), Float(data!.acceleration.z))
                }
            }
        }
    }
    
    func getGyroData(interval: TimeInterval = 0.1, motionDataResults: ((_ x: Float, _ y: Float, _ z: Float) -> ())? )
    {
        if motionManager.isGyroAvailable
        {
            motionManager.gyroUpdateInterval = interval
            
            motionManager.startGyroUpdates(to: OperationQueue()) { (data, error) in
                if motionDataResults != nil
                {
                    motionDataResults!(Float(data!.rotationRate.x), Float(data!.rotationRate.y), Float(data!.rotationRate.z))
                }
            }
            
        }
    }
}
