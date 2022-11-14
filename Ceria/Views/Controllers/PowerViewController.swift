//
//  ActivateViewController.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 12/10/22.
//

import UIKit
import PencilKit
import SwiftySound

class PowerViewController: UIViewController, PKCanvasViewDelegate, CALayerDelegate, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
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
    
    private lazy var dialogueTextBox: PowerView = {
        let dialogue = PowerView(content: "Ikuti pola di atas untuk memilih seseorang dari keempat bersaudara yang akan menjemput tuan puteri dari tempat burung garuda.")
        return dialogue
    }()
    
    private let backgroundCanvasView: PKCanvasView =
    {
        let canvas = PKCanvasView()
        canvas.backgroundColor = .clear
        canvas.translatesAutoresizingMaskIntoConstraints = false
        return canvas
    }()
    
    private let canvasView: PKCanvasView =
    {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.tool = PKInkingTool(.marker, color: .black, width: 70)
        canvas.translatesAutoresizingMaskIntoConstraints = false
        return canvas
    }()
    
    private lazy var ruaSymbol: UIImageView = {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let x: CGFloat
        let y: CGFloat
        let w: CGFloat
        let h: CGFloat
        
        if screenWidth == 834.0 {
            x = -10
            y = -10
            w = 850
            h = 1020
        } else {
            x = 15
            y = -15
            w = 1000
            h = 1200
        }
        
        let ruaSymbol = UIImageView(frame: CGRect(x: x, y: y, width: w, height: h))
        ruaSymbol.image = UIImage(named: "bungko_symbol.png")
        ruaSymbol.contentMode = .scaleToFill
        return ruaSymbol
    }()
    
    private lazy var hintButton: MakeButton = {
        let button = MakeButton(image: "rua_silhouette.png", size: CGSize(width: 150, height: 150))
        button.addTarget(self, action: #selector(hintTapped), for: .touchUpInside)
        return button
    }()
    
    //    private lazy var ruaSilhouette: UIImageView = {
    //        let silhouette = UIImageView(frame: CGRect(x: 5, y: 1200, width: 150, height: 150))
    //        silhouette.image = UIImage(named: "rua_silhouette.png")
    //        silhouette.contentMode = .scaleAspectFit
    //        return silhouette
    //    }()
    //
    //    private lazy var ruaFace: UIImageView = {
    //        let face = UIImageView(frame: CGRect(x: 5, y: 1200, width: 150, height: 150))
    //        face.image = UIImage(named: "rua.png")
    //        face.contentMode = .scaleAspectFit
    //        return face
    //    }()
    
    
    let defaults = UserDefaults.standard
    
    // Animation.
    static let repeatStrokeAnimationTime: TimeInterval = 4
    static let nextStrokeAnimationTime: TimeInterval = 0.5
    
    var animatingStroke: PKStroke?
    var animationMarkerLayer: CALayer!
    var animationStartMarkerLayer: CALayer!
    var animationParametricValue: CGFloat = 0
    var animationLastFrameTime = Date()
    var animationTimer: Timer?
    var isCharacterShown: Bool = false
    
    var patternGenerator = PatternGenerator()
    
    var animationSpeed: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ruaSymbol)
        
        view.addSubview(hintButton)
        
        view.addSubview(backgroundCanvasView)
        view.addSubview(canvasView)
        
        view.addSubview(dialogueTextBox)
        view.addSubview(homeButton)
        view.addSubview(nextButton)
        setUpAutoLayout()
        
        animationMarkerLayer = CALayer()
        animationMarkerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.1, height: view.frame.width * 0.1)
        animationMarkerLayer.backgroundColor = UIColor.red.cgColor
        animationMarkerLayer.cornerRadius = view.frame.width * 0.05
        animationMarkerLayer.delegate = self
        backgroundCanvasView.layer.addSublayer(animationMarkerLayer)
        
        animationStartMarkerLayer = CALayer()
        animationStartMarkerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.1, height: view.frame.width * 0.1)
        animationStartMarkerLayer.borderColor = UIColor.yellow.cgColor
        animationStartMarkerLayer.borderWidth = view.frame.width * 0.01
        animationStartMarkerLayer.cornerRadius = view.frame.width * 0.05
        animationStartMarkerLayer.delegate = self
        backgroundCanvasView.layer.addSublayer(animationStartMarkerLayer)
        
        canvasView.delegate = self
        
        nextButton.isHidden = true
        Sound.stopAll()
        Sound.play(file: "tallu_power2.m4a")
        AudioBGMPlayer.shared.playStoryBGM1()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        let x: CGFloat
        let y: CGFloat
        let w: CGFloat
        let h: CGFloat
        
        if screenWidth == 834.0 {
            x = -90
            y = -120
            w = 1020
            h = 1190
        } else {
            x = -100
            y = -150
            w = 1200
            h = 1400
        }
        
        backgroundCanvasView.frame = CGRect(x: x, y: y, width: w, height: h)
        canvasView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        patternGenerator.dotsPoint = patternGenerator.setPoints(currentShape: .flag, frame: backgroundCanvasView.frame)
        backgroundCanvasView.drawing = patternGenerator.synthDrawing(frame: backgroundCanvasView.frame)
        
        animateNextStroke()
        
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
    
    //MARK: Step Animation
    
    @objc
    func homeTapped() {
        coordinator?.toLanding()
        AudioSFXPlayer.shared.playCommonSFX()
        Sound.stopAll()
        AudioBGMPlayer.shared.playStoryBGM1()
    }
    
    @objc
    func hintTapped() {
        if isCharacterShown == false {
            Sound.play(file: "power2_hint.m4a")
        } else {
            Sound.play(file: "")
        }
    }
    
    @objc
    func nextTapped() {
        Sound.stopAll()
        coordinator?.toStory()
        defaults.set("clear_power_1", forKey: "userState")
    }
    
    func checkHintButtonChange() {
        let customButtonImage = UIImage(named: "rua.png")
        let newimage = customButtonImage?.resizedImage(size: CGSize(width: 150, height: 150))
        hintButton.setImage(newimage, for: .normal)
        
        isCharacterShown = true
        
        nextButton.isHidden = false
    }
    
    func setUpAutoLayout() {
        
        NSLayoutConstraint.activate([
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            homeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            hintButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            hintButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            dialogueTextBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -170),
            dialogueTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 95),
            dialogueTextBox.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24),
            //dialogueTextBox.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            backgroundCanvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundCanvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            canvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 500)
        ])
    }
    
    func animateNextStroke() {
        
        let nextStrokeIndex = canvasView.drawing.strokes.count
        guard nextStrokeIndex < backgroundCanvasView.drawing.strokes.count else {
            // Hide the animation markers.
            animationMarkerLayer.opacity = 0.0
            animationStartMarkerLayer.opacity = 0.0
            return
        }
        
        let strokeToAnimate = backgroundCanvasView.drawing.strokes[nextStrokeIndex]
        animatingStroke = strokeToAnimate
        animationParametricValue = 0
        animationLastFrameTime = Date()
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60, repeats: true) { _ in self.stepAnimation() }
        
        // Setup the start marker layer.
        animationStartMarkerLayer.position = patternGenerator.dotsPoint.first ?? CGPoint(x: backgroundCanvasView.frame.width * 0.7, y: backgroundCanvasView.frame.width * 0.2)
        animationStartMarkerLayer.opacity = 1.0
    }
    
    func startAnimation(afterDelay delay: TimeInterval) {
        // Animate the next stroke again after `delay`.
        stopAnimation()
        animationTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            // Only animate the next stroke if another animation has not already started.
            if self.animatingStroke == nil {
                self.animateNextStroke()
            }
        }
    }
    
    func stopAnimation() {
        animationMarkerLayer.opacity = 0
        animatingStroke = nil
        animationTimer?.invalidate()
    }
    
    func stepAnimation() {
        guard let animatingStroke = animatingStroke, animationParametricValue < CGFloat(animatingStroke.path.count - 1) else {
            // Animate the next stroke again, in `repeatStrokeAnimationTime` seconds.
            startAnimation(afterDelay: PowerViewController.repeatStrokeAnimationTime)
            return
        }
        
        let currentTime = Date()
        let delta = currentTime.timeIntervalSince(animationLastFrameTime)
        animationParametricValue = animatingStroke.path.parametricValue(
            animationParametricValue,
            offsetBy: .time(delta * TimeInterval(animationSpeed)))
        animationMarkerLayer.position = patternGenerator.dotsPoint.first ?? CGPoint(x: backgroundCanvasView.frame.width * 0.7, y: backgroundCanvasView.frame.width * 0.2)
        
        print(animationMarkerLayer.position)
        animationMarkerLayer.opacity = 1
        animationLastFrameTime = currentTime
    }
    
    var isUpdatingDrawing = false
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        // Stop any animation as soon as the user begins to draw.
        stopAnimation()
        animationStartMarkerLayer.opacity = 0.0
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        // Avoid triggering the scoring, if we are programatically mutating the drawing.
        guard !isUpdatingDrawing else { return }
        
        let testDrawing = backgroundCanvasView.drawing
        let strokeIndex = canvasView.drawing.strokes.count - 1
        
        // Score the last stroke.
        guard let lastStroke = canvasView.drawing.strokes.last else { return }
        guard strokeIndex < testDrawing.strokes.count else { return }
        
        isUpdatingDrawing = true
        
        let distance = lastStroke.discreteFrechetDistance(to: testDrawing.strokes[strokeIndex], maxThreshold: 5)
        
        print(distance)
        if distance < 20 {
            // Adjust the correct stroke to have a green ink.
            canvasView.drawing.strokes[strokeIndex].ink.color = .init(red: 255/255, green: 196/255, blue: 0/255, alpha: 1)
            canvasView.tool = PKInkingTool(.marker, color: .clear, width: 70)
            Sound.play(file: "finish.wav")
            checkHintButtonChange()
            
            backgroundCanvasView.drawing.strokes[strokeIndex].ink.color = .clear
            Sound.play(file: "rua_power_success.m4a")
            
            
            //            AudioBGMPlayer.shared.playStoryBGM1()
            //MARK: In 3 second, move to next page
        } else {
            // If the stroke drawn was bad, remove it so the user can try again.
            Sound.play(file: "power2_fail.m4a")
            canvasView.drawing.strokes.removeLast()
            
        }
        
        startAnimation(afterDelay: PowerViewController.nextStrokeAnimationTime)
        isUpdatingDrawing = false
    }
    
    
    
    
}
