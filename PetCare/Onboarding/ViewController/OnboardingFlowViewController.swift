//
//  OnboardingFlowViewController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

final class OnboardingFlowViewController: UIViewController {
    var onFinish: (() -> Void)?

    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private lazy var pages: [UIViewController] = {
        let welcome = OnboardingPageViewController(contentView: WelcomeOnboardingView())
        let careTracking = OnboardingPageViewController(contentView: CareTrackingOnboardingView())
        let community = OnboardingPageViewController(contentView: CommunityOnboardingView())

        welcome.onNextTap = { [weak self] in
            self?.showPage(at: 1, direction: .forward)
        }
        welcome.onSkipTap = { [weak self] in
            self?.finish()
        }

        careTracking.onNextTap = { [weak self] in
            self?.showPage(at: 2, direction: .forward)
        }
        careTracking.onSkipTap = { [weak self] in
            self?.finish()
        }

        community.onNextTap = { [weak self] in
            self?.finish()
        }
        community.onSkipTap = { [weak self] in
            self?.finish()
        }

        return [welcome, careTracking, community]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupPageController()
    }

    private func setupAppearance() {
        view.backgroundColor = .systemBackground
    }

    private func setupPageController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false)
    }

    private func showPage(at index: Int, direction: UIPageViewController.NavigationDirection) {
        guard pages.indices.contains(index) else { return }

        pageViewController.setViewControllers(
            [pages[index]],
            direction: direction,
            animated: true
        )
    }

    private func finish() {
        onFinish?()
    }
}

extension OnboardingFlowViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(where: { $0 === viewController }), index > 0 else {
            return nil
        }

        return pages[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(where: { $0 === viewController }), index < pages.count - 1 else {
            return nil
        }

        return pages[index + 1]
    }
}

extension OnboardingFlowViewController: UIPageViewControllerDelegate {}
