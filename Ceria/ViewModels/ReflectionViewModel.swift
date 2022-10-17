//
//  ReflectionViewModel.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import Foundation

final class ReflectionViewModel {
    
    var promptImage: ObservableObject<String> = ObservableObject(value: "")
    var promptDialogue: ObservableObject<String> = ObservableObject(value: "")
    var promptVoice: ObservableObject<String> = ObservableObject(value: "")
    var promptMusic: ObservableObject<String> = ObservableObject(value: "")
    var isBackButtonHidden: ObservableObject<Bool> = ObservableObject(value: false)
    var isNextButtonHidden: ObservableObject<Bool> = ObservableObject(value: true)
    var isActionButtonHidden: ObservableObject<Bool> = ObservableObject(value: false)
    var actionButtonType: ObservableObject<String> = ObservableObject(value: "")
    var actionButtonSFX: ObservableObject<String> = ObservableObject(value: "")
    
    var promptsArray: [Prompt] = []
    var feeder = PromptFeeder()

    var currentIndex: ObservableObject<Int> = ObservableObject(value: 0)
    
    func getPrompt() {
        
        let promptsArray = feeder.feedPrompt()
       
        self.promptImage.value = promptsArray[currentIndex.value].promptImage
        self.promptDialogue.value = promptsArray[currentIndex.value].promptDialogue
        self.promptVoice.value = promptsArray[currentIndex.value].promptVoice
        self.promptMusic.value = promptsArray[currentIndex.value].promptMusic
        self.isBackButtonHidden.value = promptsArray[currentIndex.value].isBackButtonHidden
        self.isNextButtonHidden.value = promptsArray[currentIndex.value].isNextButtonHidden
        self.isActionButtonHidden.value = promptsArray[currentIndex.value].isActionButtonHidden
        self.actionButtonType.value = promptsArray[currentIndex.value].actionButtonType
        self.actionButtonSFX.value = promptsArray[currentIndex.value].actionButtonSFX
    }
    
    func previousIndex() {
        if currentIndex.value == 0 {
            currentIndex.value = promptsArray.count-1
        } else {
            currentIndex.value -= 1
        }
        
        getPrompt()
    }
    
    func nextIndex() {
        if currentIndex.value == promptsArray.count-1 {
            currentIndex.value = 0
        } else {
            currentIndex.value += 1
        }
        
        getPrompt()
    }
}
