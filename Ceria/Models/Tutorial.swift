//
//  Tutorial.swift
//  Ceria
//
//  Created by Kevin Gosalim on 13/10/22.
//

import Foundation

struct Tutorial: Codable {
    let tutorialImage: String
    let tutorialDialogue: String
    let tutorialVoice: String
    let tutorialMusic: String
    let isBackButtonHidden: Bool
    let isNextButtonHidden: Bool
    let isActionButtonHidden: Bool
    let actionButtonType: String
    let actionButtonSFX: String

    enum CodingKeys: String, CodingKey {
        case tutorialImage = "tutorial_image"
        case tutorialDialogue = "tutorial_dialogue"
        case tutorialVoice = "tutorial_voice"
        case tutorialMusic = "tutorial_music"
        case isBackButtonHidden = "back_button_hidden"
        case isNextButtonHidden = "next_button_hidden"
        case isActionButtonHidden = "action_button_hidden"
        case actionButtonType = "action_button_type"
        case actionButtonSFX = "action_button_sfx"
    }
}
