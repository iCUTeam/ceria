//
//  DotModel.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 11/10/22.
//

import Foundation

public struct Dots
{
    public let order: Int
    public let location: CGPoint
    public let connected: Bool
    
    init(order: Int, location: CGPoint, connected: Bool) {
        self.order = order
        self.location = location
        self.connected = connected
    }
}
