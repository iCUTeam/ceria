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
    
    private lazy var collectionButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = .filled()
        btn.configuration?.title = "Collection"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var aboutButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.configuration = .filled()
        btn.configuration?.title = "About"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [collectionButton, aboutButton])
            stackView.axis = .horizontal
            stackView.distribution = .equalCentering
            stackView.spacing = 100
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)

            return stackView
        }()
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 20
        setupAutoLayout()
            
    }
    
    
    private func setupAutoLayout() {
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
            ])
    }

}
