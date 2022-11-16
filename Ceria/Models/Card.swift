//
//  Card.swift
//  Ceria
//
//  Created by Kevin Gosalim on 13/10/22.
//

import Foundation

struct Card: Codable
{
    let cardName: String
    let cardModel: String
    let cardButton: String
    let canInteract: Bool
    let hintVoice: String
    let foundVoice: String
    let hintString: String
    let nextState: String
    
    enum CodingKeys: String, CodingKey
    {
        case cardName = "card_name"
        case cardModel = "card_model"
        case cardButton = "card_button"
        case canInteract = "can_interact"
        case hintVoice = "hint_voice"
        case foundVoice = "found_voice"
        case hintString = "hint_string"
        case nextState = "next_state"
    }
}
