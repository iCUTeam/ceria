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
        let label = UILabel()
        label.text = "Kisah dari Sulawesi Selatan tentang keempat\nbersaudara bersama-sama menyelamatkan\nputeri yang hilang"
        label.setLineHeight(lineHeight: 10.0)
        label.font = UIFont.scriptFont(size: 36)
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

