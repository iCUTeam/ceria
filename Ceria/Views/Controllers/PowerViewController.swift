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
    
    private let backgroundCanvasView: PKCanvasView =
    {
        let canvas = PKCanvasView()
        canvas.backgroundColor = .white
        return canvas
    }()

    private let canvasView: PKCanvasView =
    {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.tool = PKInkingTool(.marker, color: .red, width: 70)
        return canvas
    }()
    
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
    
    var patternGenerator = PatternGenerator()
    
    var animationSpeed: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundCanvasView)
        view.addSubview(canvasView)
        
        view.addSubview(homeButton)
        setUpAutoLayout()
        
        animationMarkerLayer = CALayer()
        animationMarkerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.1, height: view.frame.width * 0.1)
        animationMarkerLayer.backgroundColor = UIColor.red.cgColor
        animationMarkerLayer.cornerRadius = view.frame.width * 0.05
        animationMarkerLayer.delegate = self
        backgroundCanvasView.layer.addSublayer(animationMarkerLayer)
        
        animationStartMarkerLayer = CALayer()
        animationStartMarkerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.1, height: view.frame.width * 0.1)
        animationStartMarkerLayer.borderColor = UIColor.gray.cgColor
        animationStartMarkerLayer.borderWidth = view.frame.width * 0.01
        animationStartMarkerLayer.cornerRadius = view.frame.width * 0.05
        animationStartMarkerLayer.delegate = self
        backgroundCanvasView.layer.addSublayer(animationStartMarkerLayer)
        
        canvasView.delegate = self
        
     

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundCanvasView.frame = view.bounds
        canvasView.frame = view.bounds
        
        patternGenerator.dotsPoint = patternGenerator.setPoints(currentShape: .flash, frame: backgroundCanvasView.frame)
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
    
    //MARK: Step Animation
    
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
        animationStartMarkerLayer.position = CGPoint(x: backgroundCanvasView.frame.width * 0.7, y: backgroundCanvasView.frame.width * 0.25)
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
        animationMarkerLayer.position = CGPoint(x: backgroundCanvasView.frame.width * 0.7, y: backgroundCanvasView.frame.width * 0.2)
        
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
        if distance < 50 {
            // Adjust the correct stroke to have a green ink.
            canvasView.drawing.strokes[strokeIndex].ink.color = .green
            backgroundCanvasView.drawing.strokes[strokeIndex].ink.color = .clear
            
            sleep(3)
            coordinator?.toStory()
            defaults.set("clear_power_1", forKey: "userState")
            //MARK: In 3 second, move to next page
        } else {
            // If the stroke drawn was bad, remove it so the user can try again.
            canvasView.drawing.strokes.removeLast()
        }
        
        startAnimation(afterDelay: PowerViewController.nextStrokeAnimationTime)
        isUpdatingDrawing = false
    }


    

}
