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
    private let userProfileRepository: UserProfileRepository
    private weak var moduleOutput: UserProfileModuleOutput?
    private var bag = Set<AnyCancellable>()

    init(
        petRepository: PetRepository,
        userProfileRepository: UserProfileRepository,
        moduleOutput: UserProfileModuleOutput?
    ) {
        self.petRepository = petRepository
        self.userProfileRepository = userProfileRepository
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: UserProfileIntent) {
        switch intent {
        case .onDidLoad, .refresh:
            loadProfile()
        case .editTapped:
            moduleOutput?.userProfileModuleDidRequestEdit()
        case .settingsTapped:
            moduleOutput?.userProfileModuleDidRequestSettings()
        case .logoutTapped:
            logout()
        }
    }

    private func loadProfile() {
        state = .loading

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
                self?.state = .content(
                    UserProfileContent(
                        fullName: user.fullName,
                        email: user.email ?? NSLocalizedString("user.profile.email.missing", comment: ""),
                        petsCountText: String(format: "%02d", pets.count),
                        bestScoreText: "159",
                        avatarURLString: user.avatarURLString
                    )
                )
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
