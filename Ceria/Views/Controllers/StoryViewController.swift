//
//  StoryViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit
import SwiftySound

class StoryViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var dialogueLabel: UILabel!
    
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    var storyVoice = ""
    var storyMusic = ""
    var actionButtonSFX = ""
    var actionButtonType = ""
    var currentBGM = ""
    var currentIndex = 0
    
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
        setUpAutoLayout()
        
        setupBinders()
        
        viewModel.loadStory()
        Sound.play(file: storyVoice)
        checkBGMChange()
        currentBGM = storyMusic
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupBinders() {
        viewModel.storyDialogue.bind { [weak self] dialogue in
            self?.dialogueLabel.text = dialogue
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
        Sound.stopAll()
        AudioBGMPlayer.shared.stopStoryBGM()
    }
    
    @objc
    func nextTapped() {
        
        Sound.stop(file: storyVoice)
        viewModel.nextIndex()
        checkBGMChange()
        AudioSFXPlayer.shared.playCommonSFX()
        checkActionButtonChange()
        Sound.play(file: storyVoice)
    }
    
    @objc
    func previousTapped() {
        
        Sound.stop(file: storyVoice)
        viewModel.previousIndex()
        checkBGMChange()
        AudioSFXPlayer.shared.playBackSFX()
        checkActionButtonChange()
        Sound.play(file: storyVoice)
    }
    
    @objc
    func actionTapped() {
        Sound.stopAll()
        AudioBGMPlayer.shared.stopStoryBGM()
        Sound.play(file: actionButtonSFX)
        
        switch actionButtonType {
        case "explore2.png":
            coordinator?.toExplore()
            sleep(3)
        case "explore3.png":
            coordinator?.toExplore()
            sleep(3)
        case "power2.png":
            coordinator?.toPower()
        case "game2.png":
            coordinator?.toTutorial()
        case "reflection.png":
            coordinator?.toReflection()
        default:
            print("nowhere to go")
        }
        
        viewModel.nextIndex()
        viewModel.saveIndex()
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
