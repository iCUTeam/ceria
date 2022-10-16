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
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "laut", ofType: "wav")!)
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
}
