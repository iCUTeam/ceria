//
//  StoryViewModel.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import Foundation

final class StoryViewModel {
    
    var storyImage: ObservableObject<String> = ObservableObject(value: "")
    var storyDialogue: ObservableObject<String> = ObservableObject(value: "")
    var storyTextLine1: ObservableObject<Int> = ObservableObject(value: 0)
    var storyTextLine2: ObservableObject<Int> = ObservableObject(value: 0)
    var storyVoice: ObservableObject<String> = ObservableObject(value: "")
    var storyMusic: ObservableObject<String> = ObservableObject(value: "")
    var isBackButtonHidden: ObservableObject<Bool> = ObservableObject(value: false)
    var isNextButtonHidden: ObservableObject<Bool> = ObservableObject(value: true)
    var isActionButtonHidden: ObservableObject<Bool> = ObservableObject(value: false)
    var actionButtonType: ObservableObject<String> = ObservableObject(value: "")
    var actionButtonSFX: ObservableObject<String> = ObservableObject(value: "")
    var currentIndex: ObservableObject<Int> = ObservableObject(value: 0)
    
    var storiesArray: [Story] = []
    var feeder = StoryFeeder()
    
    let defaults = UserDefaults.standard
    
    func getStory() {
        
        let storiesArray = feeder.feedStory()
       
        self.storyImage.value = storiesArray[currentIndex.value].storyImage
        self.storyDialogue.value = storiesArray[currentIndex.value].storyDialogue
        self.storyTextLine1.value = storiesArray[currentIndex.value].storyTextLine1
        self.storyTextLine2.value = storiesArray[currentIndex.value].storyTextLine2
        self.storyVoice.value = storiesArray[currentIndex.value].storyVoice
        self.storyMusic.value = storiesArray[currentIndex.value].storyMusic
        self.isBackButtonHidden.value = storiesArray[currentIndex.value].isBackButtonHidden
        self.isNextButtonHidden.value = storiesArray[currentIndex.value].isNextButtonHidden
        self.isActionButtonHidden.value = storiesArray[currentIndex.value].isActionButtonHidden
        self.actionButtonType.value = storiesArray[currentIndex.value].actionButtonType
        self.actionButtonSFX.value = storiesArray[currentIndex.value].actionButtonSFX
    }
    
    func saveIndex() {
        defaults.set(currentIndex.value, forKey: "storyIndex")
    }
    
    func loadStory() {
        currentIndex.value = defaults.integer(forKey: "storyIndex")
        getStory()
    }
    
    func previousIndex() {
        if currentIndex.value == 0 {
            currentIndex.value = storiesArray.count-1
        } else {
            currentIndex.value -= 1
        }
        
        getStory()
    }
    
    func nextIndex() {
        if currentIndex.value == storiesArray.count-1 {
            currentIndex.value = 0
        } else {
            currentIndex.value += 1
        }
        
        getStory()
    }
}
