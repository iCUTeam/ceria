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
    var collectibleSFX: ObservableObject<String> = ObservableObject(value: "")
    var isObtained: ObservableObject<Bool> = ObservableObject(value: false)
    var collectibleCard: ObservableObject<String> = ObservableObject(value: "")
    var collectibleButton: ObservableObject<String> = ObservableObject(value: "")
    var collectibleHint: ObservableObject<String> = ObservableObject(value: "")
    var collectibleHintString: ObservableObject<String> = ObservableObject(value: "")
    var currIndex: ObservableObject<Int> = ObservableObject(value: 0)
    
    var collectionArray: [Collection] = []
    var feeder = CollectionFeeder()
    
    var currentIndex: Int = 0
    
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
        self.collectibleSFX.value = collectionArray[index].collectibleSFX
        self.collectibleCard.value = collectionArray[index].collectibleCard
        self.collectibleButton.value = collectionArray[index].collectibleButton
        self.collectibleHint.value = collectionArray[index].collectibleHint
        self.collectibleHintString.value = collectionArray[index].collectibleHintString
        self.isObtained.value = obtainedStatus[index]
        self.currentIndex = index
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
                self.collectibleSFX.value = collection.collectibleSFX
                self.isObtained.value = obtainedStatus[collectionArray.firstIndex(where: { collection in
                    collection.collectibleName == card
                }) ?? 0]
                self.collectibleCard.value = collection.collectibleCard
                self.collectibleButton.value = collection.collectibleButton
                self.collectibleHint.value = collection.collectibleHint
                self.collectibleHintString.value = collection.collectibleHintString
                self.currentIndex = collectionArray.firstIndex(where: { collection in
                    collection.collectibleName == card
                }) ?? 0
            }
        }
    }
    
    func obtainItem()
    {
        obtainedStatus[currentIndex] = true
        defaults.set(obtainedStatus, forKey: "collectiblesObtainedStatus")
    }
       
}
