//
//  LandingView.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import UIKit

final class LandingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private lazy var landingLabel: UILabel = {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let constant: CGFloat
        let size: CGFloat
        
        switch screenWidth {
        case 744: //7.9 inch
            constant = 10.0
            size = 32
        case 768: //8.3 inch
            constant = 10.0
            size = 33
        case 810: //10.2 inch
            constant = 10.0
            size = 34
        case 820: //10.9 inch
            constant = 10.0
            size = 35
        case 834: //10.5 & 11 inch
            constant = 10.0
            size = 36
        default: //12.9 inch
            constant = 10.0
            size = 36
        }
        
        let label = UILabel()
        label.text = "Cerita rakyat Sulawesi Selatan tentang keempat\nbersaudara bersama-sama menyelamatkan\ntuan puteri yang diculik"
        label.setLineHeight(lineHeight: constant)
        label.font = UIFont.scriptFont(size: size)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var landingTextFrame: UIView = {
        let frame = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 362))
        frame.backgroundColor = .white
        frame.roundCornerView(corners: [.topRight, .topLeft], radius: 25)
        addSubview(frame)
        frame.addSubview(landingLabel)
        return frame
    }()
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            landingTextFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            landingLabel.topAnchor.constraint(equalTo: landingTextFrame.topAnchor, constant: 100),
            landingLabel.leftAnchor.constraint(equalTo: landingTextFrame.leftAnchor, constant: 20),
            landingLabel.rightAnchor.constraint(equalTo: landingTextFrame.rightAnchor, constant: -20),
        ])
    }
    
}

