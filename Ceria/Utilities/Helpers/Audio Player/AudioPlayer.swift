//
//  AudioPlayer.swift
//  Ceria
//
//  Created by Kevin Gosalim on 15/10/22.
//

import Foundation
import AVFoundation

class AudioPlayer {

    static let shared = AudioPlayer()
    var player: AVAudioPlayer?
    
    private init() {}
    
    func play(url: URL) {
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch {
            print("error occurred")
        }
    }
}
