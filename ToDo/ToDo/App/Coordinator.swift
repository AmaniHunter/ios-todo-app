//
//  Coordinator.swift
//  ToDo
//
//  Created by Amani Hunter on 8/27/24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
