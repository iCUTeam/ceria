//
//  PowerFeeder.swift
//  Carita
//
//  Created by Kevin Gosalim on 15/11/22.
//

import Foundation

class PowerFeeder {
    
    func feedPower() -> [Power] {
        
        var powerArray: [Power] = []
        let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "power", ofType: "json")!)
        let data = try! Data(contentsOf: url as URL)
        powerArray = try! JSONDecoder().decode([Power].self, from: data)
        
        return powerArray
    }
}
