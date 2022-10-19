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
        let url = Bundle.main.url(forResource: "tutorial", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        tutorialsArray = try! JSONDecoder().decode([Tutorial].self, from: data)
        
        return tutorialsArray
    }
}
