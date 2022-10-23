//
//  TutorialFeeder.swift
//  Ceria
//
//  Created by Kevin Gosalim on 19/10/22.
//

import Foundation

class TutorialFeeder {
    
    func feedTutorial() -> [Tutorial] {
        
        var tutorialsArray: [Tutorial] = []
        let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "tutorial", ofType: "json")!)
        let data = try! Data(contentsOf: url as URL)
        tutorialsArray = try! JSONDecoder().decode([Tutorial].self, from: data)
        
        return tutorialsArray
    }
}
