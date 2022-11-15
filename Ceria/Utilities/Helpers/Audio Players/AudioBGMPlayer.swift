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
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "abm-hutantropis", ofType: "m4a")!)
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
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "brolefilmer-junglesneak", ofType: "m4a")!)
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
    
    func playStoryBGM2() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "geoffharvey-adventure", ofType: "m4a")!)
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
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "geoffharvey-magic", ofType: "m4a")!)
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
    
    func playStoryBGM4() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "jackmichaelking-ocean", ofType: "m4a")!)
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
    
    func playStoryBGM5() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "lesfm-kingdom", ofType: "m4a")!)
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
    
    func playStoryBGM6() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "lexin-midnight", ofType: "m4a")!)
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
    
    func playStoryBGM7() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "musiclfiles-finalbattle", ofType: "m4a")!)
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
    
    func playStoryBGM8() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "musicunlimited-epic", ofType: "m4a")!)
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
    
    func playStoryBGM9() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "redproductions-sweet", ofType: "m4a")!)
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
    
    func playStoryBGM10() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "solbox-war", ofType: "m4a")!)
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
    
    func playStoryBGM11() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "vadim-journey", ofType: "m4a")!)
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
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "abm-jalanjalansore", ofType: "m4a")!)
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
    
    func stopGameBGM() {
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
