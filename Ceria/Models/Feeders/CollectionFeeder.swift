//
//  CollectionFeeder.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 17/10/22.
//

import Foundation

class CollectionFeeder
{
    func feedCollection() -> [Collection]
    {
        var collectionArray: [Collection] = []
        let url = Bundle.main.url(forResource: "collection", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        collectionArray = try! JSONDecoder().decode([Collection].self, from: data)
        
        return collectionArray
    }
}
