//
//  StoryFeeder.swift
//  Ceria
//
//  Created by Kevin Gosalim on 15/10/22.
//

import Foundation

class StoryFeeder {
    
    func feedStory() -> [Story] {
        
        var storiesArray: [Story] = []
        let url = Bundle.main.url(forResource: "stories", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        storiesArray = try! JSONDecoder().decode([Story].self, from: data)
        
        return storiesArray
    }
}
