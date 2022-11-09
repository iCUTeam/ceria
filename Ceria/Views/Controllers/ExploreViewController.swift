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

class ExploreViewController: UIViewController, ARSCNViewDelegate, Storyboarded {
    
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
    
    
    var checkpointNode: SCNNode!
    
    var treasureNode: SCNNode!
    
    var hint: String = ""
    var hint2: String = ""
    var hintText: String = ""
    var hintText2: String = ""
    var hintImage: String = ""
    var hintImage2: String = ""
    
    
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
        let w: CGFloat
        let h: CGFloat
        
        if screenWidth == 834.0 {
            x = 65
            y = 150
            w = 700
            h = 1000
        } else {
            x = 160
            y = 200
            w = 700
            h = 1000
        }
    
        collectionItem = CollectionItem(frame: CGRect(x: x, y: y, width: w, height: h))
        collectionItem.roundCornerView(corners: .allCorners, radius: 30)
        view.addSubview(collectionItem)
        view.addSubview(homeButton)
        
        view.addSubview(hintButton)
        view.addSubview(hint2Button)
        view.addSubview(dialogueTextBox)
        view.addSubview(dialogueTextBox2)
        
        view.addSubview(closeButton)
        
        collectionItem.isHidden = true
        closeButton.isHidden = true
        
        setUpAutoLayout()
        
        // Set the view's delegate
        arSCN.delegate = self
        
        // Show statistics such as fps and timing information
        arSCN.showsStatistics = false
        
        arSCN.autoenablesDefaultLighting = true
        
        //set primary clue data
//        instructionViewPrimary.clueDescription.text = getDescClue(clueCode: 1)
//        instructionViewPrimary.clueGreyBackView.layer.cornerRadius = 20
//        instructionViewPrimary.clueImage.image = UIImage(named: "red-card")
        
        //set second clue data
//        instructionViewSecondary.clueDescription.text = getDescClue(clueCode: 2)
//        instructionViewSecondary.clueGreyBackView.layer.cornerRadius = 20
//        instructionViewSecondary.clueImage.image = UIImage(named: "blue-card")
        
        
        if defaults.string(forKey: "userState") == "clear_story_1" {
            Sound.play(file: "explore2-intro.m4a")
            
            hint = "explore2_hint.m4a"
            hint2 = ""
            
            dialogueTextBox.dialogueLabel.text = "Cari kartu dengan gambar pulau di sekitarmu untuk membantu kapal berlabuh ke pulau yang tepat."
            
            let customButtonImage = UIImage(named:  "kartu_pulau")
            let newimage = customButtonImage?.resizedImage(size: CGSize(width: 115, height: 150))
            hintButton.setImage(newimage, for: .normal)
            
            hint2Button.isHidden = true
            dialogueTextBox2.isHidden = true
            
        } else {
            Sound.play(file: "tallu_explore3.m4a")
            
            hint = "explore3_hint.m4a"
            hint2 = "explore3_collect_hint.m4a"
            
            dialogueTextBox.dialogueLabel.text = "Cari kartu dengan gambar kapal di sekitarmu untuk membantu Rua dan tuan puteri kembali ke kapal."
            dialogueTextBox2.dialogueLabel.text = "Cari kartu bergambar wajah Rua sebelum cerita usai untuk mengambil hadiah dari Rua ya."
            
            let customButtonImage = UIImage(named:  "kartu_kapal")
            let newimage = customButtonImage?.resizedImage(size: CGSize(width: 115, height: 150))
            hintButton.setImage(newimage, for: .normal)
            
            let customButtonImage2 = UIImage(named:  "kartu_rua")
            let newimage2 = customButtonImage2?.resizedImage(size: CGSize(width: 115, height: 150))
            hint2Button.setImage(newimage2, for: .normal)
            
            hint2Button.isHidden = false
            dialogueTextBox2.isHidden = false
        }
        
        if collectionViewModel.obtainedStatus.count == 0
        {
            collectionViewModel.initializeCollection()
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
            configuration.maximumNumberOfTrackedImages = 1
            
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
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        DispatchQueue.main.async
        {
            if let imageAnchor = anchor as? ARImageAnchor
            {
                
                
                if imageAnchor.referenceImage.name?.localizedStandardContains("checkpoint") == true{
                    
                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                    
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
                    
                    let planeNode = SCNNode(geometry: plane)
                    
                    planeNode.eulerAngles.x = -.pi / 2
                    
                    node.addChildNode(planeNode)
                    
                    explorationModel.currentName.value = imageAnchor.referenceImage.name ?? "checkpoint_istana"
                    
                    explorationModel.getExploring()
                    
                    if let checkPointScene = SCNScene(named: "Models.scnassets/\(explorationModel.cardName.value)") {

                        if let checkPoint = checkPointScene.rootNode.childNodes.first {
                            
                            self.checkpointNode = checkPoint

                            checkPoint.eulerAngles.x = .pi / 2
                            
                            checkPoint.eulerAngles.z = .pi / 2

                            checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)

                            planeNode.addChildNode(checkPoint)
                            
                                Sound.play(file: "checkpoint_found.wav")
                                Sound.play(file:"explore2_found.m4a")
                        
                        }
                    }
                }
                
                
                if imageAnchor.referenceImage.name == "kartu_rua2" && self.defaults.string(forKey: "userState") == "clear_story_4" {
                    
                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
    
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
    
                    let planeNode = SCNNode(geometry: plane)
    
                    planeNode.eulerAngles.x = -.pi / 2
    
                    
                
    
                    node.addChildNode(planeNode)
    
                    if let checkPointScene = SCNScene(named: "Models.scnassets/Treasure_chest.scn") {
    
                        if let checkPoint = checkPointScene.rootNode.childNodes.first {
                        
                            
                            checkPoint.eulerAngles.x = .pi / 2
                            
                            checkPoint.scale = SCNVector3(x: 3, y: 3, z: 3)
    
                            planeNode.addChildNode(checkPoint)
                            
                            if self.isCollectibleFound == true {
                                Sound.play(file: "checkpoint_found.wav")
                                Sound.play(file:"explore3_collect_found.m4a")
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
        }
    
    @objc func closeTapped()
    {
        collectionItem.isHidden = true
        closeButton.isHidden = true
        AudioSFXPlayer.shared.playBackSFX()
        hintButton.isHidden.toggle()
        dialogueTextBox.isHidden.toggle()
    }
    
    @objc
    func hintTapped() {
        Sound.play(file: hint)
    }
    
    @objc
    func hint2Tapped() {
        Sound.play(file: hint2)
    }
    
    
    func setUpAutoLayout() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let constant: CGFloat
        let constant2: CGFloat
        
        if screenWidth == 834.0 {
            constant = 100
            constant2 = 700
        } else {
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
    
    private func setupPopUP(index: Int)
    {
        
            collectionViewModel.getCollection(index: index)
        
            collectionItem.isHidden = false
            closeButton.isHidden = false
            
            collectionViewModel.collectibleName.bind { [weak self] name in
                self?.collectionItem.itemName.text = name
            }
            
            collectionViewModel.collectibleOrigin.bind { [weak self] origin in
                self?.collectionItem.itemOrigin.text = origin
            }
            
            collectionViewModel.collectibleDesc.bind { [weak self] desc in
                self?.collectionItem.itemDesc.text = "Asik! Kamu menemukan hadiah dari Rua!\nKamu bisa menemukan barang ini di rak koleksi kamu, ya!"
                self?.collectionItem.itemDesc.allowsEditingTextAttributes = false
            }
            
            collectionViewModel.collectibleItem.bind { [weak self] item in
                self?.collectionItem.setSCNView(scn: "Models.scnassets/\(item)")
            }
        
        hintButton.isHidden.toggle()
        hint2Button.isHidden = true
        dialogueTextBox.isHidden.toggle()
        dialogueTextBox2.isHidden = true
        
        collectionViewModel.obtainItem(index: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        
        if (touch.view == self.arSCN)
        {
            print("Is Touching")
            let viewTouchLocation:CGPoint = touch.location(in: arSCN)
            guard let result = arSCN.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            
            //pulau
            if let planeNode = blueCheckPointNode, planeNode == result.node {
                Sound.play(file: "checkpoint_clicked.wav")
                sleep(2)
                coordinator?.toStory()
                defaults.set("clear_explore_1", forKey: "userState")
                
                
            }
            
            //kapal
            if let planeNode = greenCheckPointNode, planeNode == result.node {
                Sound.play(file: "checkpoint_clicked.wav")
                sleep(2)
                coordinator?.toStory()
                defaults.set("clear_explore_2", forKey: "userState")
                
                
                
                
            }
            
            if let planeNode = redCheckPointNode, planeNode == result.node {
//                coordinator?.toStory()
//                defaults.set("clear_explore_3", forKey: "userState")
//                Sound.play(file: "checkpoint_found.m4a")
            }
            
            if let planeNode = seraungNode, planeNode == result.node {
                collectionViewModel.obtainItem(index: 0)
                setupPopUP(index: 0)
            }
//
            if let planeNode = tarumpahNode, planeNode == result.node {
                Sound.play(file: "checkpoint_clicked.wav")
                setupPopUP(index: 1)
            }

            if let planeNode = tinimiNode, planeNode == result.node {
                collectionViewModel.obtainItem(index: 2)
                setupPopUP(index: 2)
            }

            if let planeNode = lontongNode, planeNode == result.node {
                collectionViewModel.obtainItem(index: 3)
                setupPopUP(index: 3)
            }

        }
    }
}
