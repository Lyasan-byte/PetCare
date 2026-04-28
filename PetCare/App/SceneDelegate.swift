//
//  SceneDelegate.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 24.03.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let appContainer = AppContainer()

    private lazy var appCoordinator: AppCoordinator = {
        appContainer.resolver.resolveOrFail(AppCoordinator.self)
    }()

    private lazy var settingsRepository: SettingsRepository = {
        appContainer.resolver.resolveOrFail(SettingsRepository.self)
    }()

    private lazy var settingsApplicationController: SettingsApplicationControlling = {
        appContainer.resolver.resolveOrFail(SettingsApplicationControlling.self)
    }()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let settings = settingsRepository.loadSettings()
        settingsApplicationController.applyLanguage(settings.language)
        window = appCoordinator.start(scene)
        settingsApplicationController.applyTheme(settings.theme)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }
}
