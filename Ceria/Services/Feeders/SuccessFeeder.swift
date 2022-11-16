//
//  SuccessFeeder.swift
//  Carita
//
//  Created by Kevin Gosalim on 15/11/22.
//

import Foundation

class SuccessFeeder {
    
    func feedSuccess() -> [Success] {
        
        var successArray: [Success] = []
        let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "success", ofType: "json")!)
        let data = try! Data(contentsOf: url as URL)
        successArray = try! JSONDecoder().decode([Success].self, from: data)
        
        return successArray
    }
}
