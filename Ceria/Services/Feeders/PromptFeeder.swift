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
        let url = Bundle.main.url(forResource: "reflection", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        promptsArray = try! JSONDecoder().decode([Prompt].self, from: data)
        
        return promptsArray
    }
}
