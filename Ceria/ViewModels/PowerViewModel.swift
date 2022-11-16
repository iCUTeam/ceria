//
//  PowerViewModel.swift
//  Ceria
//
//  Created by Kevin Gosalim on 16/10/22.
//

import Foundation

final class PowerViewModel {
    
    var powerHeadNormal: ObservableObject<String> = ObservableObject(value: "")
    var powerHeadSuccess: ObservableObject<String> = ObservableObject(value: "")
    var powerHintText: ObservableObject<String> = ObservableObject(value: "")
    var powerSuccessText: ObservableObject<String> = ObservableObject(value: "")
    var powerIntroVoice: ObservableObject<String> = ObservableObject(value: "")
    var powerHintVoice: ObservableObject<String> = ObservableObject(value: "")
    var powerSuccessVoice: ObservableObject<String> = ObservableObject(value: "")
    var powerPatternImage: ObservableObject<String> = ObservableObject(value: "")
    var powerBackgroundImage: ObservableObject<String> = ObservableObject(value: "")
    var powerPatternReference: ObservableObject<String> = ObservableObject(value: "")
    
    var powerArray: [Power] = []
    var feeder = PowerFeeder()

    var currentIndex: ObservableObject<Int> = ObservableObject(value: 0)
    
    let defaults = UserDefaults.standard
    
    func getPower() {
        
        let powerArray = feeder.feedPower()
       
        self.powerHeadNormal.value = powerArray[currentIndex.value].powerHeadNormal
        self.powerHeadSuccess.value = powerArray[currentIndex.value].powerHeadSuccess
        self.powerHintText.value = powerArray[currentIndex.value].powerHintText
        self.powerSuccessText.value = powerArray[currentIndex.value].powerSuccessText
        self.powerIntroVoice.value = powerArray[currentIndex.value].powerIntroVoice
        self.powerHintVoice.value = powerArray[currentIndex.value].powerHintVoice
        self.powerSuccessVoice.value = powerArray[currentIndex.value].powerSuccessVoice
        self.powerPatternImage.value = powerArray[currentIndex.value].powerPatternImage
        self.powerBackgroundImage.value = powerArray[currentIndex.value].powerBackgroundImage
        self.powerPatternReference.value = powerArray[currentIndex.value].powerPatternReference
    }
    
    func loadPower() {
        currentIndex.value = defaults.integer(forKey: "powerIndex")
        getPower()
    }
}
