//
//  ActivatePowerController.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 11/10/22.
//

import UIKit

class ActivatePowerController: UIViewController {
    
    @IBOutlet weak var puzzleView: PatternView!
    
    var patternDots: [Dots] = []
    
    
    //Activation Power Logic (Coz Kath's head explodes again)
    //1. Load puzzle, instruction, and home button -> on view loaded
    //2. Next node to be swiped would have node highlighted in another color
    //3. If player swipe to the right node, then node will be connected with edge
    //4. If player swipe to the wrong node, they will start over
    //5. Once all node connected, move to the next page

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPuzzle()
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ActivatePowerController.traceDots(recognizer:)))
        
        puzzleView.addGestureRecognizer(panRecognizer)
        
    }
    
    func setupDots()
    {
    
        if let path = Bundle.main.path(forResource: "star", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? Dictionary<String, AnyObject>,
                        let nodes = jsonResult["nodes"] as? [CGPoint] {
                        
                      var order = 1
                      
                      for node in nodes {
                          
                          patternDots.append(Dots(order: order, location: CGPoint(x: node.x, y: node.y), connected: false))
                      }
                  }
              } catch {
                  print(error.localizedDescription)
              }
        }
    }
    
    func setupPuzzle()
    {
        
        var initial: CGPoint = CGPoint(x: 0, y: 0)
        
        for dot in patternDots {
            puzzleView.patterns.append(PatternView.puzzleItem.node(location: dot.location, name: String(dot.order), highlighted: initial.x == 0 ? true: false))
            
            
            if initial.x != 0
            {
                puzzleView.patterns.append(PatternView.puzzleItem.edge(from: initial, to: dot.location, connected: false))
            }
            
            initial = dot.location
            
        }
    }
    
    @objc func traceDots(recognizer: UIPanGestureRecognizer)
    {
        let location = recognizer.location(in: puzzleView)
        
        //MARK: Logic
        //cek translation di view terus buat garis dari titik pertama start touch smpe ke translation
    }
    


}
