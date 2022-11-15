//
//  AudioSFXPlayer.swift
//  Ceria
//
//  Created by Kevin Gosalim on 16/10/22.
//

import Foundation
import AVFoundation

class AudioSFXPlayer {
    
    static let shared = AudioSFXPlayer()
    var playerCommonSFX: AVAudioPlayer?
    var playerBackSFX: AVAudioPlayer?
    
    func playCaritaSFX() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "carita", ofType: "m4a")!)
        do {
            playerCommonSFX = try AVAudioPlayer(contentsOf:sound as URL)
            playerCommonSFX?.prepareToPlay()
            playerCommonSFX?.volume = 3.0
            playerCommonSFX?.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
    
    func playCommonSFX() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "clicked", ofType: "wav")!)
        do {
            playerCommonSFX = try AVAudioPlayer(contentsOf:sound as URL)
            playerCommonSFX?.prepareToPlay()
            playerCommonSFX?.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
    
    func playBackSFX() {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "previous", ofType: "wav")!)
        do {
            playerBackSFX = try AVAudioPlayer(contentsOf:sound as URL)
            playerBackSFX?.prepareToPlay()
            playerBackSFX?.play()
        }
        catch {
            print("Cannot play the file")
        }
    }
}
