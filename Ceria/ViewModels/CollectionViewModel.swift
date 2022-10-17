//
//  CollectionViewModel.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import Foundation

final class CollectionViewModel {
    
    var collectibleItem: ObservableObject<String> = ObservableObject(value: "")
    var collectibleName: ObservableObject<String> = ObservableObject(value: "")
    var collectibleDesc: ObservableObject<String> = ObservableObject(value: "")
    var collectibleOrigin: ObservableObject<String> = ObservableObject(value: "")
    var isObtained: ObservableObject<Bool> = ObservableObject(value: false)
    
    var collectionArray: [Collection] = []
    var feeder = CollectionFeeder()
    
    var obtainedStatus: [Bool] = []
    
    let defaults = UserDefaults.standard
    
    func getCollection() {
        
        let collectionArray = feeder.feedCollection()
        
        for collectibles in collectionArray
        {
            obtainedStatus.append(collectibles.isObtained)
            defaults.set(obtainedStatus, forKey: "collectiblesObtainedStatus")
        }
        
    }
    
    func obtainItem(index: Int)
    {
        obtainedStatus[index].toggle()
        defaults.set(obtainedStatus, forKey: "collectiblesObtainedStatus")
    }
       
}
