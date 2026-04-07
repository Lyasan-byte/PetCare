//
//  RegistrationCompletionViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 06.04.2026.
//

import Foundation
import Combine

final class RegistrationCompletionViewModel: RegistrationCompletionViewModeling {
    @Published private(set) var state: RegistrationCompletionState = .loading {
        didSet {
            stateDidChange.send()
        }
    }

    private(set) var stateDidChange = ObservableObjectPublisher()

    private let userProfileRepository: UserProfileRepository
    private weak var moduleOutput: RegistrationCompletionModuleOutput?
    private var bag = Set<AnyCancellable>()
    private var didLoadCurrentUser = false
    private var displayData = RegistrationCompletionDisplayData.empty

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
            displayData.firstName = firstName
            state = .content(displayData)
        case .onChangeLastName(let lastName):
            displayData.lastName = lastName
            state = .content(displayData)
        case .onPickPhoto(let data):
            displayData.selectedPhotoData = data
            state = .content(displayData)
        case .onSave:
            save()
        case .onDismissAlert:
            state = .content(displayData)
        }
    }

    private func loadCurrentUserIfNeeded() {
        guard !didLoadCurrentUser else { return }
        didLoadCurrentUser = true
        state = .loading

        userProfileRepository
            .fetchCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] user in
                self?.applyLoadedUser(user)
            }
            .store(in: &bag)
    }

    private func applyLoadedUser(_ user: UserProfileUser) {
        displayData.userId = user.id
        displayData.email = user.email
        displayData.firstName = user.firstName
        displayData.lastName = user.lastName
        displayData.existingPhotoUrl = user.avatarURLString
        displayData.selectedPhotoData = nil
        state = .content(displayData)
    }

    private func validateForm() -> String? {
        if displayData.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return NSLocalizedString("user.profile.edit.validation.first_name", comment: "")
        }

        if displayData.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return NSLocalizedString("user.profile.edit.validation.last_name", comment: "")
        }

        return nil
    }

    private func save() {
        if let validationError = validateForm() {
            state = .error(validationError)
            return
        }

        guard let userId = displayData.userId else {
            state = .error(NSLocalizedString("error.common.try_again", comment: ""))
            return
        }

        state = .loading

        userProfileRepository
            .save(
                user: UserProfileUser(
                    id: userId,
                    firstName: displayData.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                    lastName: displayData.lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                    email: displayData.email,
                    avatarURLString: displayData.existingPhotoUrl
                ),
                selectedPhoto: displayData.selectedPhotoData
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] savedUser in
                guard let self else { return }
                self.displayData.firstName = savedUser.firstName
                self.displayData.lastName = savedUser.lastName
                self.displayData.existingPhotoUrl = savedUser.avatarURLString
                self.displayData.selectedPhotoData = nil
                self.state = .content(self.displayData)
                self.moduleOutput?.registrationCompletionModuleDidFinish()
            }
            .store(in: &bag)
    }
}
