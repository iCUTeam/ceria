//
//  Game2View.swift
//  Carita
//
//  Created by Kevin Gosalim on 16/11/22.
//

import UIKit

class Game2View: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    lazy var tapToStart: UIImageView = {
        let image = UIImage(named: "taptostart")
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: UIScreen.main.bounds.midX-300, y: UIScreen.main.bounds.midY+60, width: 600, height: 319)
        return imageView
    }()
    
    private lazy var tapLayer: UIView = {
        
        let frame = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        frame.backgroundColor = .black
        frame.alpha = 0.9
        addSubview(frame)
        frame.addSubview(tapToStart)
        return frame
    }()
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            tapLayer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            tapToStart.topAnchor.constraint(equalTo: tapLayer.topAnchor, constant: 20),
            tapToStart.leftAnchor.constraint(equalTo: tapLayer.leftAnchor, constant: 20),
            tapToStart.rightAnchor.constraint(equalTo: tapLayer.rightAnchor, constant: -20),
        ])
    }
}
