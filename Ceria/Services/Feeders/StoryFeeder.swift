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
        let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "stories", ofType: "json")!)
        let data = try! Data(contentsOf: url as URL)
        storiesArray = try! JSONDecoder().decode([Story].self, from: data)
        
        return storiesArray
    }
}
