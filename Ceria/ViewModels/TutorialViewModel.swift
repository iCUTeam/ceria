//
//  TutorialViewModel.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import Foundation

final class TutorialViewModel {
    
    var tutorialImage: ObservableObject<String> = ObservableObject(value: "")
    var tutorialDialogue: ObservableObject<String> = ObservableObject(value: "")
    var tutorialVoice: ObservableObject<String> = ObservableObject(value: "")
    var tutorialMusic: ObservableObject<String> = ObservableObject(value: "")
    var isBackButtonHidden: ObservableObject<Bool> = ObservableObject(value: false)
    var isNextButtonHidden: ObservableObject<Bool> = ObservableObject(value: true)
    var isActionButtonHidden: ObservableObject<Bool> = ObservableObject(value: false)
    var actionButtonType: ObservableObject<String> = ObservableObject(value: "")
    var actionButtonSFX: ObservableObject<String> = ObservableObject(value: "")
    
    var tutorialsArray: [Tutorial] = []
    var feeder = TutorialFeeder()

    var currentIndex: ObservableObject<Int> = ObservableObject(value: 0)
    
    func getTutorial() {
        
        let tutorialsArray = feeder.feedTutorial()
       
        self.tutorialImage.value = tutorialsArray[currentIndex.value].tutorialImage
        self.tutorialDialogue.value = tutorialsArray[currentIndex.value].tutorialDialogue
        self.tutorialVoice.value = tutorialsArray[currentIndex.value].tutorialVoice
        self.tutorialMusic.value = tutorialsArray[currentIndex.value].tutorialMusic
        self.isBackButtonHidden.value = tutorialsArray[currentIndex.value].isBackButtonHidden
        self.isNextButtonHidden.value = tutorialsArray[currentIndex.value].isNextButtonHidden
        self.isActionButtonHidden.value = tutorialsArray[currentIndex.value].isActionButtonHidden
        self.actionButtonType.value = tutorialsArray[currentIndex.value].actionButtonType
        self.actionButtonSFX.value = tutorialsArray[currentIndex.value].actionButtonSFX
    }
    
    func previousIndex() {
        if currentIndex.value == 0 {
            currentIndex.value = tutorialsArray.count-1
        } else {
            currentIndex.value -= 1
        }
        
        getTutorial()
    }
    
    func nextIndex() {
        if currentIndex.value == tutorialsArray.count-1 {
            currentIndex.value = 0
        } else {
            currentIndex.value += 1
        }
        
        getTutorial()
    }
}
