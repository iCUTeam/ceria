//
//  StoryViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit
import SwiftySound
import AVFoundation

class StoryViewController: UIViewController, AVAudioPlayerDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    var storyTextLine1 = 0
    var storyTextLine2 = 0
    var storyVoice = ""
    var storyMusic = ""
    var actionButtonSFX = ""
    var actionButtonType = ""
    var currentBGM = ""
    var currentIndex = 0
    let defaults = UserDefaults.standard
    var voicePlayer: AVAudioPlayer = AVAudioPlayer()
    
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
        let button = MakeButton(image: "explore2.png", size: CGSize(width: 267, height: 76.35))
        button.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousButton: MakeButton = {
        let button = MakeButton(image: "previous.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var storyTextBox: StoryView = {
        let dialogue = StoryView(content: "Pada suatu ketika di sebuah kerajaan di Sulawesi Selatan, hiduplah seorang saudagar yang kaya dengan keempat orang anaknya.")
        return dialogue
    }()
    
    private let viewModel = StoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backgroundImage.contentMode = .scaleToFill
        view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(homeButton)
        view.addSubview(nextButton)
        view.addSubview(actionButton)
        view.addSubview(previousButton)
        view.addSubview(storyTextBox)
        setUpAutoLayout()
        
        setupBinders()
        
        viewModel.loadStory()
        
        Sound.stopAll()
        checkVoiceChange()
        voicePlayer.play()
        checkBGMChange()
        currentBGM = storyMusic
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
        viewModel.storyDialogue.bind { [weak self] dialogue in
            self?.storyTextBox.dialogueLabel.text = dialogue
        }
        
        viewModel.storyTextLine1.bind { [weak self] line1 in
            self?.storyTextLine1 = line1
        }
        
        viewModel.storyTextLine2.bind { [weak self] line2 in
            self?.storyTextLine2 = line2
        }
        
        viewModel.storyImage.bind { [weak self] image in
            self?.backgroundImage.image = UIImage(named: image)
        }
        
        viewModel.storyMusic.bind { [weak self] music in
            self?.storyMusic = music
        }
        
        viewModel.storyVoice.bind { [weak self] voice in
            self?.storyVoice = voice
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
        voicePlayer.stop()
        AudioBGMPlayer.shared.stopStoryBGM()
    }
    
    @objc
    func nextTapped() {
        viewModel.nextIndex()
        checkBGMChange()
        checkTextHeightChange()
        AudioSFXPlayer.shared.playCommonSFX()
        checkActionButtonChange()
        checkVoiceChange()
        voicePlayer.play()
        disablingNextButton()
        disablingActionButton()
    }
    
    @objc
    func previousTapped() {
        viewModel.previousIndex()
        checkBGMChange()
        checkTextHeightChange()
        AudioSFXPlayer.shared.playBackSFX()
        checkActionButtonChange()
        checkVoiceChange()
        voicePlayer.play()
        disablingNextButton()
        disablingActionButton()
    }
    
    @objc
    func actionTapped() {
        voicePlayer.stop()
        AudioBGMPlayer.shared.stopStoryBGM()
        Sound.play(file: actionButtonSFX)
        
        switch actionButtonType {
        case "explore1.png":
            saveAndNextIndex()
            defaults.set("clear_story_1", forKey: "userState")
            coordinator?.toExplore()
            sleep(3)
        case "power1.png":
            saveAndNextIndex()
            defaults.set("clear_story_2", forKey: "userState")
            coordinator?.toPower()
            sleep(5)
        case "explore2.png":
            saveAndNextIndex()
            defaults.set("clear_story_3", forKey: "userState")
            coordinator?.toExplore()
            sleep(3)
        case "power2.png":
            saveAndNextIndex()
            defaults.set("clear_story_4", forKey: "userState")
            coordinator?.toPower()
            sleep(3)
        case "explore3.png":
            saveAndNextIndex()
            defaults.set("clear_story_5", forKey: "userState")
            coordinator?.toExplore()
            sleep(3)
        case "power3.png":
            saveAndNextIndex()
            defaults.set("clear_story_6", forKey: "userState")
            coordinator?.toPower()
            sleep(3)
        case "power4.png":
            saveAndNextIndex()
            defaults.set("clear_story_7", forKey: "userState")
            coordinator?.toPower()
            sleep(3)
        case "explore4.png":
            saveAndNextIndex()
            defaults.set("clear_story_8", forKey: "userState")
            coordinator?.toExplore()
            sleep(3)
        case "reflection.png":
            viewModel.saveIndex()
            defaults.set("cleared", forKey: "userState")
            coordinator?.toReflection()
            sleep(5)
        default:
            print("nowhere to go")
        }
        
    }
    
    func saveAndNextIndex() {
        viewModel.nextIndex()
        viewModel.saveIndex()
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
    
    func checkVoiceChange() {
        do{
            let audioName = storyVoice.components(separatedBy: ".")[0]
            let audioPath = Bundle.main.path(forResource: audioName, ofType: "m4a")
            voicePlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath!))
            voicePlayer.prepareToPlay()
            voicePlayer.delegate = self
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
    
    func checkBGMChange() {
        
        if currentBGM != storyMusic {
            
            currentBGM = storyMusic
            
            switch storyMusic {
            case "petualangan":
                AudioBGMPlayer.shared.playStoryBGM1()
            case "sedih":
                AudioBGMPlayer.shared.playStoryBGM2()
            case "laut":
                AudioBGMPlayer.shared.playStoryBGM3()
            default:
                print("nothing to play")
            }
            
        }
    }
    
    func checkActionButtonChange() {
        let customButtonImage = UIImage(named: actionButtonType)
        let newimage = customButtonImage?.resizedImage(size: CGSize(width: 267, height: 76.35))
        actionButton.setImage(newimage, for: .normal)
    }
    
    func checkTextHeightChange() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        var boxHeight: CGFloat = 0
        
        if screenWidth == 834.0 {
            switch storyTextLine1 {
            case 1:
                boxHeight = 60
            case 2:
                boxHeight = 100
            case 3:
                boxHeight = 120
            case 4:
                boxHeight = 160
            default:
                print("they are not this long!")
            }
        } else {
            switch storyTextLine2 {
            case 1:
                boxHeight = 60
            case 2:
                boxHeight = 100
            case 3:
                boxHeight = 130
            case 4:
                boxHeight = 180
            default:
                print("they are not this long!")
            }
        }
        
        storyTextBox.dialogueTextFrame.frame.size.height = boxHeight
        storyTextBox.dialogueTextFrame.roundCornerView(corners: .allCorners, radius: 25)
    }
    
    func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            previousButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            previousButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            storyTextBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            storyTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
