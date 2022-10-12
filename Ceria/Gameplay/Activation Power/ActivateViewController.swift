//
//  ActivateViewController.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 12/10/22.
//

import UIKit
import PencilKit

class ActivateViewController: UIViewController{
    
    
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
        canvas.tool = PKInkingTool(.marker, color: .red, width: 20)
        return canvas
    }()
    
    var patternGenerator = PatternGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundCanvasView)
        view.addSubview(canvasView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundCanvasView.frame = view.bounds
        
        patternGenerator.dotsPoint = patternGenerator.setPoints(currentShape: .flash, frame: backgroundCanvasView.frame)
        backgroundCanvasView.drawing = patternGenerator.synthDrawing(frame: backgroundCanvasView.frame)
        canvasView.frame = view.bounds
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
