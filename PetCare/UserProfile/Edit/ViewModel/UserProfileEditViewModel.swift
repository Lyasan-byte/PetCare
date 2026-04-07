//
//  UserProfileEditViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import Combine

final class UserProfileEditViewModel: UserProfileEditViewModeling {
    @Published private(set) var state: UserProfileEditState {
        didSet {
            stateDidChange.send()
        }
    }

    private(set) var stateDidChange = ObservableObjectPublisher()
    private let userProfileRepository: UserProfileRepository
    private weak var moduleOutput: UserProfileEditModuleOutput?
    private var bag = Set<AnyCancellable>()

    init(
        user: UserProfileUser,
        userProfileRepository: UserProfileRepository,
        moduleOutput: UserProfileEditModuleOutput?
    ) {
        self.state = UserProfileEditState(user: user)
        self.userProfileRepository = userProfileRepository
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: UserProfileEditIntent) {
        switch intent {
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

        state.isSaving = true

        userProfileRepository
            .save(user: makeUpdatedUser(), selectedPhoto: state.selectedPhotoData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                state.isSaving = false

                if case .failure(let error) = completion {
                    state.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] savedUser in
                self?.state.existingPhotoUrl = savedUser.avatarURLString
                self?.state.selectedPhotoData = nil
                self?.moduleOutput?.userProfileEditModuleDidSave()
            }
            .store(in: &bag)
    }

    private func makeUpdatedUser() -> UserProfileUser {
        UserProfileUser(
            id: state.userId,
            firstName: state.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: state.lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: state.email,
            avatarURLString: state.existingPhotoUrl
        )
    }
}
