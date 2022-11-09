//
//  CollectionViewModel.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import Foundation

final class CollectionViewModel {
    
    var collectibleItem: ObservableObject<String> = ObservableObject(value: "")
    var collectibleLocked: ObservableObject<String> = ObservableObject(value: "")
    var collectibleName: ObservableObject<String> = ObservableObject(value: "")
    var collectibleDesc: ObservableObject<String> = ObservableObject(value: "")
    var collectibleOrigin: ObservableObject<String> = ObservableObject(value: "")
    var isObtained: ObservableObject<Bool> = ObservableObject(value: false)
    
    var collectionArray: [Collection] = []
    var feeder = CollectionFeeder()
    
    var obtainedStatus: [Bool] = []
    
    let defaults = UserDefaults.standard
    
    
    func initializeCollection()
    {
        collectionArray = feeder.feedCollection()
        
        obtainedStatus.removeAll()
        
        for _ in collectionArray
        {
            obtainedStatus.append(false)
        }
        
        defaults.set(obtainedStatus, forKey: "collectiblesObtainedStatus")
        
    }
    
    func getCollection(index: Int) {
        
        let collectionArray = feeder.feedCollection()
        
        obtainedStatus = defaults.array(forKey: "collectiblesObtainedStatus") as? [Bool] ?? [Bool]()
        
        self.collectibleItem.value = collectionArray[index].collectibleItem
        self.collectibleLocked.value = collectionArray[index].collectibleLockedModel
        self.collectibleName.value = collectionArray[index].collectibleName
        self.collectibleDesc.value = collectionArray[index].collectibleDesc
        self.collectibleOrigin.value = collectionArray[index].collectibleOrigin
        self.isObtained.value = obtainedStatus[index]
    }
    
    func getCollection(card: String)
    {
        let collectionArray = feeder.feedCollection()
        
        obtainedStatus = defaults.array(forKey: "collectiblesObtainedStatus") as? [Bool] ?? [Bool]()
        
        for collection in collectionArray
        {
            if collection.collectibleName == card
            {
                self.collectibleItem.value = collection.collectibleItem
                self.collectibleLocked.value = collection.collectibleLockedModel
                self.collectibleName.value = collection.collectibleName
                self.collectibleDesc.value = collection.collectibleDesc
                self.collectibleOrigin.value = collection.collectibleOrigin
                self.isObtained.value = obtainedStatus[collectionArray.firstIndex(where: { collection in
                    collection.collectibleName == card
                }) ?? 0]
            }
        }
    }
    
    func obtainItem(index: Int)
    {
        obtainedStatus[index].toggle()
        defaults.set(obtainedStatus, forKey: "collectiblesObtainedStatus")
    }
       
}
