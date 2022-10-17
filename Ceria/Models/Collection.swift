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
    let collectibleName: String
    let collectibleOrigin: String
    let collectibleDesc: String
    let isObtained: Bool
    
    enum CodingKeys: String, CodingKey
    {
        case collectibleItem = "collectible_item"
        case collectibleName = "collectible_name"
        case collectibleOrigin = "collectible_origin"
        case collectibleDesc = "collectible_desc"
        case isObtained = "is_obtained"
    }
}
