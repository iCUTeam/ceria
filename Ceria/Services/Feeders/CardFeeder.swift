//
//  CardFeeder.swift
//  Carita
//
//  Created by Kathleen Febiola Susanto on 09/11/22.
//

import Foundation

class CardFeeder
{
    func feedCard() -> [Card]
    {
        var cardArray: [Card] = []
        let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "card", ofType: "json")!)
        let data = try! Data(contentsOf: url as URL)
        cardArray = try! JSONDecoder().decode([Card].self, from: data)
        
        return cardArray
    }
}
