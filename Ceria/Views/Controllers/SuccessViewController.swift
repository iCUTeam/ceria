//
//  SuccessViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit
import SwiftySound

class SuccessViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    let defaults = UserDefaults.standard
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: MakeButton = {
        let button = MakeButton(image: "next.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(toStory), for: .touchUpInside)
        return button
    }()
    
    private lazy var promptTextBox: SuccessView = {
        let prompt = SuccessView(content: "Rua:\nYay, kita berhasil sampai ke tuan puteri! Terimakasih ya untuk bantuannya, ini untuk kamu!")
        return prompt
    }()
    
    private lazy var dialogueTextBox: ExploreView = {
        let dialogue = ExploreView(content: "Cari kartu bergambar wajah Rua sebelum cerita usai untuk mengambil hadiah dari Rua ya.")
        return dialogue
    }()
    
    private lazy var hintButton: MakeButton = {
        let button = MakeButton(image: "kartu_rua", size: CGSize(width: 115, height: 150))
        button.addTarget(self, action: #selector(hintTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "rua_yay.png")
        backgroundImage.contentMode = .scaleToFill
        view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(homeButton)
        view.addSubview(nextButton)
        view.addSubview(promptTextBox)
        view.addSubview(hintButton)
        view.addSubview(dialogueTextBox)
        setUpAutoLayout()
        
        AudioBGMPlayer.shared.playSuccessBGM()
        Sound.stopAll()
        Sound.play(file: "rua_challenge_success.m4a")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.removeFromParent()
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc
    func homeTapped() {
        coordinator?.toLanding()
        AudioSFXPlayer.shared.playCommonSFX()
        AudioBGMPlayer.shared.stopSuccessBGM()
        Sound.stopAll()
    }
    
    @objc
    func hintTapped() {
        Sound.play(file: "explore3_collect_hint.m4a")
    }
    
    @objc
    func toStory() {
        Sound.stopAll()
        coordinator?.toStory()
        self.defaults.set("clear_challenge_1", forKey: "userState")
        AudioSFXPlayer.shared.playCommonSFX()
        AudioBGMPlayer.shared.stopSuccessBGM()
        Sound.play(file: "explore3_collect_hint.m4a")
        sleep(6)
    }
    
    func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            promptTextBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            promptTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hintButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            hintButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            dialogueTextBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -170),
            dialogueTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 95),
            dialogueTextBox.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24),
        ])
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
