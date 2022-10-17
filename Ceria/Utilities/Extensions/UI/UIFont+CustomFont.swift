//
//  UIFont+CustomFont.swift
//  Ceria
//
//  Created by Kevin Gosalim on 15/10/22.
//

import Foundation
import UIKit

extension UIFont {
    
    static func scriptFont(size: CGFloat) -> UIFont {
      guard let customFont = UIFont(name: "Stanberry", size: size) else {
        return UIFont.systemFont(ofSize: size)
      }
      return customFont
    }
}
