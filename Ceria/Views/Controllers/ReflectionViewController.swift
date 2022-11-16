//
//  ReflectionViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit
import SwiftySound
import AVFoundation

class ReflectionViewController: UIViewController, AVAudioPlayerDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    var promptTextLine1 = 0
    var promptTextLine2 = 0
    var promptVoice = ""
    var promptMusic = ""
    var actionButtonSFX = ""
    var actionButtonType = ""
    var currentBGM = ""
    var currentIndex = 0
    let defaults = UserDefaults.standard
    var promptPlayer: AVAudioPlayer = AVAudioPlayer()
    
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
        let button = MakeButton(image: "retry.png", size: CGSize(width: 267, height: 76.35))
        button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousButton: MakeButton = {
        let button = MakeButton(image: "previous.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var promptTextBox: ReflectionView = {
        let prompt = ReflectionView(content: "Lompo:\nKami semua belajar dengan giat dan tekun sampai bisa memiliki keahlian masing-masing loh.")
        return prompt
    }()
    
    private let viewModel = ReflectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        defaults.set(0, forKey: "promptIndex")
        
        backgroundImage.contentMode = .scaleToFill
        view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(homeButton)
        view.addSubview(nextButton)
        view.addSubview(actionButton)
        view.addSubview(previousButton)
        view.addSubview(promptTextBox)
        setUpAutoLayout()
        
        setupBinders()
        
        viewModel.getPrompt()
        
        Sound.stopAll()
        checkVoiceChange()
        promptPlayer.play()
        checkBGMChange()
        checkTextHeightChange()
        currentBGM = promptMusic
        disablingNextButton()
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
        viewModel.promptDialogue.bind { [weak self] prompt in
            self?.promptTextBox.promptLabel.text = prompt
        }
        
        viewModel.promptTextLine1.bind { [weak self] line1 in
            self?.promptTextLine1 = line1
        }
        
        viewModel.promptTextLine2.bind { [weak self] line2 in
            self?.promptTextLine2 = line2
        }
        
        viewModel.promptImage.bind { [weak self] image in
            self?.backgroundImage.image = UIImage(named: image)
        }
        
        viewModel.promptMusic.bind { [weak self] music in
            self?.promptMusic = music
        }
        
        viewModel.promptVoice.bind { [weak self] voice in
            self?.promptVoice = voice
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
        Sound.stopAll()
        defaults.set(0, forKey: "promptIndex")
    }
    
    @objc
    func nextTapped() {
        viewModel.nextIndex()
        checkBGMChange()
        checkTextHeightChange()
        AudioSFXPlayer.shared.playCommonSFX()
        checkActionButtonChange()
        checkVoiceChange()
        promptPlayer.play()
        disablingNextButton()
    }
    
    @objc
    func previousTapped() {
        viewModel.previousIndex()
        checkBGMChange()
        checkTextHeightChange()
        AudioSFXPlayer.shared.playBackSFX()
        checkActionButtonChange()
        checkVoiceChange()
        promptPlayer.play()
        disablingNextButton()
    }
    
    @objc
    func retryTapped() {
        promptPlayer.stop()
        AudioBGMPlayer.shared.stopStoryBGM()
        Sound.play(file: actionButtonSFX)
        resetProgress()
        sleep(5)
        coordinator?.toStory()
        
    }
    
    func resetProgress() {
        defaults.set("not_started", forKey: "userState")
        defaults.set(0, forKey: "promptIndex")
        defaults.set(0, forKey: "storyIndex")
        defaults.set(0, forKey: "powerIndex")
        defaults.set(0, forKey: "successIndex")
    }
    
    func disablingNextButton() {
        if defaults.bool(forKey: "disableSkip") == true {
            nextButton.isEnabled = false
        }
    }
    
    func checkVoiceChange() {
        do{
            let audioName = promptVoice.components(separatedBy: ".")[0]
            let audioPath = Bundle.main.path(forResource: audioName, ofType: "m4a")
            promptPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath!))
            promptPlayer.prepareToPlay()
            promptPlayer.delegate = self
        }
        catch{
            print(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if flag == true && defaults.bool(forKey: "disableSkip") == true {
            nextButton.isEnabled.toggle()
        }
    }
    
    func checkBGMChange() {
        
        if currentBGM != promptMusic {
            
            currentBGM = promptMusic
            
            switch promptMusic {
            case "redproductions-sweet":
                AudioBGMPlayer.shared.playStoryBGM9()
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
            switch promptTextLine1 {
            case 1:
                boxHeight = 60
            case 2:
                boxHeight = 100
            case 3:
                boxHeight = 125
            case 4:
                boxHeight = 150
            default:
                print("they are not this long!")
            }
        } else {
            switch promptTextLine2 {
            case 1:
                boxHeight = 60
            case 2:
                boxHeight = 100
            case 3:
                boxHeight = 125
            case 4:
                boxHeight = 170
            default:
                print("they are not this long!")
            }
        }
        
        promptTextBox.promptTextFrame.frame.size.height = boxHeight
        promptTextBox.promptTextFrame.roundCornerView(corners: .allCorners, radius: 25)
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
            
            promptTextBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            promptTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
