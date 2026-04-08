//
//  PublicPetProfileViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import Foundation
import Combine

final class PublicPetProfileViewModel: PublicPetProfileViewModeling {
    @Published private(set) var state: PublicPetProfileState {
        didSet {
            stateDidChange.send()
        }
    }

    private var bag = Set<AnyCancellable>()
    private(set) var stateDidChange = ObservableObjectPublisher()
    private(set) var content: PublicPetProfileContent
    private weak var moduleOutput: PublicPetProfileModuleOutput?

    private let userRepository: UserRepository

    init(pet: Pet, userRepository: UserRepository, moduleOutput: PublicPetProfileModuleOutput) {
        self.content = PublicPetProfileContent(pet: pet)
        self.state = .content(content)
        self.userRepository = userRepository
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: PublicPetProfileIntent) {
        switch intent {
        case .onDidLoad:
            fetchUser()
        case .onClose:
            moduleOutput?.moduleOutputWantsToClose()
        case .onDismissAlert:
            state = .content(content)
        }
    }

    private func fetchUser() {
        state = .loading

        userRepository.fetchUser(for: content.pet.ownerId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] user in
                guard let self else { return }
                self.content.user = user
                self.state = .content(self.content)
            }
            .store(in: &bag)
    }
}
