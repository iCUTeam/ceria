//
//  Coordinators.swift
//  Ceria
//
//  Created by Kevin Gosalim on 12/10/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func toLanding()
}
