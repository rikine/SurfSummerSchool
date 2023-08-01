//
//  RootCoordinator.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import Foundation
import UIKit

final class RootCoordinator {
    private let navigationController: UINavigationController
    let window: UIWindow?
    
    private weak var profileVC: ProfileViewController?
    
    init(scene: UIWindowScene) {
        navigationController = UINavigationController()
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func start(viewModel: any ProfileViewModelProtocol = ProfileViewModel(skills: .exampleLong)) {
        setup()
        showProfile(viewModel: viewModel)
    }
    
    private func setup() {
        let splash = UIStoryboard(name: "LaunchScreen", bundle: nil)
                .instantiateViewController(withIdentifier: "LaunchScreen")
        navigationController.setViewControllers([splash], animated: false)
    }
    
    private func showProfile(viewModel: any ProfileViewModelProtocol) {
        let profileVC = ProfileViewController(viewModel)
        navigationController.setViewControllers([profileVC], animated: true)
        self.profileVC = profileVC
    }
}
