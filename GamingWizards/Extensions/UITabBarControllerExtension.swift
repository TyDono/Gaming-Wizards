//
//  UITabBarControllerExtension.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/6/22.
//

import Foundation
import SwiftUI

extension UITabBarController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = .white
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .gray
        
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        self.tabBar.standardAppearance = appearance
    }
}
