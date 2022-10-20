//
//  AudioPlayer.swift
//  Ceria
//
//  Created by Kevin Gosalim on 15/10/22.
//

import Foundation
import AVFoundation

class AudioBGMPlayer {
    
    static let shared = AudioBGMPlayer()
    var playerBGMLanding: AVAudioPlayer?
    var playerBGMStory: AVAudioPlayer?
    var playerBGMGame: AVAudioPlayer?
    var playerBGMSuccess: AVAudioPlayer?
    
    func playLanding() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "landing", ofType: "mp3")!)
        do {
            playerBGMLanding = try AVAudioPlayer(contentsOf:sound as URL)
            playerBGMLanding?.numberOfLoops = -1
            playerBGMLanding?.prepareToPlay()
            playerBGMLanding?.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
    
    func stopLanding() {
        playerBGMLanding?.stop()
    }
    
    func playStoryBGM1() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "petualangan", ofType: "m4a")!)
        do {
            playerBGMStory = try AVAudioPlayer(contentsOf:sound as URL)
            playerBGMStory?.numberOfLoops = -1
            playerBGMStory?.prepareToPlay()
            playerBGMStory?.volume = 0.1
            playerBGMStory?.numberOfLoops = -1
            playerBGMStory?.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
    
    func playStoryBGM2() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sedih", ofType: "m4a")!)
        do {
            playerBGMStory = try AVAudioPlayer(contentsOf:sound as URL)
            playerBGMStory?.numberOfLoops = -1
            playerBGMStory?.prepareToPlay()
            playerBGMStory?.volume = 0.3
            playerBGMStory?.numberOfLoops = -1
            playerBGMStory?.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
    
    func playStoryBGM3() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "laut", ofType: "m4a")!)
        do {
            playerBGMStory = try AVAudioPlayer(contentsOf:sound as URL)
            playerBGMStory?.numberOfLoops = -1
            playerBGMStory?.prepareToPlay()
            playerBGMStory?.volume = 0.3
            playerBGMStory?.numberOfLoops = -1
            playerBGMStory?.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
    
    func stopStoryBGM() {
        playerBGMStory?.stop()
    }
    
    func playGame2BGM() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "game2-bgm", ofType: "m4a")!)
        do {
            playerBGMGame = try AVAudioPlayer(contentsOf:sound as URL)
            playerBGMGame?.numberOfLoops = -1
            playerBGMGame?.prepareToPlay()
            playerBGMGame?.volume = 0.2
            playerBGMGame?.numberOfLoops = -1
            playerBGMGame?.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
    
    func stopGame2BGM() {
        playerBGMGame?.stop()
    }
    
    func playSuccessBGM() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "success-page", ofType: "m4a")!)
        do {
            playerBGMSuccess = try AVAudioPlayer(contentsOf:sound as URL)
            playerBGMSuccess?.numberOfLoops = -1
            playerBGMSuccess?.prepareToPlay()
            playerBGMSuccess?.volume = 0.2
            playerBGMSuccess?.numberOfLoops = -1
            playerBGMSuccess?.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
    
    func stopSuccessBGM() {
        playerBGMSuccess?.stop()
    }
}
