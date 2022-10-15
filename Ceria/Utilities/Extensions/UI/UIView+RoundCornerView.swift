//
//  UIView+RoundCornerView.swift
//  Ceria
//
//  Created by Kevin Gosalim on 15/10/22.
//

import UIKit

extension UIView {
    func roundCornerView(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
