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
    let promptTextLine1: Int
    let promptTextLine2: Int
    let promptVoice: String
    let promptMusic: String
    let isBackButtonHidden: Bool
    let isNextButtonHidden: Bool
    let isActionButtonHidden: Bool
    let actionButtonType: String
    let actionButtonSFX: String

    enum CodingKeys: String, CodingKey {
        case promptImage = "prompt_image"
        case promptDialogue = "prompt_dialogue"
        case promptTextLine1 = "prompt_dialogue_line_1"
        case promptTextLine2 = "prompt_dialogue_line_2"
        case promptVoice = "prompt_voice"
        case promptMusic = "prompt_music"
        case isBackButtonHidden = "back_button_hidden"
        case isNextButtonHidden = "next_button_hidden"
        case isActionButtonHidden = "action_button_hidden"
        case actionButtonType = "action_button_type"
        case actionButtonSFX = "action_button_sfx"
    }
}
