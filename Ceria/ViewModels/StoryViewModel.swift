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
    var storyVoice: ObservableObject<String> = ObservableObject(value: "")
    var storyMusic: ObservableObject<String> = ObservableObject(value: "")
    var isBackButtonVisible: ObservableObject<Bool> = ObservableObject(value: false)
    var isNextButtonVisible: ObservableObject<Bool> = ObservableObject(value: true)
    var isActionButtonVisible: ObservableObject<Bool> = ObservableObject(value: false)
    var actionButtonType: ObservableObject<String> = ObservableObject(value: "")
    var actionButtonSFX: ObservableObject<String> = ObservableObject(value: "")
    
    var storiesArray: [Story] = []
    var feeder = StoryFeeder()

    var currIndex: ObservableObject<Int> = ObservableObject(value: 0)
    
    func getStory() {
        
        let storiesArray = feeder.feedStory()
       
        self.storyImage.value = storiesArray[currIndex.value].storyImage
        self.storyDialogue.value = storiesArray[currIndex.value].storyDialogue
        self.storyVoice.value = storiesArray[currIndex.value].storyVoice
        self.storyMusic.value = storiesArray[currIndex.value].storyMusic
        self.isBackButtonVisible.value = storiesArray[currIndex.value].isBackButtonVisible
        self.isNextButtonVisible.value = storiesArray[currIndex.value].isNextButtonVisible
        self.isActionButtonVisible.value = storiesArray[currIndex.value].isActionButtonVisible
        self.actionButtonType.value = storiesArray[currIndex.value].actionButtonType
        self.actionButtonSFX.value = storiesArray[currIndex.value].actionButtonSFX
    }
    
    func previousIndex() {
        if currIndex.value == 0 {
            currIndex.value = storiesArray.count-1
        } else {
            currIndex.value -= 1
        }
        
        getStory()
    }
    
    func nextIndex() {
        if currIndex.value == storiesArray.count-1 {
            currIndex.value = 0
        } else {
            currIndex.value += 1
        }
        
        getStory()
    }
}
