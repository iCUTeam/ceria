//
//  SuccessViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit
import SwiftySound
import AVFoundation

class SuccessViewController: UIViewController, AVAudioPlayerDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    private let viewModel = SuccessViewModel()
    private let powerViewModel = PowerViewModel()
    
    let defaults = UserDefaults.standard
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    var successText1 = ""
    var successText2 = ""
    var successText = ""
    var successVoice1 = ""
    var successVoice2 = ""
    var successVoice = ""
    var successCardImage = ""
    var successCardVoice = ""
    var nextVoice = ""
    var currentIndex = 0
    var currentIndex2 = 0
    var sfxPlayer: AVAudioPlayer = AVAudioPlayer()
    var obtainedStatus: [Bool] = []
    
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
        
        backgroundImage.contentMode = .scaleToFill
        view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(homeButton)
        view.addSubview(nextButton)
        view.addSubview(promptTextBox)
        view.addSubview(hintButton)
        view.addSubview(dialogueTextBox)
        setUpAutoLayout()
        
        setupBinders()
        
        viewModel.loadSuccess()
        powerViewModel.loadPower()
        
        Sound.stopAll()
        obtainedStatus = defaults.array(forKey: "collectiblesObtainedStatus") as? [Bool] ?? [Bool]()
        checkObtainedItem()
        initialButtonChange()
        applyDialogueChange()
        playSuccessVoice()
        disablingNextButton()
        
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
    
    private func setupBinders() {
        viewModel.successText1.bind { [weak self] text in
            self?.successText1 = text
        }
        
        viewModel.successText2.bind { [weak self] text in
            self?.successText2 = text
        }
        
        viewModel.successVoice1.bind { [weak self] voice in
            self?.successVoice1 = voice
        }
        
        viewModel.successVoice2.bind { [weak self] voice in
            self?.successVoice2 = voice
        }
        
        viewModel.successCardImage.bind { [weak self] image in
            self?.successCardImage = image
        }
        
        viewModel.successCardText.bind { [weak self] text in
            self?.dialogueTextBox.titleLabel.text = "Petunjuk:"
            self?.dialogueTextBox.dialogueLabel.text = text
        }
        
        viewModel.successCardVoice.bind { [weak self] voice in
            self?.successCardVoice = voice
        }
        
        viewModel.successBackground.bind { [weak self] image in
            self?.backgroundImage.image = UIImage(named: image)
        }
        
        viewModel.currentIndex.bind { [weak self] index in
            self?.currentIndex = index
        }
        
        powerViewModel.currentIndex.bind { [weak self] index in
            self?.currentIndex2 = index
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
    func hintTapped() {
        Sound.stopAll()
        Sound.play(file: "")
    }
    
    @objc
    func nextTapped() {
        
        Sound.stopAll()
        sfxPlayer.stop()
        coordinator?.toStory()
        Sound.play(file: nextVoice)
        switch defaults.integer(forKey: "successIndex") {
        case 0:
            saveAndNextIndex()
            defaults.set("clear_power_1", forKey: "userState")
        case 1:
            saveAndNextIndex()
            defaults.set("clear_power_2", forKey: "userState")
        case 2:
            saveAndNextIndex()
            defaults.set("clear_power_3", forKey: "userState")
        default:
            viewModel.saveIndex()
            defaults.set(currentIndex2, forKey: "powerIndex")
            defaults.set("clear_power_4", forKey: "userState")
        }
        
        AudioSFXPlayer.shared.playCommonSFX()
        AudioBGMPlayer.shared.stopStoryBGM()
        
        sleep(6)
    }
    
    func checkObtainedItem() {
        if obtainedStatus[currentIndex] == false {
            successText = successText1
            successVoice = successVoice1
            hintButton.isHidden = false
            dialogueTextBox.isHidden = false
            nextVoice = successCardVoice
        } else {
            successText = successText2
            successVoice = successVoice2
            hintButton.isHidden = true
            dialogueTextBox.isHidden = true
            nextVoice = ""
        }
    }
    
    func saveAndNextIndex() {
        viewModel.nextIndex()
        viewModel.saveIndex()
        nextIndex()
        defaults.set(currentIndex2, forKey: "powerIndex")
    }
    
    func nextIndex() {
        if currentIndex2 == powerViewModel.powerArray.count-1 {
            currentIndex2 = 0
        } else {
            currentIndex2 += 1
        }
        
        powerViewModel.getPower()
    }
    
    func applyDialogueChange() {
        promptTextBox.promptLabel.text = successText
    }
    
    func initialButtonChange() {
        let customButtonImage = UIImage(named: successCardImage)
        let newimage = customButtonImage?.resizedImage(size: CGSize(width: 115, height: 150))
        hintButton.setImage(newimage, for: .normal)
        hintButton.contentMode = .scaleAspectFit
    }
    
    func disablingNextButton() {
        if defaults.bool(forKey: "disableSkip") == true {
            nextButton.isEnabled = false
        }
    }
    
    func playSuccessVoice() {
        do{
            let audioName = successVoice.components(separatedBy: ".")[0]
            let audioPath = Bundle.main.path(forResource: audioName, ofType: "m4a")
            sfxPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath!))
            sfxPlayer.prepareToPlay()
            sfxPlayer.delegate = self
            sfxPlayer.play()
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
