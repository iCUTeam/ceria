//
//  Reflection.swift
//  Ceria
//
//  Created by Kevin Gosalim on 13/10/22.
//

import Foundation

struct Prompt: Codable {
    let promptImage: String
    let promptDialogue: String
    let promptVoice: String
    let promptMusic: String
    let isBackButtonVisible: Bool
    let isNextButtonVisible: Bool
    let isActionButtonVisible: Bool
    let actionButtonType: String
    let actionButtonSFX: String

    enum CodingKeys: String, CodingKey {
        case promptImage = "prompt_image"
        case promptDialogue = "prompt_dialogue"
        case promptVoice = "prompt_voice"
        case promptMusic = "prompt_music"
        case isBackButtonVisible = "back_button_visibility"
        case isNextButtonVisible = "next_button_visibility"
        case isActionButtonVisible = "action_button_visibility"
        case actionButtonType = "action_button_type"
        case actionButtonSFX = "action_button_sfx"
    }
}
