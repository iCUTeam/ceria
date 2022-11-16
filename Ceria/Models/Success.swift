//
//  Success.swift
//  Carita
//
//  Created by Kevin Gosalim on 15/11/22.
//

import Foundation

struct Success: Codable {
    let successText1: String
    let successText2: String
    let successVoice1: String
    let successVoice2: String
    let successCardImage: String
    let successCardText: String
    let successCardVoice: String
    let successBackground: String

    enum CodingKeys: String, CodingKey {
        case successText1 = "success_text_1"
        case successText2 = "success_text_2"
        case successVoice1 = "success_voice_1"
        case successVoice2 = "success_voice_2"
        case successCardImage = "success_card_image"
        case successCardText = "success_card_text"
        case successCardVoice = "success_card_voice"
        case successBackground = "success_background"
    }
}
