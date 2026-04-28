//
//  UserProfileViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import UIKit
import Combine

final class UserProfileViewModel: UserProfileViewModeling {
    private(set) var stateDidChange = ObservableObjectPublisher()
    @Published private(set) var state: UserProfileState = .loading {
        didSet {
            stateDidChange.send()
        }
    }

    private let petRepository: PetRepository
    private let bestScoreRepository: MiniGameBestScoreRepository
    private let userProfileRepository: UserProfileRepository
    private weak var moduleOutput: UserProfileModuleOutput?
    private var bag = Set<AnyCancellable>()
    private var currentUser: UserProfileUser?

    init(
        petRepository: PetRepository,
        bestScoreRepository: MiniGameBestScoreRepository,
        userProfileRepository: UserProfileRepository,
        moduleOutput: UserProfileModuleOutput?
    ) {
        self.petRepository = petRepository
        self.bestScoreRepository = bestScoreRepository
        self.userProfileRepository = userProfileRepository
        self.moduleOutput = moduleOutput
        bindPetDataChanges()
    }

    func trigger(_ intent: UserProfileIntent) {
        switch intent {
        case .onDidLoad, .refresh:
            loadProfile()
        case .editTapped:
            guard let currentUser else { return }
            moduleOutput?.userProfileModuleDidRequestEdit(currentUser)
        case .settingsTapped:
            moduleOutput?.userProfileModuleDidRequestSettings()
        case .logoutTapped:
            logout()
        }
    }

    private func loadProfile() {
        state = .loading
        currentUser = nil

        userProfileRepository.fetchCurrentUser()
            .flatMap { [petRepository] user in
                petRepository.fetchPets(for: user.id)
                    .map { (user, $0) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] user, pets in
                guard let self else { return }
                self.currentUser = user
                self.state = .content(
                    UserProfileContent(
                        fullName: user.fullName,
                        email: user.email ?? NSLocalizedString("user.profile.email.missing", comment: ""),
                        petsCountText: String(format: "%02d", pets.count),
                        bestScoreText: String(pets.map(self.bestScoreRepository.bestScore(for:)).max() ?? 0),
                        avatarURLString: user.avatarURLString
                    )
                )
            }
            .store(in: &bag)
    }

    private func bindPetDataChanges() {
        NotificationCenter.default.publisher(for: .petDataDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadProfile()
            }
            .store(in: &bag)
    }

    private func logout() {
        userProfileRepository.signOut()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { _ in
            }
            .store(in: &bag)
    }
}
