//
//  PatternView.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 11/10/22.
//

import UIKit

@IBDesignable
class PatternView: UIView {
    
    enum puzzleItem
    {
        case node(location: CGPoint, name: String, highlighted: Bool)
        case edge(from: CGPoint, to: CGPoint, connected: Bool)
    }
    
    
    var patterns: [puzzleItem] = []
    {
        didSet {setNeedsDisplay()}
    }
    
    override func draw(_ rect: CGRect) {
        
        for pattern in patterns {
            switch (pattern)
            {
                case let .node(location, name, highlighted):
                drawNode(location: location, name: name, highligted: highlighted, frame: rect)
                
                
                case let .edge(from, to, connected):
                drawEdge(from: from, to: to, connected: connected, frame: rect)
            }
        }
    }
    
    func drawNode(location: CGPoint, name: String, highligted: Bool, frame: CGRect)
    {
        let render = UIGraphicsImageRenderer(size: CGSize(width: frame.width * 0.2, height: frame.width * 0.2))
        let img = render.image { context in
            
            if highligted
            {
                context.cgContext.setFillColor(UIColor.blue.cgColor)
                context.cgContext.setStrokeColor(UIColor.gray.cgColor)
                context.cgContext.setLineWidth(3)
            }
            
            else
                
            {
                context.cgContext.setFillColor(UIColor.darkGray.cgColor)
                context.cgContext.setStrokeColor(UIColor.gray.cgColor)
                context.cgContext.setLineWidth(3)
            }
            
            let rectangle = CGRect(x: location.x, y: location.y, width: frame.width * 0.2, height: frame.width * 0.2)
            context.cgContext.addEllipse(in: rectangle)
            context.cgContext.drawPath(using: .fillStroke)
           
        }
        
        let label = UILabel(frame: CGRect(x: location.x, y: location.y, width: frame.width * 0.2, height: frame.width * 0.2))
        label.text = name
        label.textColor = UIColor.white
      
    }
    
    func drawEdge(from: CGPoint, to: CGPoint, connected: Bool, frame: CGRect)
    {
        let edgeRender = UIGraphicsImageRenderer(size: CGSize(width: frame.width * 0.8, height: frame.height * 0.8))
        let edges = edgeRender.image { context in
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(3)
            
            context.cgContext.move(to: from)
            context.cgContext.addLine(to: to)
            
            let rectangle = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            context.cgContext.addRect(rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }
    }


}
