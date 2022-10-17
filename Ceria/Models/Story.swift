//
//  Story.swift
//  Ceria
//
//  Created by Kevin Gosalim on 13/10/22.
//

import Foundation

struct Story: Codable {
    let storyImage: String
    let storyDialogue: String
    let storyVoice: String
    let storyMusic: String
    let isBackButtonHidden: Bool
    let isNextButtonHidden: Bool
    let isActionButtonHidden: Bool
    let actionButtonType: String
    let actionButtonSFX: String

    enum CodingKeys: String, CodingKey {
        case storyImage = "story_image"
        case storyDialogue = "story_dialogue"
        case storyVoice = "story_voice"
        case storyMusic = "story_music"
        case isBackButtonHidden = "back_button_hidden"
        case isNextButtonHidden = "next_button_hidden"
        case isActionButtonHidden = "action_button_hidden"
        case actionButtonType = "action_button_type"
        case actionButtonSFX = "action_button_sfx"
    }
}
