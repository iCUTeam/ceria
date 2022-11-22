//
//  RestartConfirmationView.swift
//  Carita
//
//  Created by Kevin Gosalim on 17/11/22.
//

import UIKit

class RestartConfirmationView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var content: String
    
    init(content: String) {
        self.content = content
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupAutoLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var confirmationLabel: UILabel = {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let constant: CGFloat
        let size: CGFloat
        
        switch screenWidth {
        case 744: //7.9 inch
            constant = 11.0
            size = 20
        case 768: //8.3 inch
            constant = 11.0
            size = 20
        case 810: //10.2 inch
            constant = 12.0
            size = 21
        case 820: //10.9 inch
            constant = 12.0
            size = 21
        case 834: //10.5 & 11 inch
            constant = 12.0
            size = 23
        default: //12.9 inch
            constant = 15.0
            size = 25
        }
        
        let label = UILabel()
        label.text = content
        label.setLineHeight(lineHeight: constant)
        label.font = UIFont.scriptFont(size: size)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmationTextFrame: UIView = {
        
        let frame = UIView(frame: CGRect(x:0, y:0, width: (UIScreen.main.bounds.width)-400, height: 140))
        frame.backgroundColor = UIColor(red: 242.0/255, green: 205.0/255, blue: 93.0/255, alpha: 1.0)
        frame.roundCornerView(corners: .allCorners, radius: 25)
        addSubview(frame)
        frame.addSubview(confirmationLabel)
        return frame
    }()
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            confirmationTextFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            confirmationLabel.topAnchor.constraint(equalTo: confirmationTextFrame.topAnchor, constant: 20),
            confirmationLabel.leftAnchor.constraint(equalTo: confirmationTextFrame.leftAnchor, constant: 20),
            confirmationLabel.rightAnchor.constraint(equalTo: confirmationTextFrame.rightAnchor, constant: -20),
        ])
    }
}
