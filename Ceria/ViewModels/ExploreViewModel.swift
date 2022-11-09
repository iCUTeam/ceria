//
//  ExploreViewModel.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import Foundation

final class ExploreViewModel
{
    
    //MARK: logic buka tutup can Interact
    //1. Pas di explore tugu diklik -> close can interact terus move ke next viewmodel
    
    var cardName: ObservableObject<String> = ObservableObject(value: "")
    var cardModel: ObservableObject<String> = ObservableObject(value: "")
    var canInteract: ObservableObject<Bool> = ObservableObject(value: false)
    var currentName: ObservableObject<String> = ObservableObject(value: "checkpoint_istana")
    
    var cardArray: [Card] = []
    var feeder = CardFeeder()
    
    let defaults = UserDefaults.standard
    
    func getExploring()
    {
        cardArray = feeder.feedCard()
        
        for card in cardArray
        {
            if card.cardName == currentName.value
            {
                self.cardName.value = card.cardName
                self.cardModel.value = card.cardModel
                self.canInteract.value = defaults.bool(forKey: currentName.value)
            }
        }
    }
    
    func changeInteractionPerm()
    {
        self.canInteract.value.toggle()
        defaults.set(self.canInteract.value, forKey: currentName.value)
    }
}
