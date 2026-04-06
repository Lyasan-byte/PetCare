//
//  RegistrationCompletionViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 06.04.2026.
//

import Foundation
import Combine

final class RegistrationCompletionViewModel: RegistrationCompletionViewModeling {
    @Published private(set) var state = RegistrationCompletionState() {
        didSet {
            stateDidChange.send()
        }
    }

    private(set) var stateDidChange = ObservableObjectPublisher()

    private let userProfileRepository: UserProfileRepository
    private weak var moduleOutput: RegistrationCompletionModuleOutput?
    private var bag = Set<AnyCancellable>()
    private var didLoadCurrentUser = false

    init(
        userProfileRepository: UserProfileRepository,
        moduleOutput: RegistrationCompletionModuleOutput?
    ) {
        self.userProfileRepository = userProfileRepository
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: RegistrationCompletionIntent) {
        switch intent {
        case .onDidLoad:
            loadCurrentUserIfNeeded()
        case .onChangeFirstName(let firstName):
            state.firstName = firstName
        case .onChangeLastName(let lastName):
            state.lastName = lastName
        case .onPickPhoto(let data):
            state.selectedPhotoData = data
        case .onSave:
            save()
        case .onDismissAlert:
            state.errorMessage = nil
        }
    }

    private func loadCurrentUserIfNeeded() {
        guard !didLoadCurrentUser else { return }
        didLoadCurrentUser = true
        state.isLoading = true

        userProfileRepository
            .fetchCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.state.isLoading = false

                if case .failure(let error) = completion {
                    self.state.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.applyLoadedUser(user)
            }
            .store(in: &bag)
    }

    private func applyLoadedUser(_ user: UserProfileUser) {
        state.userId = user.id
        state.email = user.email
        state.firstName = user.firstName
        state.lastName = user.lastName
        state.existingPhotoUrl = user.avatarURLString
        state.selectedPhotoData = nil
    }

    private func validateForm() -> String? {
        if state.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return NSLocalizedString("user.profile.edit.validation.first_name", comment: "")
        }

        if state.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return NSLocalizedString("user.profile.edit.validation.last_name", comment: "")
        }

        return nil
    }

    private func save() {
        if let validationError = validateForm() {
            state.errorMessage = validationError
            return
        }

        guard let userId = state.userId else {
            state.errorMessage = NSLocalizedString("error.common.try_again", comment: "")
            return
        }

        state.isLoading = true

        userProfileRepository
            .save(
                user: UserProfileUser(
                    id: userId,
                    firstName: state.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                    lastName: state.lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                    email: state.email,
                    avatarURLString: state.existingPhotoUrl
                ),
                selectedPhoto: state.selectedPhotoData
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.state.isLoading = false

                if case .failure(let error) = completion {
                    self.state.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] savedUser in
                guard let self else { return }
                self.state.firstName = savedUser.firstName
                self.state.lastName = savedUser.lastName
                self.state.existingPhotoUrl = savedUser.avatarURLString
                self.state.selectedPhotoData = nil
                self.moduleOutput?.registrationCompletionModuleDidFinish()
            }
            .store(in: &bag)
    }
}
