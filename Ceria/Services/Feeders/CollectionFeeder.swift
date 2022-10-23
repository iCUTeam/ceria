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
        let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "collection", ofType: "json")!)
        let data = try! Data(contentsOf: url as URL)
        collectionArray = try! JSONDecoder().decode([Collection].self, from: data)
        
        return collectionArray
    }
}
