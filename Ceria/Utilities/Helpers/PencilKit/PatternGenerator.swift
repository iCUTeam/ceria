//
//  PatternGenerator.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 12/10/22.
//

import PencilKit

enum shape
{
    case eye
    case flash
    case arrow
    case hammer
    case notSet
}

struct PatternGenerator
{
    var dotsPoint: [CGPoint] = []
    
    func synthDrawing(frame: CGRect) -> PKDrawing
    {
        var drawing = PKDrawing()
        
        let strokePoints = dotsPoint.map
        {
            PKStrokePoint(location: $0, timeOffset: 0, size: CGSize(width: frame.width * 0.05, height: frame.width * 0.05), opacity: 1, force: 0, azimuth: 0, altitude: 0)
        }
        
        let strokePath = PKStrokePath(controlPoints: strokePoints, creationDate: Date())
        let stroke = PKStroke(ink: PKInk(.marker, color: .clear), path: strokePath)
        
        drawing.strokes = [stroke]
        
        return drawing
    }
    
    func setPoints(currentShape: shape, frame: CGRect) -> [CGPoint]
    {
        
        switch (currentShape)
        {
            case .eye:
            return [CGPoint(x: frame.width * 0.75, y: frame.height * 0.25), CGPoint(x: frame.width * 0.03, y: frame.height * 0.5), CGPoint(x: frame.width * 0.8, y: frame.height * 0.9), CGPoint(x: frame.width * 0.8, y: frame.height * 0.5), CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)]
            
            case .flash:
            return [CGPoint(x: frame.width * 0.7, y: frame.height * 0.2), CGPoint(x: frame.width * 0.05, y: frame.height * 0.6), CGPoint(x: frame.width * 0.9, y: frame.height * 0.5), CGPoint(x: frame.width * 0.3, y: frame.height * 0.85)]
            
            case .arrow:
            return [CGPoint(x: frame.width * 0.72, y: frame.height * 0.25), CGPoint(x: frame.width * 0.1, y: frame.height * 0.45), CGPoint(x: frame.width * 0.95, y: frame.height * 0.8), CGPoint(x: frame.width * 0.9, y: frame.height * 0.001), CGPoint(x: frame.width * 0.38, y: frame.height * 0.8)]
            
            case .hammer:
            return [CGPoint(x: frame.width * 0.4, y: frame.height * 0.25), CGPoint(x: frame.width * 0.2, y: frame.height * 0.2), CGPoint(x: frame.width * 0.4, y: frame.height * 0.5), CGPoint(x: frame.width * 0.8, y: frame.height * 0.55), CGPoint(x: frame.width * 0.75, y: frame.height * 0.25), CGPoint(x: frame.width * 0.45, y: frame.height * 0.25), CGPoint(x: frame.width * 0.4, y: frame.height * 0.85)]
            
            case .notSet:
            print("Error: Pattern Unset")
            return []
        }
    }
}
