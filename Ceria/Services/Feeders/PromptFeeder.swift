//
//  PromptFeeder.swift
//  Ceria
//
//  Created by Kevin Gosalim on 15/10/22.
//

import Foundation

class PromptFeeder {
    
    func feedPrompt() -> [Prompt] {
        
        var promptsArray: [Prompt] = []
        let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "reflection", ofType: "json")!)
        let data = try! Data(contentsOf: url as URL)
        promptsArray = try! JSONDecoder().decode([Prompt].self, from: data)
        
        return promptsArray
    }
}
