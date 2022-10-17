//
//  Game2ViewController.swift
//  icu
//
//  Created by Kathleen Febiola Susanto on 04/10/22.
//

import UIKit
import SceneKit
import SwiftySound

class Game2ViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var powerProgressBar: HorizontalProgressBar!
    @IBOutlet weak var sceneView: SCNView!
    
    private lazy var homeButton: MakeButton = {
        let button = MakeButton(image: "home.png", size: CGSize(width: 100, height: 100))
        button.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return button
    }()
    
    let defaults = UserDefaults.standard
    
    //collision bitmask
    let categoryObstacles = 2
    
    var scene: SCNScene!
    
    var gameStarted = false
    var lifeTotal: Int = 1000
    
    var crashNode: SCNNode!
    var selfieNode: SCNNode!
    
    var initialPosition: SCNVector3!
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0,0,0)
    
    var immune = false
    
    let accelerationData: [Float] = [0.40, 0.50, 0.60, 0.70, 0.80, 0.90]
    
    var index = 0
    
    var sounds:[String:SCNAudioSource] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupNodes()
        
        powerProgressBar.progress = 1
        
        view.addSubview(homeButton)
        setUpAutoLayout()
        
        Sound.play(file: "game2.mp3", numberOfLoops: -1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc
        func homeTapped() {
            coordinator?.toLanding()
            AudioSFXPlayer.shared.playCommonSFX()
            Sound.stopAll()
        }
    
    func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
        ])
    }
    
    //manggil scene dan set delegate
    func setupScene()
    {
//        sceneView = self.view as? SCNView
        sceneView.delegate = self
        sceneView.allowsCameraControl = false
        scene = SCNScene(named: "Models.scnassets/Game2.scn")
        sceneView.scene = scene
        
        scene.physicsWorld.contactDelegate = self
        
        //add tap recognizer (tap gesture)
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(Game2ViewController.startPauseGame(recognizer:)))
        sceneView.addGestureRecognizer(tapRecognizer)
       
    }
    
    //set nodes dari yang ada didalem scene yang dipanggil (cari node dengan nama yang diset recursively jadi bisa dpt lebih dari satu asal punya nama yang sama mereka termasuk satu node itu)
    func setupNodes()
    {
        crashNode = scene.rootNode.childNode(withName: "crash", recursively: true)!
        initialPosition = crashNode.position
        crashNode.physicsBody?.contactTestBitMask = categoryObstacles
        selfieNode = scene.rootNode.childNode(withName: "selfie-stick", recursively: true)!
    }
    
    //buat set sfx sama bgm nanti, feel free buat diubah"
    func setupSounds()
    {
        let contohSound = SCNAudioSource(fileNamed: "gantiNamaNanti.wav")!
        contohSound.load()
        contohSound.volume = 0.4
        sounds["contoh"] = contohSound
        
        let backgroundMusic = SCNAudioSource(fileNamed: "BGM_game2.mp3")!
        backgroundMusic.volume = 0.1
        backgroundMusic.loops = true
        backgroundMusic.load()
        
        let musicPlayer = SCNAudioPlayer(source: backgroundMusic)
        crashNode.addAudioPlayer(musicPlayer)
    }
    

    //hide status bar wktu gameplay
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //klo memorynya dah berat nanti mereka release frame cache
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //fungsi buat start dan pause the game
    @objc func startPauseGame(recognizer: UITapGestureRecognizer)
    {
        
        var count = 0
        
        gameStarted.toggle()
        
        //cek klo game start dia mulai jalanin objectnya sesuai accelerationdata yang diatas per sumbu x dan z nya ngikut dari pergerakan accelerometer
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            
            if self.gameStarted
            {
                DispatchQueue.main.async {
                    self.motion.getAccelerometerData{ (x, y, z) in
                        
                        self.crashNode.position += SCNVector3(x: self.accelerationData[self.index], y: 0, z: x * 0.50)

                        
                    }
                    
    
                    //timernya kan jalan 0.1 detik sekali, jadi itungannya 10 detik tu berarti dah jalan 100 hitungan
                    count += 1
                    
                    //that's why klo countnya dia = 100 nanti kita tambahin index accelerationnya biar ambil next acceleration yang lebih cepet terus kita balik lagi count dari 0
                    if count % 100 == 0
                    {
                        self.index+=1
                        count = 0
                    }
                    
                    //validasi kalau sudah sampe finish
                    if self.crashNode.position.x >= 280
                    {
                        timer.invalidate()
                        
                        //temporary alert
                        let alert = UIAlertController(title: "Kamu berhasil!", message: "Asik, kita sudah sampai ke sarang Garuda! Ayo selamatkan tuan putri!", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Asik", style: .default)
                        {_ in
                            alert.dismiss(animated: true)
                            self.coordinator?.toSuccess()
                            Sound.stopAll()
                            self.defaults.set("clear_challenge_1", forKey: "userState")
                        })
                        
                        self.present(alert, animated: true)
                        
                        
                    }
                }
            }
            
            //kalau gamenya dipause kita stop timernya biar ga bisa jalan kemana-mana
            
            else
            {
                timer.invalidate()
            }
        }
        
       
    }
    
    //fungsi buat update view per frame
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let crash = crashNode.presentation
        let crashing = crash.position
        
       
        //make camera follow object based on targeted position per frame (using selfie node yang ditaruh dibawah object yang difollow)
        let targetPosition = SCNVector3(x: crashing.x - 3, y: crashing.y + 2, z:crashing.z )
        var cameraPosition = selfieNode.position
        
        let camDamping:Float = 0.3
        
        let xComponent = cameraPosition.x * (1 - camDamping) + targetPosition.x * camDamping
        let yComponent = cameraPosition.y * (1 - camDamping) + targetPosition.y * camDamping
        let zComponent = cameraPosition.z * (1 - camDamping) + targetPosition.z * camDamping
        
        cameraPosition = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
        selfieNode.position = cameraPosition

    }
    
    //fungsi buat deteksi collision (tabrakan) antar object
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode:SCNNode!
        
        if contact.nodeA.name == "crash" {
            contactNode = contact.nodeB
        }else{
            contactNode = contact.nodeA
        }
        
    //detect klo yang dicollide itu obstacles bukan pake bit mask
        if contactNode.physicsBody?.categoryBitMask == categoryObstacles {
            
            //cek dia immune atau engga sama kalau total lifenya masih ada or not
            if lifeTotal > 0 && !immune
            {
                //kalau nabrak nodenya kita hide dan nyawa berkurang
                contactNode.isHidden = true
                lifeTotal -= 200
                
                DispatchQueue.main.async {
                    self.powerProgressBar.progress -= 0.2
                }
                
                index = 0
                
                
                //klo dia nabrak, dia bakal immune for 5 second sebelum dia balik bisa nabrak lagi
                immune.toggle()
                
                var immuneCount = 0
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                    DispatchQueue.main.async {
                        immuneCount+=1
                        
                        if immuneCount == 5
                        {
                            self.immune.toggle()
                            timer.invalidate()
                            immuneCount = 0
                        }
                    }
                    
                    
                }
            }
            
            
            else if lifeTotal == 0
            {
                print("try again")
                contactNode.isHidden = true
                lifeTotal = 1000
                
                DispatchQueue.main.async {
                    self.powerProgressBar.progress = 1
                }
               
                crashNode.position = initialPosition
            }
          
            
            //setelah 2 second, nodenya akan ditampilin lagi
            let waitAction = SCNAction.wait(duration: 2)
            let unhideAction = SCNAction.run { (node) in
                node.isHidden = false
            }
            
            let actionSequence = SCNAction.sequence([waitAction, unhideAction])
            
            contactNode.runAction(actionSequence)
        }
    }

}
