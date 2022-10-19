//
//  Checkbox.swift
//  Ceria
//
//  Created by Ariel Waraney on 19/10/22.
//

import UIKit

final class Checkbox: UIView {

    private var isChecked = false
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 242.0/255, green: 205.0/255, blue: 93.0/255, alpha: 1)
        imageView.image = UIImage(systemName: "checkmark")
        return imageView
    }()
    
    let boxView: UIView = {
       let boxView = UIView()
        boxView.layer.cornerRadius = 10
        boxView.layer.backgroundColor = UIColor(red: 69.0/255, green: 173.0/255, blue: 226.0/225, alpha: 1).cgColor
        return boxView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(boxView)
        addSubview(imageView)
        clipsToBounds = true
    }

    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        boxView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        imageView.frame = bounds
    }
    
    func toggle() -> Bool {
        self.isChecked = !isChecked
        
        imageView.isHidden = !isChecked
        
        return isChecked
    }
}
