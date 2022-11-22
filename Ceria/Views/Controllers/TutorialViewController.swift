//
//  TutorialViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit
import SwiftySound
import AVFoundation

class TutorialViewController: UIViewController, AVAudioPlayerDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    var tutorialVoice = ""
    var tutorialMusic = ""
    var actionButtonSFX = ""
    var actionButtonType = ""
    var currentIndex = 0
    let defaults = UserDefaults.standard
    var tutorialVoicePlayer: AVAudioPlayer = AVAudioPlayer()
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: MakeButton = {
        let button = MakeButton(image: "next.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionButton: MakeButton = {
        let button = MakeButton(image: "startgame.png", size: CGSize(width: 267, height: 76.35))
        button.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousButton: MakeButton = {
        let button = MakeButton(image: "previous.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tutorialTextBox: TutorialView = {
        let tutorial = TutorialView(content: "Rua:\nGerakkan tabletmu ke kanan dan ke kiri untuk membantuku menghindari halangan di depan, agar dapat sampai ke tuan puteri.")
        return tutorial
    }()
    
    private let viewModel = TutorialViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backgroundImage.contentMode = .scaleToFill
        view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(homeButton)
        view.addSubview(nextButton)
        view.addSubview(actionButton)
        view.addSubview(previousButton)
        view.addSubview(tutorialTextBox)
        setUpAutoLayout()
        
        setupBinders()
        
        viewModel.getTutorial()
        Sound.stopAll()
        checkVoiceChange()
        tutorialVoicePlayer.play()
        disablingNextButton()
        disablingActionButton()
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
    
    private func setupBinders() {
        viewModel.tutorialDialogue.bind { [weak self] tutorial in
            self?.tutorialTextBox.tutorialLabel.text = tutorial
        }
        viewModel.tutorialImage.bind { [weak self] image in
            self?.backgroundImage.image = UIImage(named: image)
        }
        
        viewModel.tutorialMusic.bind { [weak self] music in
            self?.tutorialMusic = music
        }
        
        viewModel.tutorialVoice.bind { [weak self] voice in
            self?.tutorialVoice = voice
        }
        
        viewModel.isNextButtonHidden.bind { [weak self] toggle in
            self?.nextButton.isHidden = toggle
        }
        
        viewModel.isBackButtonHidden.bind { [weak self] toggle in
            self?.previousButton.isHidden = toggle
        }
        
        viewModel.isActionButtonHidden.bind { [weak self] toggle in
            self?.actionButton.isHidden = toggle
        }
        
        viewModel.actionButtonType.bind { [weak self] type in
            self?.actionButtonType = type
        }
        
        viewModel.actionButtonSFX.bind { [weak self] sfx in
            self?.actionButtonSFX = sfx
        }
        
        viewModel.currentIndex.bind { [weak self] index in
            self?.currentIndex = index
        }
    }
    
    @objc
    func homeTapped() {
        coordinator?.toLanding()
        AudioSFXPlayer.shared.playCommonSFX()
        AudioBGMPlayer.shared.stopStoryBGM()
        Sound.stopAll()
    }
    
    @objc
    func nextTapped() {
        
        Sound.stopAll()
        viewModel.nextIndex()
        AudioSFXPlayer.shared.playCommonSFX()
        checkActionButtonChange()
        checkVoiceChange()
        tutorialVoicePlayer.play()
        disablingNextButton()
        disablingActionButton()
    }
    
    @objc
    func previousTapped() {
        
        Sound.stopAll()
        viewModel.previousIndex()
        AudioSFXPlayer.shared.playBackSFX()
        checkActionButtonChange()
        checkVoiceChange()
        tutorialVoicePlayer.play()
        disablingNextButton()
        disablingActionButton()
    }
    
    @objc
    func startGameTapped() {
        Sound.stopAll()
        tutorialVoicePlayer.stop()
        AudioBGMPlayer.shared.stopStoryBGM()
        Sound.play(file: actionButtonSFX)
        
        sleep(2)
        coordinator?.toGame2()
        
    }
    
    func checkVoiceChange() {
        do{
            let audioName = tutorialVoice.components(separatedBy: ".")[0]
            let audioPath = Bundle.main.path(forResource: audioName, ofType: "m4a")
            tutorialVoicePlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath!))
            tutorialVoicePlayer.prepareToPlay()
            tutorialVoicePlayer.volume = 2.0
            tutorialVoicePlayer.delegate = self
        }
        catch{
            print(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag == true && defaults.bool(forKey: "disableSkip") == true {
            nextButton.isEnabled.toggle()
            actionButton.isEnabled.toggle()
        }
    }
    
    func disablingNextButton() {
        if defaults.bool(forKey: "disableSkip") == true {
            nextButton.isEnabled = false
        }
    }
    
    func disablingActionButton() {
        if defaults.bool(forKey: "disableSkip") == true {
            actionButton.isEnabled = false
        }
    }
    
    func checkActionButtonChange() {
        let customButtonImage = UIImage(named: actionButtonType)
        let newimage = customButtonImage?.resizedImage(size: CGSize(width: 267, height: 76.35))
        actionButton.setImage(newimage, for: .normal)
    }
    
    func setUpAutoLayout() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let constant: CGFloat
        
        switch screenWidth {
        case 744: //7.9 inch
            constant = 200
        case 768: //8.3 inch
            constant = 250
        case 810: //10.2 inch
            constant = 220
        case 820: //10.9 inch
            constant = 200
        case 834: //10.5 & 11 inch
            constant = 200
        default: //12.9 inch
            constant = 100
        }
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            previousButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            previousButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            tutorialTextBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            tutorialTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
