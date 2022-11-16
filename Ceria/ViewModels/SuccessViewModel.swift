//
//  SuccessViewModel.swift
//  Carita
//
//  Created by Kevin Gosalim on 15/11/22.
//

import Foundation

final class SuccessViewModel {
    
    var successText1: ObservableObject<String> = ObservableObject(value: "")
    var successText2: ObservableObject<String> = ObservableObject(value: "")
    var successVoice1: ObservableObject<String> = ObservableObject(value: "")
    var successVoice2: ObservableObject<String> = ObservableObject(value: "")
    var successCardImage: ObservableObject<String> = ObservableObject(value: "")
    var successCardText: ObservableObject<String> = ObservableObject(value: "")
    var successCardVoice: ObservableObject<String> = ObservableObject(value: "")
    var successBackground: ObservableObject<String> = ObservableObject(value: "")
    
    var successArray: [Success] = []
    var feeder = SuccessFeeder()

    var currentIndex: ObservableObject<Int> = ObservableObject(value: 0)
    
    let defaults = UserDefaults.standard
    
    func getSuccess() {
        
        let successArray = feeder.feedSuccess()
       
        self.successText1.value = successArray[currentIndex.value].successText1
        self.successText2.value = successArray[currentIndex.value].successText2
        self.successVoice1.value = successArray[currentIndex.value].successVoice1
        self.successVoice2.value = successArray[currentIndex.value].successVoice2
        self.successCardImage.value = successArray[currentIndex.value].successCardImage
        self.successCardText.value = successArray[currentIndex.value].successCardText
        self.successCardVoice.value = successArray[currentIndex.value].successCardVoice
        self.successBackground.value = successArray[currentIndex.value].successBackground
    }
    
    func saveIndex() {
        defaults.set(currentIndex.value, forKey: "successIndex")
    }
    
    func loadSuccess() {
        currentIndex.value = defaults.integer(forKey: "successIndex")
        getSuccess()
    }
    
    func nextIndex() {
        if currentIndex.value == successArray.count-1 {
            currentIndex.value = 0
        } else {
            currentIndex.value += 1
        }
        
        getSuccess()
    }
}
