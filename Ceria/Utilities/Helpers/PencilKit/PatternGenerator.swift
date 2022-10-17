//
//  PatternGenerator.swift
//  Ceria
//
//  Created by Kathleen Febiola Susanto on 12/10/22.
//

import PencilKit

enum shape
{
    case psychic
    case flash
    case arrow
    case flag
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
        let stroke = PKStroke(ink: PKInk(.marker, color: .systemGray4), path: strokePath)
        
        drawing.strokes = [stroke]
        
        return drawing
    }
    
    func setPoints(currentShape: shape, frame: CGRect) -> [CGPoint]
    {
        
        switch (currentShape)
        {
            case .psychic:
            //MARK: Add the shape later
            return [CGPoint(x: 0, y: 0)]
            
            case .flash:
            return [CGPoint(x: frame.width * 0.7, y: frame.height * 0.2), CGPoint(x: frame.width * 0.1, y: frame.height * 0.5), CGPoint(x: frame.width * 0.8, y: frame.height * 0.55), CGPoint(x: frame.width * 0.3, y: frame.height * 0.85)]
            
            case .arrow:
            //MARK: Add the shape later
            return [CGPoint(x: 0, y: 0)]
            
            case .flag:
            //MARK: Add the shape later
            return [CGPoint(x: 0, y: 0)]
            
            case .notSet:
            print("Error: Pattern Unset")
            return []
        }
    }
}
