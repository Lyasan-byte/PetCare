//
//  TabBarController.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import Combine
import Swinject
import UIKit
import FirebaseAuth

final class TabBarController: UITabBarController {
    private var petsMainCoordinator: PetsMainCoordinator?
    private var userProfileCoordinator: UserProfileCoordinator?
    private var publicPetsCoordinator: PublicPetsCoordinator?
    private var miniGameCoordinator: MiniGameCoordinator?

    private let resolver: Resolver

    private var bag = Set<AnyCancellable>()

    init(resolver: Resolver) {
        self.resolver = resolver

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        bindLanguageChanges()
    }

    private func setupTabs() {
        setViewControllers(makeTabViewControllers(), animated: true)
    }

    private func bindLanguageChanges() {
        NotificationCenter.default.publisher(for: .settingsLanguageDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadInactiveTabsForCurrentLanguage()
            }
            .store(in: &bag)
    }

    private func reloadInactiveTabsForCurrentLanguage() {
        guard let currentViewControllers = viewControllers,
              currentViewControllers.indices.contains(selectedIndex) else {
            setupTabs()
            return
        }

        let selectedViewController = currentViewControllers[selectedIndex]

        let refreshedViewControllers = makeTabViewControllers(
            preservingViewController: selectedViewController,
            at: selectedIndex
        )

        setViewControllers(refreshedViewControllers, animated: false)
        selectedIndex = min(selectedIndex, refreshedViewControllers.count - 1)
    }

    private func makeTabViewControllers(
        preservingViewController preservedViewController: UIViewController? = nil,
        at preservedIndex: Int? = nil
    ) -> [UIViewController] {
        let ownerId = Auth.auth().currentUser?.uid ?? "test_owner_id"

        return [
            makePetsNavigationController(
                ownerId: ownerId,
                preservedViewController,
                preservedIndex == 0
            ),
            makePublicPetsNavigationController(
                ownerId: ownerId,
                preservedViewController,
                preservedIndex == 1
            ),
            makeMiniGameNavigationController(
                ownerId: ownerId,
                preservedViewController,
                preservedIndex == 2
            ),
            makeUserProfileNavigationController(
                ownerId: ownerId,
                preservedViewController,
                preservedIndex == 3
            )
        ]
    }

    private func makePetsNavigationController(
        ownerId: String,
        _ preservedViewController: UIViewController?,
        _ shouldPreserve: Bool
    ) -> UIViewController {
        if shouldPreserve, let preservedViewController {
            return preservedViewController
        }

        let navigationController = UINavigationController()

        let coordinator = resolver.resolveOrFail(
            PetsMainCoordinator.self,
            arguments: navigationController,
            ownerId
        )

        self.petsMainCoordinator = coordinator
        coordinator.start()

        navigationController.tabBarItem.image = UIImage(systemName: "pawprint.fill")
        navigationController.tabBarItem.title = nil

        return navigationController
    }

    private func makePublicPetsNavigationController(
        ownerId: String,
        _ preservedViewController: UIViewController?,
        _ shouldPreserve: Bool
    ) -> UIViewController {
        if shouldPreserve, let preservedViewController {
            return preservedViewController
        }

        let navigationController = UINavigationController()

        let coordinator = resolver.resolveOrFail(
            PublicPetsCoordinator.self,
            arguments: navigationController,
            ownerId
        )

        self.publicPetsCoordinator = coordinator
        coordinator.start()

        navigationController.tabBarItem.image = UIImage(systemName: "globe.americas.fill")
        navigationController.tabBarItem.title = nil

        return navigationController
    }

    private func makeMiniGameNavigationController(
        ownerId: String,
        _ preservedViewController: UIViewController?,
        _ shouldPreserve: Bool
    ) -> UIViewController {
        if shouldPreserve, let preservedViewController {
            return preservedViewController
        }

        let navigationController = UINavigationController()

        let coordinator = resolver.resolveOrFail(
            MiniGameCoordinator.self,
            arguments: navigationController,
            ownerId
        )

        self.miniGameCoordinator = coordinator
        coordinator.start()

        navigationController.tabBarItem.image = UIImage(systemName: "gamecontroller.fill")
        navigationController.tabBarItem.title = nil

        return navigationController
    }

    private func makeUserProfileNavigationController(
        ownerId: String,
        _ preservedViewController: UIViewController?,
        _ shouldPreserve: Bool
    ) -> UIViewController {
        if shouldPreserve, let preservedViewController {
            return preservedViewController
        }

        let navigationController = UINavigationController()

        let coordinator = resolver.resolveOrFail(
            UserProfileCoordinator.self,
            arguments: navigationController,
            ownerId
        )

        self.userProfileCoordinator = coordinator
        coordinator.start()

        navigationController.tabBarItem.image = UIImage(systemName: "person.fill")
        navigationController.tabBarItem.title = nil

        return navigationController
    }
}
