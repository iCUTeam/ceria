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
    
    private lazy var restartButton: MakeButton = {
        let button = MakeButton(image: "restart.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
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
    
    private lazy var confirmRestartButton: MakeButton = {
        let button = MakeButton(image: "restartconfirm.png", size: CGSize(width: 267, height: 76.35))
        button.addTarget(self, action: #selector(restartProgress), for: .touchUpInside)
        return button
    }()
    
    private lazy var storyTextBox: StoryView = {
        let dialogue = StoryView(content: "Pada suatu ketika di sebuah kerajaan di Sulawesi Selatan, hiduplah seorang saudagar yang kaya dengan keempat orang anaknya.")
        return dialogue
    }()
    
    private lazy var restartConfirmTextBox: RestartConfirmationView = {
        let tutorial = RestartConfirmationView(content: "Jika menekan tombol di bawah ini, kamu bisa kembali lagi ke awal cerita. Apa kamu yakin ingin melakukannya?")
        return tutorial
    }()
    
    private lazy var confirmationLayer: UIView = {
        let frame = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        frame.backgroundColor = .black
        frame.alpha = 0.9
        return frame
    }()
    
    private lazy var closeButton: MakeButton =
    {
        let button = MakeButton(image: "x.png", size: CGSize(width: 50, height: 50))
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel = StoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backgroundImage.contentMode = .scaleToFill
        view.insertSubview(backgroundImage, at: 0)
        view.addSubview(homeButton)
        view.addSubview(restartButton)
        view.addSubview(nextButton)
        view.addSubview(actionButton)
        view.addSubview(previousButton)
        view.addSubview(storyTextBox)
        view.addSubview(confirmationLayer)
        view.addSubview(restartConfirmTextBox)
        view.addSubview(confirmRestartButton)
        view.addSubview(closeButton)
        setUpAutoLayout()
        
        setupBinders()
        
        viewModel.loadStory()
        
        Sound.stopAll()
        checkVoiceChange()
        voicePlayer.play()
        checkBGMChange()
        checkTextHeightChange()
        currentBGM = storyMusic
        disablingNextButton()
        disablingActionButton()
        confirmationLayer.isHidden = true
        restartConfirmTextBox.isHidden = true
        confirmRestartButton.isHidden = true
        closeButton.isHidden = true
        
        enableRestart()
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
    func restartTapped() {
        confirmationLayer.isHidden.toggle()
        restartConfirmTextBox.isHidden.toggle()
        confirmRestartButton.isHidden.toggle()
        closeButton.isHidden.toggle()
        AudioSFXPlayer.shared.playCommonSFX()
        voicePlayer.pause()
    }
    
    @objc
    func closeTapped() {
        confirmationLayer.isHidden.toggle()
        restartConfirmTextBox.isHidden.toggle()
        confirmRestartButton.isHidden.toggle()
        closeButton.isHidden.toggle()
        AudioSFXPlayer.shared.playBackSFX()
        voicePlayer.resume()
    }
    
    @objc
    func restartProgress() {
        voicePlayer.stop()
        AudioBGMPlayer.shared.stopStoryBGM()
        AudioSFXPlayer.shared.playCommonSFX()
        restartStory()
        sleep(1)
        coordinator?.toStory()
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
            sleep(6)
        case "explore2.png":
            saveAndNextIndex()
            defaults.set("clear_story_3", forKey: "userState")
            coordinator?.toExplore()
            sleep(3)
        case "power2.png":
            saveAndNextIndex()
            defaults.set("clear_story_4", forKey: "userState")
            coordinator?.toPower()
            sleep(4)
        case "explore3.png":
            saveAndNextIndex()
            defaults.set("clear_story_5", forKey: "userState")
            coordinator?.toExplore()
            sleep(4)
        case "power3.png":
            saveAndNextIndex()
            defaults.set("clear_story_6", forKey: "userState")
            coordinator?.toPower()
            sleep(5)
        case "power4.png":
            saveAndNextIndex()
            defaults.set("clear_story_7", forKey: "userState")
            coordinator?.toPower()
            sleep(5)
        case "explore4.png":
            saveAndNextIndex()
            defaults.set("clear_story_8", forKey: "userState")
            coordinator?.toExplore()
            sleep(3)
        case "reflection.png":
            viewModel.saveIndex()
            defaults.set("cleared", forKey: "userState")
            coordinator?.toReflection()
            sleep(9)
        default:
            print("nowhere to go")
        }
        
    }
    
    func enableRestart() {
        if defaults.bool(forKey: "disableSkip") == true || defaults.string(forKey: "userState") == "not_started" {
            restartButton.isHidden = true
        } else {
            restartButton.isHidden = false
        }
    }
    
    func restartStory() {
        defaults.set("not_started", forKey: "userState")
        defaults.set(0, forKey: "promptIndex")
        defaults.set(0, forKey: "storyIndex")
        defaults.set(0, forKey: "powerIndex")
        defaults.set(0, forKey: "successIndex")
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
            case "brolefilmer-junglesneak":
                AudioBGMPlayer.shared.playStoryBGM1()
            case "geoffharvey-adventure":
                AudioBGMPlayer.shared.playStoryBGM2()
            case "geoffharvey-magic":
                AudioBGMPlayer.shared.playStoryBGM3()
            case "jackmichaelking-ocean":
                AudioBGMPlayer.shared.playStoryBGM4()
            case "lesfm-kingdom":
                AudioBGMPlayer.shared.playStoryBGM5()
            case "lexin-midnight":
                AudioBGMPlayer.shared.playStoryBGM6()
            case "musiclfiles-finalbattle":
                AudioBGMPlayer.shared.playStoryBGM7()
            case "musicunlimited-epic":
                AudioBGMPlayer.shared.playStoryBGM8()
            case "solbox-war":
                AudioBGMPlayer.shared.playStoryBGM10()
            case "vadim-journey":
                AudioBGMPlayer.shared.playStoryBGM11()
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
        
        switch screenWidth {
        case 744: //7.9 inch
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
        case 768: //8.3 inch
            switch storyTextLine1 {
            case 1:
                boxHeight = 60
            case 2:
                boxHeight = 100
            case 3:
                boxHeight = 110
            case 4:
                boxHeight = 150
            default:
                print("they are not this long!")
            }
        case 810: //10.2 inch
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
        case 820: //10.9 inch
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
        case 834: //10.5 & 11 inch
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
        default: //12.9 inch
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
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let constant: CGFloat
        
        switch screenWidth {
        case 744: //7.9 inch
            constant = 50
        case 768: //8.3 inch
            constant = 80
        case 810: //10.2 inch
            constant = 50
        case 820: //10.9 inch
            constant = 50
        case 834: //10.5 & 11 inch
            constant = 50
        default: //12.9 inch
            constant = -70
        }
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            restartButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            restartButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            previousButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            previousButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            confirmRestartButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant),
            confirmRestartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmRestartButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            storyTextBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            storyTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            restartConfirmTextBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 400),
            restartConfirmTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.topAnchor.constraint(equalTo: restartConfirmTextBox.topAnchor, constant: -20),
            closeButton.leftAnchor.constraint(equalTo: restartConfirmTextBox.rightAnchor, constant: -25)
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
