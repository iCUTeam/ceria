//
//  Story.swift
//  Ceria
//
//  Created by Kevin Gosalim on 13/10/22.
//

import Foundation
import UIKit

struct Story: Codable {
    let storyImage: String
    let storyDialogue: String
    let storyVoice: String
    let storyMusic: String
    var backButtonVisibility: Bool
    var nextButtonVisibility: Bool
    var actionButtonVisibility: Bool
    let actionButtonType: String
    let actionButtonSFX: String

    enum CodingKeys: String, CodingKey {
        case storyImage = "story_image"
        case storyDialogue = "story_dialogue"
        case storyVoice = "story_voice"
        case storyMusic = "story_music"
        case backButtonVisibility = "back_button_visibility"
        case nextButtonVisibility = "next_button_visibility"
        case actionButtonVisibility = "action_button_visibility"
        case actionButtonType = "action_button_type"
        case actionButtonSFX = "action_button_sfx"
    }
}

class StoryFeeder {
    func feedStory() -> [Story] {
        
        var storiesArray = [Story]()
        
        let url = Bundle.main.url(forResource: "stories", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        storiesArray = try! JSONDecoder().decode([Story].self, from: data)
        
        return storiesArray
    }
}
