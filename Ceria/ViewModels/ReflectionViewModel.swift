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
    var isBackButtonVisible: ObservableObject<Bool> = ObservableObject(value: false)
    var isNextButtonVisible: ObservableObject<Bool> = ObservableObject(value: true)
    var isActionButtonVisible: ObservableObject<Bool> = ObservableObject(value: false)
    var actionButtonType: ObservableObject<String> = ObservableObject(value: "")
    var actionButtonSFX: ObservableObject<String> = ObservableObject(value: "")
    
    var promptsArray: [Prompt] = []
    var feeder = PromptFeeder()

    var currIndex: ObservableObject<Int> = ObservableObject(value: 0)
    
    func getPrompt() {
        
        let promptsArray = feeder.feedPrompt()
       
        self.promptImage.value = promptsArray[currIndex.value].promptImage
        self.promptDialogue.value = promptsArray[currIndex.value].promptDialogue
        self.promptVoice.value = promptsArray[currIndex.value].promptVoice
        self.promptMusic.value = promptsArray[currIndex.value].promptMusic
        self.isBackButtonVisible.value = promptsArray[currIndex.value].isBackButtonVisible
        self.isNextButtonVisible.value = promptsArray[currIndex.value].isNextButtonVisible
        self.isActionButtonVisible.value = promptsArray[currIndex.value].isActionButtonVisible
        self.actionButtonType.value = promptsArray[currIndex.value].actionButtonType
        self.actionButtonSFX.value = promptsArray[currIndex.value].actionButtonSFX
    }
    
    func previousIndex() {
        if currIndex.value == 0 {
            currIndex.value = promptsArray.count-1
        } else {
            currIndex.value -= 1
        }
        
        getPrompt()
    }
    
    func nextIndex() {
        if currIndex.value == promptsArray.count-1 {
            currIndex.value = 0
        } else {
            currIndex.value += 1
        }
        
        getPrompt()
    }
}
