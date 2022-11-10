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
    let canInteract: Bool
    let hintVoice: String
    let hintString: String
    let nextState: String
    
    enum CodingKeys: String, CodingKey
    {
        case cardName = "card_name"
        case cardModel = "card_model"
        case canInteract = "can_interact"
        case hintVoice = "hint_voice"
        case hintString = "hint_string"
        case nextState = "next_state"
    }
}
