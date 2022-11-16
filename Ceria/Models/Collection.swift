//
//  Collection.swift
//  Ceria
//
//  Created by Kevin Gosalim on 13/10/22.
//

import Foundation

struct Collection: Codable
{
    let collectibleItem: String
    let collectibleLockedModel: String
    let collectibleName: String
    let collectibleOrigin: String
    let collectibleSFX: String
    let collectibleDesc: String
    let collectibleCard: String
    let collectibleButton: String
    let collectibleHint: String
    let collectibleHintString: String
    
    enum CodingKeys: String, CodingKey
    {
        case collectibleItem = "collectible_item"
        case collectibleLockedModel = "collectible_locked_model"
        case collectibleName = "collectible_name"
        case collectibleOrigin = "collectible_origin"
        case collectibleSFX = "collectible_sfx"
        case collectibleDesc = "collectible_desc"
        case collectibleCard = "collectible_card"
        case collectibleButton = "collectible_button"
        case collectibleHint = "collectible_hint"
        case collectibleHintString = "collectible_hint_string"
    }
}
