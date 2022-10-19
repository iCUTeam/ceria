//
//  TutorialViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit
import SwiftySound

class TutorialViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    var tutorialVoice = ""
    var tutorialMusic = ""
    var actionButtonSFX = ""
    var actionButtonType = ""
    var currentBGM = ""
    var currentIndex = 0
    let defaults = UserDefaults.standard
    
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
        Sound.play(file: tutorialVoice)
        checkBGMChange()
        currentBGM = tutorialMusic
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
            Sound.stopAll()
        }
    
    @objc
    func nextTapped() {
        
        Sound.stop(file: tutorialVoice)
        viewModel.nextIndex()
        checkBGMChange()
        AudioSFXPlayer.shared.playCommonSFX()
        checkActionButtonChange()
        Sound.play(file: tutorialVoice)
    }
    
    @objc
    func previousTapped() {
        
        Sound.stop(file: tutorialVoice)
        viewModel.previousIndex()
        checkBGMChange()
        AudioSFXPlayer.shared.playBackSFX()
        checkActionButtonChange()
        Sound.play(file: tutorialVoice)
    }
    
    @objc
    func startGameTapped() {
        Sound.stopAll()
        AudioBGMPlayer.shared.stopStoryBGM()
        Sound.play(file: actionButtonSFX)
        
        sleep(2)
        coordinator?.toGame2()
        
    }
    
    func checkBGMChange() {
        
        if currentBGM != tutorialMusic {
            
            currentBGM = tutorialMusic
            
            switch tutorialMusic {
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
            
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
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
