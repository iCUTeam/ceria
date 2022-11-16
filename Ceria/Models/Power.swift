//
//  Power.swift
//  Carita
//
//  Created by Kevin Gosalim on 15/11/22.
//

import Foundation

struct Power: Codable {
    let powerHeadNormal: String
    let powerHeadSuccess: String
    let powerHintText: String
    let powerSuccessText: String
    let powerIntroVoice: String
    let powerHintVoice: String
    let powerSuccessVoice: String
    let powerPatternImage: String
    let powerBackgroundImage: String
    let powerPatternReference: String

    enum CodingKeys: String, CodingKey {
        case powerHeadNormal = "power_head_normal"
        case powerHeadSuccess = "power_head_success"
        case powerHintText = "power_hint"
        case powerSuccessText = "power_success"
        case powerIntroVoice = "power_intro_sfx"
        case powerHintVoice = "power_hint_sfx"
        case powerSuccessVoice = "power_success_sfx"
        case powerPatternImage = "power_pattern_image"
        case powerBackgroundImage = "power_background"
        case powerPatternReference = "power_pattern_draw"
    }
}
