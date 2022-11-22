//
//  GameViewController.swift
//  Ceria
//
//  Created by Kevin Gosalim on 10/10/22.
//

import UIKit
import SceneKit
import RealityKit
import ARKit
import SwiftySound
import AVFoundation

class ExploreViewController: UIViewController, ARSCNViewDelegate, AVAudioPlayerDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet var arSCN: ARSCNView!
    @IBOutlet weak var bottomPrimaryConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSecondaryConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionViewPrimary: ClueExploration!
    @IBOutlet weak var instructionViewSecondary: ClueExploration!
    
    let defaults = UserDefaults.standard
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    //checkpoint
    private lazy var dialogueTextBox: ExploreView = {
        let dialogue = ExploreView(content: "Cari kartu dengan gambar pulau di sekitarmu untuk membantu kapal berlabuh ke pulau yang tepat.")
        return dialogue
    }()
    
    //collectibles
    private lazy var dialogueTextBox2: ExploreView = {
        let dialogue = ExploreView(content: "Cari kartu bergambar wajah Rua sebelum cerita usai untuk mengambil hadiah dari Rua ya.")
        return dialogue
    }()
    
    //checkpoint
    private lazy var hintButton: MakeButton = {
        let button = MakeButton(image: hintImage, size: CGSize(width: 115, height: 150))
        button.addTarget(self, action: #selector(hintTapped), for: .touchUpInside)
        return button
    }()
    
    //collectibles
    private lazy var hint2Button: MakeButton = {
        let button = MakeButton(image: hintImage2, size: CGSize(width: 115,  height: 150))
        button.addTarget(self, action: #selector(hint2Tapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var popupLayer: UIView = {
        let frame = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        frame.backgroundColor = .black
        frame.alpha = 0.7
        return frame
    }()
    
    private lazy var focusLayer: UIView = {
        let frame = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        frame.backgroundColor = .black
        frame.alpha = 0.7
        return frame
    }()
    
    weak var checkpointNode: SCNNode!
    
    weak var treasureNode: SCNNode!
    
    
    var hint: String = ""
    var hint2: String = ""
    var hintText: String = ""
    var hintText2: String = ""
    var hintImage: String = ""
    var hintImage2: String = ""
    var itemObtained: [Bool] = []
    var exploreVoicePlayer: AVAudioPlayer = AVAudioPlayer()
    var exploreVoice = ""
    var isCheckpointFound = false
    var isTreasureFound = false
    
    private let collectionViewModel = CollectionViewModel()
    private let explorationModel = ExploreViewModel()
    
    private var collectionItem: CollectionItem!
    
    private lazy var closeButton: MakeButton =
    {
        let button = MakeButton(image: "x.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let x: CGFloat
        let y: CGFloat
        
        switch screenWidth {
        case 744: //7.9 inch
            x = 25
            y = 150
        case 768: //8.3 inch
            x = 30
            y = 80
        case 810: //10.2 inch
            x = 55
            y = 130
        case 820: //10.9 inch
            x = 60
            y = 150
        case 834: //10.5 & 11 inch
            x = 65
            y = 150
        default: //12.9 inch
            x = 160
            y = 200
        }
        
        view.addSubview(homeButton)
        view.addSubview(hint2Button)
        view.addSubview(dialogueTextBox2)
        view.addSubview(focusLayer)
        
        view.addSubview(hintButton)
        view.addSubview(dialogueTextBox)
        
        
        view.addSubview(popupLayer)
        collectionItem = CollectionItem(frame: CGRect(x: x, y: y, width: 700, height: 1000))
        collectionItem.roundCornerView(corners: .allCorners, radius: 30)
        view.addSubview(collectionItem)
        view.addSubview(closeButton)
        
        collectionItem.isHidden = true
        closeButton.isHidden = true
        popupLayer.isHidden = true
        focusLayer.isHidden = true
        setUpAutoLayout()
        
        // Set the view's delegate
        arSCN.delegate = self
        
        // Show statistics such as fps and timing information
        arSCN.showsStatistics = false
        
        arSCN.autoenablesDefaultLighting = true
        
        hint2Button.isHidden = true
        dialogueTextBox2.isHidden = true
        
        //set primary clue data
        //        instructionViewPrimary.clueDescription.text = getDescClue(clueCode: 1)
        //        instructionViewPrimary.clueGreyBackView.layer.cornerRadius = 20
        //        instructionViewPrimary.clueImage.image = UIImage(named: "red-card")
        
        //set second clue data
        //        instructionViewSecondary.clueDescription.text = getDescClue(clueCode: 2)
        //        instructionViewSecondary.clueGreyBackView.layer.cornerRadius = 20
        //        instructionViewSecondary.clueImage.image = UIImage(named: "blue-card")
        
        
        if defaults.array(forKey: "collectiblesObtainedStatus") == nil
        {
            collectionViewModel.initializeCollection()
        }
        
        if defaults.string(forKey: "userState") != "clear_story_1"
        {
            collectionViewModel.collectibleHint.bind { voice in
                self.hint2 = voice
            }
            
            collectionViewModel.collectibleHintString.bind { hintString in
                self.dialogueTextBox2.dialogueLabel.text = hintString
            }
            
            collectionViewModel.collectibleButton.bind { cardButton in
                let customButtonImage2 = UIImage(named:  cardButton)
                let newimage2 = customButtonImage2?.resizedImage(size: CGSize(width: 115, height: 150))
                self.hint2Button.setImage(newimage2, for: .normal)
            }
            
            hint2Button.isHidden = false
            dialogueTextBox2.isHidden = false
        }
        
        Sound.stopAll()
        itemObtained = defaults.array(forKey: "collectiblesObtainedStatus") as? [Bool] ?? [Bool]()
        
        switch(defaults.string(forKey: "userState"))
        {
            //MARK: ganti aja klo user statenya beda ternyata
        case "clear_story_1":
            explorationModel.setCurrentName(name: "checkpoint_istana")
            explorationModel.changeInteractionPerm()
            exploreVoice = "explore1-intro.m4a"
        case "clear_story_3":
            explorationModel.setCurrentName(name: "checkpoint_pulau")
            explorationModel.changeInteractionPerm()
            collectionViewModel.getCollection(card: "Seraung")
            if defaults.bool(forKey: "itemIsObtained") == false {
                exploreVoice = "explore2-intro.m4a"
            }
        case "clear_story_5":
            explorationModel.setCurrentName(name: "checkpoint_kapal")
            explorationModel.changeInteractionPerm()
            collectionViewModel.getCollection(card: "Tarumpah")
            if defaults.bool(forKey: "itemIsObtained") == false {
                exploreVoice = "explore3-intro.m4a"
            }
        default:
            explorationModel.setCurrentName(name: "checkpoint_dermaga")
            explorationModel.changeInteractionPerm()
            updateCollectionObjective()
            if defaults.bool(forKey: "itemIsObtained") == false {
                exploreVoice = "explore4-intro.m4a"
            }
        }
        
        explorationModel.getExploring()
        
        explorationModel.hintVoice.bind { voice in
            self.hint = voice
        }
        
        explorationModel.hintString.bind { hintString in
            self.dialogueTextBox.dialogueLabel.text = hintString
        }
        
        explorationModel.cardButton.bind { cardButton in
            let customButtonImage = UIImage(named: cardButton)
            let newimage = customButtonImage?.resizedImage(size: CGSize(width: 115, height: 150))
            self.hintButton.setImage(newimage, for: .normal)
        }
        
        disablingInteraction()
        checkObtained()
        
        if defaults.bool(forKey: "itemIsObtained") == false {
            checkVoiceChange()
            exploreVoicePlayer.play()
        } else {
            focusLayer.isHidden = true
            hintButton.isUserInteractionEnabled = true
            hint2Button.isUserInteractionEnabled = true
        }
    }
    
    //MARK: TEMPORARY FOR CODE TESTING
    @IBAction func showedPressed(_ sender: Any) {
        UIView.animate(withDuration: 1) {
            //constraint play
            self.bottomPrimaryConstraint.constant = 10
            self.bottomSecondaryConstraint.constant = 150
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: TEMPORARY FOR CODE TESTING
    @IBAction func hiddenPressed(_ sender: Any) {
        UIView.animate(withDuration: 1) {
            //constraint play
            self.bottomPrimaryConstraint.constant = -500
            self.bottomSecondaryConstraint.constant = -350
            //self.instructionViewPrimary.clueDescription.text = "Done"
            self.view.layoutIfNeeded()
        }
        coordinator?.toStory()
        if defaults.string(forKey: "userState") == "clear_story_1" {
            defaults.set("clear_explore_1", forKey: "userState")
        } else {
            defaults.set("clear_explore_2", forKey: "userState")
        }
        sleep(3)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Guideline Cards", bundle: Bundle.main)
            
        {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Image Succesfully Added")
        }
        
        arSCN.session.run(configuration)
        print("configuration ran")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        arSCN.session.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.removeFromParent()
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        DispatchQueue.main.async
        {
            if let imageAnchor = anchor as? ARImageAnchor
            {
                
                
                self.explorationModel.cardName.bind { [weak self] card in
                    
                    if imageAnchor.referenceImage.name == card
                    {
                        
                        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                        
                        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
                        
                        let planeNode = SCNNode(geometry: plane)
                        
                        planeNode.eulerAngles.x = -.pi / 2
                        
                        node.addChildNode(planeNode)
                        
                        self?.explorationModel.cardModel.bind { [weak self] model in
                            
                            if let checkPointScene = SCNScene(named: "Models.scnassets/Explore/\(model)")
                            {
                                
                                if let checkPoint = checkPointScene.rootNode.childNodes.first {
                                    
                                    self?.checkpointNode = checkPoint
                                    
                                    checkPoint.eulerAngles.x = .pi / 2
                                    
                                    checkPoint.eulerAngles.z = -.pi / 2
                                    
                                    checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)
                                    
                                    planeNode.addChildNode(checkPoint)
                                    
                                    self?.explorationModel.canInteract.bind { canInteract in
                                        if canInteract
                                        {
                                            Sound.stopAll()
                                            Sound.play(file: "checkpoint_found.wav")
                                            self?.exploreVoice = self?.explorationModel.foundVoice.value ?? ""
                                            self?.checkVoiceChange()
                                            self?.exploreVoicePlayer.play()
                                            if self?.defaults.bool(forKey: "disableSkip") == true {
                                                self?.view.isUserInteractionEnabled = false
                                            }
                                            self?.isCheckpointFound = true
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
                
                self.collectionViewModel.collectibleCard.bind { card in
                    
                    if imageAnchor.referenceImage.name == card
                    {
                        
                        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                        
                        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
                        
                        let planeNode = SCNNode(geometry: plane)
                        
                        planeNode.eulerAngles.x = -.pi / 2
                        
                        node.addChildNode(planeNode)
                        
                        self.collectionViewModel.isObtained.bind { obtained in
                            if obtained
                            {
                                if let checkPointScene = SCNScene(named: "Models.scnassets/Explore/chest_open.scn")
                                {
                                    if let checkPoint = checkPointScene.rootNode.childNodes.first {
                                        
                                        self.treasureNode = checkPoint
                                        
                                        checkPoint.eulerAngles.x = .pi / 2
                                        
                                        checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)
                                        
                                        planeNode.addChildNode(checkPoint)
                                        
                                    }
                                }
                            }
                            
                            else
                            
                            {
                                if let checkPointScene = SCNScene(named: "Models.scnassets/Explore/chest_new.scn")
                                {
                                    
                                    if let checkPoint = checkPointScene.rootNode.childNodes.first {
                                        
                                        self.treasureNode = checkPoint
                                        
                                        checkPoint.eulerAngles.x = .pi / 2
                                        
                                        checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)
                                        
                                        planeNode.addChildNode(checkPoint)
                                        
                                        Sound.stopAll()
                                        Sound.play(file: "checkpoint_found.wav")
                                        self.exploreVoice = "explore_collect_found.m4a"
                                        self.checkVoiceChange()
                                        self.exploreVoicePlayer.play()
                                        if self.defaults.bool(forKey: "disableSkip") == true {
                                            self.view.isUserInteractionEnabled = false
                                        }
                                        self.isTreasureFound = true
                                    }
                                }
                            }
                        }
                        
                        
                        
                    }
                }
                
            }
        }
        
        return node
    }
    
    @objc
    func homeTapped() {
        coordinator?.toLanding()
        AudioSFXPlayer.shared.playCommonSFX()
        Sound.stopAll()
        exploreVoicePlayer.stop()
        defaults.set(false, forKey: "itemIsObtained")
    }
    
    @objc func closeTapped()
    {
        Sound.stopAll()
        collectionItem.isHidden = true
        closeButton.isHidden = true
        popupLayer.isHidden = true
        hintButton.isHidden.toggle()
        dialogueTextBox.isHidden.toggle()
        AudioSFXPlayer.shared.playBackSFX()
        coordinator?.toExplore()
        defaults.set(true, forKey: "itemIsObtained")
    }
    
    @objc
    func hintTapped() {
        if isCheckpointFound == false {
            Sound.stopAll()
            exploreVoicePlayer.stop()
            Sound.play(file: hint)
        } else {
            Sound.play(file: "")
        }
    }
    
    @objc
    func hint2Tapped() {
        if isTreasureFound == false {
            Sound.stopAll()
            exploreVoicePlayer.stop()
            Sound.play(file: hint2)
        } else {
            Sound.play(file: "")
        }
    }
    
    
    func setUpAutoLayout() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let constant: CGFloat
        let constant2: CGFloat
        
        switch screenWidth {
        case 744: //7.9 inch
            constant = 100
            constant2 = 645
        case 768: //8.3 inch
            constant = 30
            constant2 = 670
        case 810: //10.2 inch
            constant = 90
            constant2 = 700
        case 820: //10.9 inch
            constant = 100
            constant2 = 700
        case 834: //10.5 & 11 inch
            constant = 100
            constant2 = 700
        default: //12.9 inch
            constant = 150
            constant2 = 800
        }
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: constant),
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant2),
            
            hint2Button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -190),
            hint2Button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            hintButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            hintButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            dialogueTextBox2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -340),
            dialogueTextBox2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 95),
            dialogueTextBox2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24),
            
            dialogueTextBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -170),
            dialogueTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 95),
            dialogueTextBox.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24),
        ])
    }
    
    func checkVoiceChange() {
        do{
            let audioName = exploreVoice.components(separatedBy: ".")[0]
            let audioPath = Bundle.main.path(forResource: audioName, ofType: "m4a")
            exploreVoicePlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath!))
            exploreVoicePlayer.prepareToPlay()
            exploreVoicePlayer.delegate = self
        }
        catch{
            print(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true && defaults.bool(forKey: "disableSkip") == true {
            focusLayer.isHidden = true
            hintButton.isUserInteractionEnabled = true
            hint2Button.isUserInteractionEnabled = true
            view.isUserInteractionEnabled = true
        }
    }
    
    func disablingInteraction() {
        if defaults.bool(forKey: "disableSkip") == true {
            focusLayer.isHidden = false
            hintButton.isUserInteractionEnabled = false
            hint2Button.isUserInteractionEnabled = false
        }
    }
    
    func checkObtained() {
        collectionViewModel.isObtained.bind { obtained in
            if obtained
            {
                self.hint2Button.isHidden = true
                self.dialogueTextBox2.isHidden = true
            }
        }
    }
    
    func updateCollectionObjective() {
        
        if itemObtained[2] == true {
            collectionViewModel.getCollection(card: "Lontong Sayur")
        } else {
            collectionViewModel.getCollection(card: "Tinim dan Ando")
        }
    }
    
    private func setupPopUP()
    {
        popupLayer.isHidden = false
        collectionItem.isHidden = false
        closeButton.isHidden = false
        
        collectionViewModel.collectibleName.bind { [weak self] name in
            self?.collectionItem.itemName.text = name
        }
        
        collectionViewModel.collectibleOrigin.bind { [weak self] origin in
            self?.collectionItem.itemOrigin.text = origin
        }
        
        collectionViewModel.collectibleDesc.bind { [weak self] desc in
            self?.collectionItem.itemDesc.text = "Asik! Kamu menemukan harta karun!\nKamu bisa menemukan benda ini di ruang koleksimu, ya!"
            self?.collectionItem.itemDesc.allowsEditingTextAttributes = false
        }
        
        collectionViewModel.collectibleItem.bind { [weak self] item in
            self?.collectionItem.setSCNView(scn: "Models.scnassets/Collection/\(item)")
        }
        
        hintButton.isHidden.toggle()
        hint2Button.isHidden = true
        dialogueTextBox.isHidden.toggle()
        dialogueTextBox2.isHidden = true
        Sound.play(file: collectionViewModel.collectibleSFX.value)
        collectionViewModel.obtainItem()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        
        if (touch.view == self.arSCN)
        {
            let viewTouchLocation:CGPoint = touch.location(in: arSCN)
            guard let result = arSCN.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            
            //checkpoint
            if let planeNode = checkpointNode, planeNode == result.node {
                Sound.stopAll()
                exploreVoicePlayer.stop()
                Sound.play(file: "checkpoint_clicked.wav")
                sleep(2)
                coordinator?.toStory()
                defaults.set(false, forKey: "itemIsObtained")
                explorationModel.nextState.bind { next in
                    self.defaults.set(next, forKey: "userState")
                }
            }
            
            //collection
            if let planeNode = treasureNode, planeNode == result.node {
                //                let animation = animationFromSceneNamed(path: "Models.scnassets/Explore/chest_animated.scn")
                //                planeNode.addAnimation(animation!, forKey: "anim")
                collectionViewModel.isObtained.bind { obtained in
                    if !obtained
                    {
                        Sound.stopAll()
                        self.exploreVoicePlayer.stop()
                        Sound.play(file: "checkpoint_clicked.wav")
                        self.setupPopUP()
                    }
                }
                
            }
        }
    }
}
